CREATE TABLE STATION (
  nomStation VARCHAR2(20) PRIMARY KEY,
  capacite NUMBER(4) NOT NULL,
  lieu VARCHAR2(100) NOT NULL,
  region VARCHAR2(50),
  tarif NUMBER(5) DEFAULT 0,
  CONSTRAINT UC_Lieu_Region UNIQUE (lieu, region),
  CONSTRAINT CK_Region CHECK (region IN ('Ocean Indien','Antilles','Europe','Amerique','Extreme Orient'))
);
INSERT INTO STATION VALUES ('meduse', 50, 'Paname', 'Antilles', 90);

CREATE TABLE ACTIVITY (
    nomStation VARCHAR2(20),
    libelle VARCHAR2(100),
    prix NUMBER(5) DEFAULT 0,
    CONSTRAINT PK_Station_Name_Libelle PRIMARY KEY (nomStation, libelle),
    CONSTRAINT FK_Station_Name FOREIGN KEY (nomStation) REFERENCES STATION(nomStation) ON DELETE CASCADE
  );


INSERT INTO ACTIVITY VALUES ('meduse', 'zoulou', 25);
INSERT INTO ACTIVITY VALUES ('meduse', 'mimi', 25);


CREATE TABLE CLIENT (
    id NUMBER(5) PRIMARY KEY,
    nom VARCHAR2(20) NOT NULL,
    prenom VARCHAR2(20) NOT NULL,
    ville VARCHAR2(20) NOT NULL,
    region VARCHAR2(50) NOT NULL,
    solde NUMBER(10) DEFAULT 0 NOT NULL
  );

INSERT INTO CLIENT VALUES (1, 'abdul', 'jiad', 'Paris', 'Ile de France', 25);
INSERT INTO CLIENT VALUES (2, 'tusher', 'jiad', 'Paris', 'Ile de France', 25);
INSERT INTO CLIENT VALUES (3, 'goku', 'san', 'Paris', 'Ile de France', 25);


CREATE TABLE SEJOUR (
    id NUMBER(5),
    station VARCHAR2(20) NOT NULL,
    debut DATE,
    nbrPlace NUMBER(10) NOT NULL,
    CONSTRAINT PK_Id_Station_Debut PRIMARY KEY (id, station, debut),
    CONSTRAINT FK_Station FOREIGN KEY (station) REFERENCES STATION(nomStation) ON DELETE CASCADE,
    CONSTRAINT FK_Client_ID FOREIGN KEY (id) REFERENCES CLIENT(id)
  );

CREATE OR REPLACE TRIGGER T_Prix
BEFORE INSERT OR UPDATE OF prix ON ACTIVITY
FOR EACH ROW
DECLARE
TARIF_STATION NUMBER(5);
BEGIN
  SELECT tarif INTO TARIF_STATION FROM STATION WHERE STATION.nomStation = :new.nomStation;
  IF(:new.prix NOT BETWEEN 0 and TARIF_STATION) THEN
    rails_application_error(-20001, 'Prix interieur à zero ou seupérieur a zero. ');
END IF;
END;


CREATE OR REPLACE TRIGGER T_Debut
BEFORE INSERT OR UPDATE ON SEJOUR
FOR EACH ROW
DECLARE
  PLACE_RESERVED NUMBER(4);
  CAPACITE_TOTAL_STATION NUMBER(4);
  BEGIN
    SELECT SUM(SEJOUR.nbrPlace) INTO PLACE_RESERVED FROM SEJOUR
    WHERE SEJOUR.debut = :new.station;

      IF PLACE_RESERVED IS NULL THEN
        PLACE_RESERVED := 0;
      END IF;

      SELECT capacite INTO CAPACITE_TOTAL_STATION FROM STATION S
      WHERE S.nomStation = :new.station;
        IF INSERTING THEN
          IF (:new.nbrPlace + PLACE_RESERVED > CAPACITE_TOTAL_STATION)
          THEN
            rails_application_error(-20012, 'Le nombre de place pouvant etre reservé est dépassé');
          END IF;
        END IF;

        IF UPDATING THEN
          IF (:new.nbrPlace + PLACE_RESERVED - :old.nbrPlace > CAPACITE_TOTAL_STATION) THEN
            rails_application_error('-20012', 'Le nombre de place pouvant etre reservé est dépasse :(');
          END IF;
        END IF;

  END;
  INSERT INTO SEJOUR VALUES (1,  'meduse', TO_DATE('27-12-2020', 'dd-mm-yyyy'), 25);
  INSERT INTO SEJOUR VALUES (2,  'meduse', TO_DATE('21-12-2020', 'dd-mm-yyyy'), 25);
  INSERT INTO SEJOUR VALUES (3,  'meduse', TO_DATE('20-12-2020', 'dd-mm-yyyy'), 25);




SELECT * FROM STATION;
SELECT * FROM ACTIVITY;
SELECT * FROM SEJOUR;
SELECT * FROM CLIENT;
