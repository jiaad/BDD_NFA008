/*====================== SELECTION ===============================*/


1 -
 SELECT titre FROM FILM;

2 -
 SELECT  nom,prenom FROM Internaute WHERE LOWER(region) = 'HAUTE-Normandie' OR region = 'Basse-Normandie' ;
 SELECT  nom,prenom FROM Internaute WHERE LOWER(region) LIKE '%Normandie';

3-
  SELECT titre, annee,genre FROM Film ORDER BY annee ASC;
  SELECT titre, annee,genre FROM Film ORDER BY annee DESC;

4-
  SELECT nom, annee_naissance FROM Artiste WHERE annee_naissance < 1950;

5-
  SELECT titre, annee FROM Film WHERE annee BETWEEN 1960 AND 1980;

6-
  SELECT DISTINCT genre FROM Film;

7-

  SELECT titre, genre, resume
  FROM Film
  WHERE UPPER(genre) IN('DRAME', 'WESTERN') AND UPPER(resume) LIKE '%VIE%';

8-
SELECT nom FROM Artiste where nom LIKE 'H%';

9-
SELECT nom, annee_naissance FROM Artiste WHERE annee_naissance = NULL;

10-
SELECT prenom, nom,(2020 -  annee_naissance) AS age FROM Artiste;




/*================================== 2 =============================*/
-- INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Matrix',63,'Morpheus');
1-
SELECT titre, id_acteur, nom_role FROM Role WHERE UPPER(nom_role) = 'MORPHEUS';

SELECT DISTINCT nom,prenom
FROM Role, Artiste
where id=id_acteur AND LOWER(nom_role)= 'morpheus';


SELECT DISTINCT nom, prenom
FROM Artiste
INNER JOIN ROLE
ON id = id_acteur
where  LOWER(nom_role)= 'morpheus';


2-
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Alien',1979,4,'Science-fiction','Pres d''un vaisseau spatial  echoue sur une lointaine planete, des Terriens en mission decouvrent de bien etranges oeufs. Ils en ramenent un a bord, ignorant qu''ils viennent d''introduire parmi eux un huitieme passager particulierement feroce et meurtrier. ','USA');

SELECT nom, prenom FROM Artiste, Film where id=id_realisateur AND LOWER(titre)='alien';
SELECT nom,prenom FROM Artiste
INNER JOIN Film
ON id=id_realisateur
WHERE LOWER(titre)='alien';

3-
INSERT INTO Notation (titre, email, note) VALUES ('La mort aux trousses','rigaux@cnam.fr',5);

SELECT DISTINCT nom,prenom, titre
FROM Internaute I, Notation N
WHERE I.email = N.email AND N.note=4;

4- Quels acteurs ont joué quel rôle dans le film Vertigo ?
SELECT A.nom,A.prenom, R.nom_role
FROM Artiste A, Role R
WHERE A.id = R.id_acteur AND LOWER(R.titre)='vertigo';

5. Films dont le réalisateur est Tim Burton, et un des acteurs est Jonnhy Depp.
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('American Beauty',19,'Carolyn Burnham');
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (6,'Cameron','James',1954);
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Pas de printemps pour Marnie',1964,3,'Thriller','Marnie est engagee comme secretaire chez un editeur, Mark Rutland. Celui-ci amoureux d''elle, decouvre qu''elle est kleptomane et l''oblige a l''epouser en la mena�ant de la denoncer. En s''apercevant que Marnie a la phobie de la cou leur rouge, Mark tente de remonter dans le passe de la jeune femme afin de comprendre les raisons de sa nevrose. ','USA');


SELECT F.titre
FROM Artiste A, Film F
WHERE A.id = F.id_realisateur AND LOWER(A.prenom)='tim' AND LOWER(A.nom)='burton'
INTERSECT
SELECT R.titre
FROM Artiste A, Role R WHERE a.id = R.id_acteur AND LOWER(A.nom)='depp' AND LOWER(A.prenom)='johnny';


6- Titre des films dans lesquels a joué Bruce Willis. Donner aussi le nom du rôle.

SELECT R.titre, R.nom_role
FROM Role R, Artiste A
WHERE R.id_acteur = A.id AND LOWER(A.nom)='willis' AND LOWER(A.prenom)='bruce';

7-  Quel metteur en scène a tourné dans ses propres films ? Donner le nom, le rôle et le titre des films.

SELECT A.nom, A.prenom
FROM ROLE R, Artiste A, Film F
WHERE F.titre = R.titre AND F.id_realisateur = A.id AND R.id_acteur=A.id;

8- Quel metteur en scène a tourné en tant qu’acteur (mais pas dans son propre film) ? Donner le nom, le
rôle et le titre des films où le metteur en scène a joué.
SELECT DISTINCT A.nom, A.prenom, R.nom_role, R.titre
FROM Artiste A, Film F, Role R
WHERE A.id = R.id_acteur AND A.id = F.id_realisateur
MINUS
SELECT DISTINCT A.nom, A.prenom, R.nom_role, R.titre
FROM Artiste A, Film F, Role R
WHERE  F.titre = R.titre AND F.id_realisateur = A.id AND R.id_acteur=A.id;
/*======================= END =====================================*/


CREATE TABLE Internaute (email VARCHAR (40) NOT NULL,
                         nom VARCHAR (30) NOT NULL ,
                         prenom VARCHAR (30) NOT NULL,
                         mot_de_passe VARCHAR (32) NOT NULL,
                         annee_naissance INTEGER,
                         PRIMARY KEY (email));

CREATE TABLE Pays (code    VARCHAR(4) NOT NULL,
                   nom  VARCHAR (30) DEFAULT 'Inconnu' NOT NULL,
                   langue VARCHAR (30) NOT NULL,
                   PRIMARY KEY (code));

CREATE TABLE Artiste  (id INTEGER NOT NULL,
                       nom VARCHAR (30) NOT NULL,
                       prenom VARCHAR (30) NOT NULL,
                       annee_naissance INTEGER,
                       PRIMARY KEY (id),
                       UNIQUE (nom, prenom));

CREATE TABLE Film  (titre    VARCHAR (50) NOT NULL,
                    annee    INTEGER NOT NULL,
                    id_realisateur  INTEGER,
                    genre VARCHAR(30) NOT NULL,
                    resume      CLOB, /* LONG pour ORACLE */
                    code_pays    VARCHAR (4),
                    PRIMARY KEY (titre),
                    FOREIGN KEY (id_realisateur) REFERENCES Artiste,
                    FOREIGN KEY (code_pays) REFERENCES Pays);

CREATE TABLE Notation (titre VARCHAR (50) NOT NULL,
                       email  VARCHAR (40) NOT NULL,
                       note  INTEGER NOT NULL,
                       PRIMARY KEY (titre, email),
                       FOREIGN KEY (titre) REFERENCES Film,
                       FOREIGN KEY (email) REFERENCES Internaute);

CREATE TABLE Role (titre  VARCHAR (50) NOT NULL,
                   id_acteur INTEGER NOT NULL,
                   nom_role  VARCHAR(60),
                   PRIMARY KEY (titre,id_acteur),
                   FOREIGN KEY (titre) REFERENCES Film,
                   FOREIGN KEY (id_acteur) REFERENCES Artiste);


                   /*  Compl�ments de la base Films  */

/*  On ajoute un champ 'region' pour l'internaute */

ALTER TABLE Internaute ADD region VARCHAR(30);

/* Liste des r�gions       */

CREATE TABLE Region (nom    VARCHAR (30) NOT NULL,
                    PRIMARY KEY (nom));

INSERT INTO Region (nom) VALUES ('Ile-de-France');
INSERT INTO Region (nom) VALUES ('Nord-Pas-De-Calais');
INSERT INTO Region (nom) VALUES ('Picardie');
INSERT INTO Region (nom) VALUES ('Haute-Normandie');
INSERT INTO Region (nom) VALUES ('Basse-Normandie');
INSERT INTO Region (nom) VALUES ('Bretagne');
INSERT INTO Region (nom) VALUES ('Centre');
INSERT INTO Region (nom) VALUES ('Champagne-Ardennes');
INSERT INTO Region (nom) VALUES ('Lorraine');
INSERT INTO Region (nom) VALUES ('Alsace');
INSERT INTO Region (nom) VALUES ('Bourgogne');
INSERT INTO Region (nom) VALUES ('Franche-Comt�');
INSERT INTO Region (nom) VALUES ('Pays-De-Loire');
INSERT INTO Region (nom) VALUES ('Poitou-Charentes');
INSERT INTO Region (nom) VALUES ('Aquitaine');
INSERT INTO Region (nom) VALUES ('Midi-Pyr�n�es');
INSERT INTO Region (nom) VALUES ('Limousin');
INSERT INTO Region (nom) VALUES ('Auvergne');
INSERT INTO Region (nom) VALUES ('Languedoc-Roussillon');
INSERT INTO Region (nom) VALUES ('Rh�ne-Alpes');
INSERT INTO Region (nom) VALUES ('PACA');
INSERT INTO Region (nom) VALUES ('Corse');
INSERT INTO Region (nom) VALUES ('DOM-TOM');
INSERT INTO Region (nom) VALUES ('Autre');

/* Liste des genres  */

CREATE TABLE Genre (code    VARCHAR (20) NOT NULL,
                    PRIMARY KEY (code));

INSERT INTO Genre (code) VALUES ('Histoire');
INSERT INTO Genre (code) VALUES ('Drame');
INSERT INTO Genre  (code) VALUES ('Suspense');
INSERT INTO Genre (code) VALUES ('Catastrophe');
INSERT INTO Genre  (code) VALUES ('Policier');
INSERT INTO Genre  (code) VALUES ('Thriller');
INSERT INTO Genre (code) VALUES ('Aventures');
INSERT INTO Genre (code) VALUES ('Science-fiction');
INSERT INTO Genre (code) VALUES ('Com�die');
INSERT INTO Genre (code) VALUES ('Com�die dramatique');
INSERT INTO Genre (code) VALUES ('Com�die sentimentale');
INSERT INTO Genre (code) VALUES ('Fantastique');
INSERT INTO Genre (code) VALUES ('Horreur');
INSERT INTO Genre (code) VALUES ('Action');
INSERT INTO Genre (code) VALUES ('Guerre');
INSERT INTO Genre (code) VALUES ('Dessin anim�');
INSERT INTO Genre (code) VALUES ('Documentaire');
INSERT INTO Genre (code) VALUES ('Western');



/*  Quelques pays */

INSERT INTO Pays (code, nom, langue)
          VALUES ('FR', 'France', 'Fran�ais');
INSERT INTO Pays (code, nom, langue)
          VALUES ('USA', 'Etats Unis', 'Anglais');
INSERT INTO Pays (code, nom, langue)
          VALUES ('IT', 'Italie', 'Italien');
INSERT INTO Pays (code, nom, langue)
          VALUES ('GB', 'Royaume-Uni', 'Anglais');
INSERT INTO Pays (code, nom, langue)
          VALUES ('DE', 'Allemagne', 'Allemand');
INSERT INTO Pays (code, nom, langue)
          VALUES ('JP', 'Japon', 'Japonais');





/* ============================= SECOND SCRIPT ==============================*/



INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (6,'Cameron','James',1954);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (3,'Hitchcock','Alfred',1899);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (4,'Scott','Ridley',1937);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (5,'Weaver','Sigourney',1949);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (9,'Tarkovski','Andrei',1932);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (10,'Woo','John',1946);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (11,'Travolta','John',1954);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (12,'Cage','Nicolas',1964);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (13,'Burton','Tim',1958);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (14,'Depp','Johnny',1964);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (15,'Stewart','James',1908);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (16,'Novak','Kim',1925);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (17,'Mendes','Sam',1965);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (18,'Spacey','Kevin',1959);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (19,'Bening','Anette',1958);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (20,'Eastwood','Clint',1930);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (21,'Hackman','Gene',1930);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (22,'Freeman','Morgan',1937);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (23,'Crowe','Russell',1964);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (24,'Ford','Harrison',1942);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (25,'Hauer','Rutger',1944);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (26,'McTierman','John',1951);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (27,'Willis','Bruce',1955);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (28,'Harlin','Renny',1959);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (29,'Pialat','Maurice',1925);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (30,'Dutronc','Jacques',1943);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (31,'Fincher','David',1962);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (32,'Pitt','Brad',1963);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (33,'Gilliam','Terry',1940);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (34,'Annaud','Jean-Jacques',1943);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (35,'Connery','Sean',1930);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (36,'Slater','Christian',1969);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (37,'Tarantino','Quentin',1963);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (38,'Jackson','Samuel L.',1948);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (39,'Arquette','Rosanna',1959);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (40,'Thurman','Uma',1970);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (41,'Farrelly','Bobby',1958);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (42,'Diaz','Cameron',1972);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (43,'Dillon','Mat',1964);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (44,'Schwartzenegger','Arnold',1947);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (45,'Spielberg','Steven',1946);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (46,'Scheider','Roy',1932);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (47,'Shaw','Robert',1927);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (48,'Dreyfus','Richard',1947);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (49,'Demme','Jonathan',1944);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (50,'Hopkins','Anthony',1937);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (51,'Foster','Jodie',1962);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (53,'Kilmer','Val',1959);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (54,'Fiennes','Ralph',1962);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (55,'Pfeiffer','Michelle',1957);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (56,'Bullock','Sandra',1964);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (57,'Goldblum','Jeff',1952);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (58,'Emmerich','Roland',1955);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (59,'Broderick','Matthew',1962);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (60,'Reno','Jean',1948);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (61,'Wachowski','Andy',1967);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (62,'Reeves','Keanu',1964);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (63,'Fishburne','Laurence',1961);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (64,'De Palma','Brian',1940);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (65,'Cruise','Tom',1962);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (66,'Voight','John',1938);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (67,'Bart','Emmanuelle',1965);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (68,'Kurozawa','Akira',1910);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (69,'Harris','Ed',1950);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (70,'Linney','Laura',1964);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (71,'Girault','Jean',1924);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (72,'De Funs','Louis',1914);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (73,'Galabru','Michel',1922);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (75,'Balasko','Josiane',1950);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (76,'Lavanant','Dominique',1944);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (77,'Lanvin','Grard',1950);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (78,'Villeret','Jacques',1951);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (79,'Levinson','Barry',1942);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (80,'Hoffman','Dustin',1937);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (81,'Scott','Tony',1944);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (82,'McGillis','Kelly',1957);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (83,'Leconte','Patrice',1947);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (84,'Blanc','Michel',1952);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (85,'Clavier','Christian',1952);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (86,'Lhermite','Thierry',1952);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (88,'Perkins','Anthony',1932);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (89,'Miles','Vera',1929);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (90,'Leigh','Janet',1927);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (91,'Marquand','Richard',1938);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (92,'Hamill','Mark',1951);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (93,'Fisher','Carrie',1956);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (94,'Taylor','Rod',1930);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (95,'Hedren','Tippi',1931);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (96,'Ricci','Christina',1980);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (97,'Walken','Christopher',1943);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (98,'Keitel','Harvey',1939);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (99,'Roth','Tim',1961);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (100,'Penn','Chris',1966);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (101,'Kubrick','Stanley',1928);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (102,'Kidman','Nicole',1967);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (103,'Nicholson','Jack',1937);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (104,'Kelly','Grace',1929);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (105,'Grant','Cary',1904);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (106,'Saint','Eva Marie',1924);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (107,'Mason','James',1909);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (110,'DiCaprio','Leonardo',1974);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (109,'Winslet','Kate',1975);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (111,'Besson','Luc',1959);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (112,'Jovovich','Milla',1975);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (113,'Dunaway','Fane',1941);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (114,'Malkovitch','John',1953);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (115,'Karyo','Tchky',1953);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (116,'Oldman','Gary',1958);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (117,'Holm','Ian',1931);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (118,'Portman','Natalie',1981);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (119,'Parillaud','Anne',1960);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (120,'Anglade','Jean-Hughes',1955);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (121,'Barr','Jean-Marc',1960);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (122,'Ferrara','Abel',1951);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (123,'Caruso','David',1956);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (124,'Snipes','Wesley',1962);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (125,'Sciora','Annabella',1964);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (126,'Rosselini','Isabella',1952);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (127,'Gallo','Vincent',1961);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (128,'von Trier','Lars',1956);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (129,'Gudmundsdottir','Bjork',1965);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (130,'Deneuve','Catherine',1943);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (131,'Kassowitz','Matthieu',1967);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (132,'Cassel','Vincent',1966);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (133,'Gray','James',1969);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (134,'Wahlberg','Mark',1971);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (135,'Phoenix','Joaquin',1974);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (136,'Theron','Charlize',1975);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (137,'Caan','James',1940);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (138,'Chabrol','Claude',1930);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (139,'Huppert','Isabelle',1953);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (140,'Mouglalis','Anna',1978);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (141,'Costner','Kevin',1955);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (142,'Dern','Laura',1967);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (143,'Hanks','Tom',1956);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (144,'Sizemore','Tom',1964);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (145,'Damon','Matt',1970);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (146,'Modine','Matthew',1959);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (147,'Baldwin','Adam',1962);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (148,'O''Neal','Ryan',1941);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (149,'Berenson','Marisa',1946);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (150,'McDowell','Macolm',1943);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (151,'Dullea','Keir',1936);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (152,'Lockwood','Gary',1937);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (153,'Sellers','Peter',1925);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (154,'Scott','George',1927);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (155,'Hayden','Sterling',1916);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (156,'Douglas','Kirk',1916);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (157,'Donat','Robert',1905);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (158,'Caroll','Madeleine',1906);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (159,'Olivier','Laurence',1907);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (160,'Fontaine','Joan',1917);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (161,'Sanders','George',1906);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (162,'Bergman','Ingrid',1915);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (163,'Rains','Claude',1889);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (164,'Milland','Ray',1907);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (166,'Day','Doris',1924);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (167,'De Niro','Robert',1943);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (168,'Grier','Pam',1949);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (169,'Fonda','Bridget',1964);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (170,'Keaton','Michael',1951);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (171,'Shyamalan','M. Night',1970);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (172,'Osment','Haley Joel',1988);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (173,'Collette','Tony',1972);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (174,'Leighton','Eric',1962);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (175,'Mann','Michael',1943);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (176,'Pacino','Al',1940);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (177,'Crowe','Russel',1964);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (178,'Plummer','Christopher',1927);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (179,'Furlong','Edward',1977);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (180,'Redgrave','Vanessa',1937);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (181,'Coppola','Francis Ford',1939);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (182,'Brando','Marlon',1924);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (183,'Keaton','Diane',1946);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (184,'Duvall','Robert',1931);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (185,'Caan','Jamees',1939);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (186,'Garcia','Andy',1956);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (187,'Raimi','Sam',1959);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (188,'Maguire','Tobey',1975);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (210,'Moss','Carrie-Anne',1967);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (211,'Weaving','Hugo',1960);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (212,'Jackson','Samuel',1948);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (213,'Liu','Lucy',1968);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (214,'Carradine','David',1936);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (215,'Madsen','Michael',1958);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (216,'Hannah','Daryl',1960);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (217,'Buscemi','Steve',1957);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (218,'Bunker','Edward',1933);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (221,'Volonte','Gian Maria',1933);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (220,'Van Cleef','Lee',1925);
INSERT INTO Artiste (id, nom, prenom, annee_naissance) VALUES (219,'Leone','Sergio',1929);

--
-- Dumping data for table `Internaute`


INSERT INTO Internaute (email, nom, prenom, mot_de_passe, annee_naissance, region) VALUES ('rigaux@cnam.fr','Rigaux','Philippe','262727b3923e1f4abe4383326493823e',1963,'Ile-de-France');
INSERT INTO Internaute (email, nom, prenom, mot_de_passe, annee_naissance, region) VALUES ('davy@bnf.fr','Davy','Cecile','262727b3923e1f4abe4383326493823e',0,'Basse-Normandie');
INSERT INTO Internaute (email, nom, prenom, mot_de_passe, annee_naissance, region) VALUES ('toto','rigaux','Philippe','a6105c0a611b41b08f1209506350279e',1963,'Aquitaine');
INSERT INTO Internaute (email, nom, prenom, mot_de_passe, annee_naissance, region) VALUES ('waller@lri.fr','Waller','Emmanuel','084b8f50602d643c07b06ed385150e2a',1962,'Aquitaine');
INSERT INTO Internaute (email, nom, prenom, mot_de_passe, annee_naissance, region) VALUES ('rigaux@cnam.com','jojo bil ko','Philippe','7510d498f23f5815d3376ea7bad64e29',1963,'Ile-de-France');

--
-- Dumping data for table `Film`
--

INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Vertigo',1958,3,'Drame','Scottie Ferguson, ancien inspecteur de police, est sujet au vertige depuis qu''il a vu mourir son collegue. Elster, son ami, le charge de surveiller sa femme, Madeleine, ayant des tendances suicidaires. Amoureux de la jeune femme Scottie ne remarque pas le piege qui se trame autour de lui et dont il va �tre la victime... ','USA');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Alien',1979,4,'Science-fiction','Pres d''un vaisseau spatial  echoue sur une lointaine planete, des Terriens en mission decouvrent de bien etranges oeufs. Ils en ramenent un a bord, ignorant qu''ils viennent d''introduire parmi eux un huitieme passager particulierement feroce et meurtrier. ','USA');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Titanic',1997,6,'Drame','Conduite par Brock Lovett, une expedition americaine fouillant l''epave du Titanic remonte a la surface le croquis d''une femme nue. Alertee par les medias la dame en question, Rose DeWitt Bukater, aujourd''hui centenaire, rejoint les lieux du naufrage, d''o� elle entreprend de conter le recit de son fascinant, etrange et tragique voyage... ','USA');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Sacrifice',1986,9,'Drame','','FR');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Volte/Face',1997,10,'Action','Directeur d''une unite anti-terroriste, Sean Archer recherche Castor Troy, un criminel responsable de la mort de son fils six ans plus t�t. Il parvient a l''arr�ter mais apprend que Troy a cache une bombe au Palais des Congres de Los Angeles. Seul le frere de Troy peut la desamorcer et, pour l''approcher, Archer se fait greffer le visage de Troy. ','USA');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Sleepy Hollow',1999,13,'Fantastique','Nouvelle Angleterre, 1799. A Sleepy Hollow, plusieurs cadavres sont retrouves decapites. La rumeur attribue ces meurtres a un cavalier lui-m�me sans t�te. Mais le fin limier                                      new-yorkais Ichabod Crane ne croit pas en ses aberrations. Tombe sous le charme de la                                      veneneuse Katrina, il mene son enqu�te au coeur des sortileges de Sleepy Hollow.. ','USA');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('American Beauty',1999,17,'Comedie','Lester Burnham, sa femme Carolyn et leur fille Jane menent apparemment une vie des plus heureuses dans leur belle banlieue. Mais derriere cette respectable fa�ade se tisse une etrange et grin�ante tragi-comedie familiale o� desirs inavoues, frustrations et violences refoulees conduiront inexorablement un homme vers la mort. ','USA');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Impitoyable',1992,20,'Western','Legendaire hors-la-loi, William Munny s''est reconverti depuis onze ans en paisible fermier. Il reprend neanmoins les armes pour traquer deux tueurs en compagnie de son vieil ami Ned Logan. Mais ce dernier est capture, puis execute. L''honneur et l''amitie imposent des lors a Munny de redevenir une derniere fois le heros qu''il fut jadis... ','USA');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Gladiator',2000,4,'Drame','Le general romain Maximus est le plus fidele soutien de l''empereur Marc Aurele, qu''il conduit de victoire en victoire avec une bravoure et un devouement exemplaires.Jaloux du prestige de Maximus, et plus encore de l''amour que lui voue l''empereur,le fils de Marc-Aurele, Commode, s''arroge brutalement le pouvoir, puis ordonnel''arrestation du general et son execution. Maximus echappe a ses assassins mais ne peut emp�cher le massacre de sa famille. Capture par un marchand d''esclaves, il devient gladiateur et prepare sa vengeance.','USA');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Blade Runner',1982,4,'Action','En 2019, lors de la decadence de Los Angeles, des �tres synthetiques, sans pensee, sans emotions, suffisent aux differents travaux d''entretien. Leur duree de vie n''excede pas 4 annees.Un jour, ces ombres humaines se revoltent et on charge les tueurs, appeles Blade Runner, de les abattre... ','USA');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Piege de cristal',1988,26,'Action','John Mc Clane, policier new-yorkais, vient passer Noel a Los Angeles aupres de sa femme.Dans le building ou elle travaille, il se retrouve temoin de la prise en otage de tout le personnel par 12 terroristes. Objectif de ces derniers, vider les coffres de la societe. Cache mais isole, il entreprend de prevenir l''exterieur...','USA');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('58 minutes pour vivre',1990,28,'Action',' Venu attendre sa femme a l''aeroport, le policier John McClane remarque la presence de terroristes qui ont pris le contr�le des pistes, emp�chant tout avion d''atterrir et mena�ant de laisser les appareils en vol tourner jusqu''a epuisement de leur kerosene. John n''a devant lui que 58 minutes pour eviter la catastrophe... ','USA');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Van Gogh',1990,29,'Drame','Les derniers jours de la vie de Vincent Van Gogh, refugie a Auvers-sur-Oise, pres de chez son ami et protecteur le docteur Gachet, un ami de son frere Theo. Ce peintre maudit, que les villageois surnommaient ''le fou'', n''avait alors plus que deux mois a vivre, qu''il passa en peignant un tableau par jour. ','FR');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Seven',1995,31,'Policier','A New York, un criminel anonyme a decide de commettre 7 meurtres bases sur les 7 p�ches capitaux enonces dans la Bible : gourmandise, avarice, paresse, orgueil, luxure, envie et colere. Vieux flic blase a 7 jours de la retraite, l''inspecteur Somerset mene l''enqu�te tout en formant son rempla�ant, l''ambitieux inspecteur David Mills... ','USA');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('L''armee des douze singes',1995,33,'Science-fiction','','USA');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Le nom de la rose',1986,34,'Policier','En l''an 1327, dans une abbaye benedictine, le moine franciscain Guillaume de Baskerville,accompagne de son jeune novice Adso, enqu�te sur de mysterieuses morts qui frappent la confrerie. Le secret semble resider dans la bibliotheque, o� le vieux Jorge garde jalousement un livre juge maudit. ','FR');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Pulp fiction',1994,37,'Action','Pulp Fiction decrit l''odyssee sanglante et burlesque de petits malfrats dans la jungle de Hollywood, ou s''entrecroisent les destins de deux petits tueurs, d''un dangereux gangster marie a une camee, d''un boxeur roublard, de pr�teurs sur gages sadiques, d''un caid elegant et devoue, d''un dealer bon mari et de deux tourtereaux a la gachette facile... ','USA');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Mary a tout prix',1998,41,'Comedie','Pour retrouver l''amour de sa jeunesse, la belle Mary, Ted-le-looser engage Pat Healy, un prive. Subjuge par la jeune femme, ce dernier tente de la seduire en se faisant passer pour un architecte. Il cache la verite a Ted et fait cause commune avec Tucker, un autre pretendant, pour se debarrasser de l''encombrant Ted... ','USA');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Terminator',1984,6,'Science-fiction','Deux creatures venues du futur debarquent sur terre. L''une d''entre elles, le Terminator, doit eliminer une certaine Sarah Connor, qui doit enfanter celui qui sera le chef d''un groupe de resistants. L''autre, Kyle Reese, est charge par les rebelles de defendre Sarah... ','USA');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Les dents de la mer',1975,45,'Horreur','Dans la station balneaire d''Amityville, un requin geant frappe a plusieurs reprises. Soucieux d''une bonne saison touristique, le maire interdit au sherif Brody de fermer les plages. Une prime est offerte et le celebre chasseur de requin Quint se lance avec Brody et l''ichtyologue Hooper a la poursuite du monstre... ','FR');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Le silence des agneaux',1990,49,'Policier','Afin de retrouver la piste d''un tueur surnomme Buffalo Bill car il scalpe les femmes qu''il assassine, la jeune stagiaire du FBI Clarice Starling est dep�chee aupres d''Hannibal Lecter, prisonnier pour avoir devore ses victimes. La cooperation de ce dernier devrait permettre a Clarice de saisir et d''anticiper le comportement de Buffalo... ','USA');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Godzilla',1998,58,'Action','Issu des radiations atomiques engendrees par les essais nucleaires en Polynesie, un monstre gigantesque, aussi haut qu''un building, se dirige vers New York, semant le chaos sur son passage. Pour tenter de stopper cette creature destructrice, l''armee s''associe a une equipe de scientifiques americains et a un enigmatique enqu�teur fran�ais... ','USA');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Matrix',1999,61,'Science-fiction','Dans un monde o� tout ce qui semble reel est en fait elabore par l''univers electronique baptise la Matrice, Neo, un programmeur, est contacte par un certain Morpheus. D''apres lui, Neo serait le Liberateur tant attendu, le seul capable de mettre en echec l''omnipotence de la Matrice et rendre ses droits a la realite... ','USA');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Mission: Impossible',1996,64,'Action','Charge d''une nouvelle mission, l''agent du contre espionnage Ethan Hunt tombe avec son equipe dans un piege sanglant. Seul survivant avec Claire, la jeune epouse de son regrette chef Jim Phelps, Ethan se retrouve accuse de trahison. En fuite, il prepare sa contre-attaque, recrutant l''homme de main Krieger et le pirate informatique Luther... ','USA');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Kagemusha',1980,68,'Guerre','Au XVIe siecle, Takeda, grand seigneur trouble par les guerres civiles de son pays, fait appel a un Kagemusha pour l''aider dans ses batailles. Takeda est blesse et avant de mourir, il exige que sa mort soit tenue secrete pendant trois ans afin d''eviter un eclatement du clan. Le Kagemusha devra le remplacer... ','JP');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Les pleins pouvoirs',1997,20,'Policier','Luther Whitney est l''as des cambrioleurs. Occupe a vider le coffre de l''influent Walter Sullivan, il est temoin d''un meurtre sadique impliquant le President des Etats-Unis et les services secrets. Soup�onne par la police d''en �tre l''auteur, il se retrouve egalement traque par les tueurs, qui ont compris qu''ils ont ete observes.','USA');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Le gendarme et les extra-terrestres',1978,71,'Comedie','En anglais: Gendarme and the Creatures from Outer Space !','FR');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Le monde perdu',1997,45,'Horreur','','USA');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Rain Man',1988,79,'Drame','A la mort de son pere, Charlie se voit deposseder de son heritage par un frere dont il ignorait l''existence, Raymond. Celui-ci est autiste et vit dans un h�pital psychiatrique. Charlie enleve Raymond afin de prouver qu''il est capable de s''en occuper et de toucher l''heritage. ','USA');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Top Gun',1986,81,'Action',' Pilote de chasse emerite mais casse-cou Maverick Mitchell est admis a Top Gun, l''ecole de l''elite de l''aeronavale. Son manque de prudence lui attire les foudres de ses superieurs et la haine de certains coequipiers. Il perd subitement la foi et confiance en lui quand son ami de toujours meurt en vol et qu''il s''en croit responsable... ','USA');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Les bronzes font du ski',1979,83,'Comedie','Apres avoir passe des vacances d''ete ensemble, Bernard, Nathalie, Gigi, Jerome, Popeye, Jean-Claude et Christiane se retrouvent aux sports d''hiver. Tous ont leurs problemes de coeur ou d''argent, mais il faut bien vivre avec. Avant de se separer, se perdre dans la montagne leur permet de gouter aux joies de la ''vraie vie'' paysanne... ','FR');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Le bon, la brute et le truand',1966,219,'Western','Pendant la Guerre de Secession, trois hommes, preferant s''interesser a leur profit personnel, se lancent a la recherche d''un coffre contenant 200 000 dollars en pieces d''or voles a l''armee sudiste. Tuco sait que le tresor se trouve dans un cimetiere, tandis que Joe conna�t le nom inscrit sur la pierre tombale qui sert de cache. Chacun a besoin de l''autre. Mais un troisieme homme entre dans la course : Setenza, une brute qui n''hesite pas a massacrer femmes et enfants pour parvenir a ses fins.','IT');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Psychose',1960,3,'Thriller','Apres avoir vole 40 000 dollars, Marion Crane se rend dans un motel tenu par Norman Bates. Elle est poignardee sous sa douche par une femme. Norman fait disparaitre le corps et les affaires de la jeune femme. Mais Sam, le fiance de Marion, inquiet de ne pas avoir de nouvelles, engage un detective pour la retrouver... ','USA');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Le retour du Jedi',1983,91,'Science-fiction','Luke Skywalker s''introduit chez Jabba pour delivrer Han Solo et la princesse Leia, tandis que l''Empire reconstruit une deuxieme Etoile de la Mort. Luke se rend ensuite au chevet de Yoda qui est mourant. Il lui apprend que Leia est sa soeur. Luke forme un commando pour attaquer l''Etoile, tandis qu''il affronte son pere, Darth Vador... ','USA');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Les oiseaux',1963,3,'Horreur','Melanie Daniels se rend a Bodega Bay pour offrir deux perruches en cage a Cathy, la soeur de l''avocat Mitch Brenner. Attaquee par une mouette, Melanie reste chez les Brenner pour la nuit. Mais d''autres evenements etranges se produisent: des enfants sont blesses par des corbeaux et la maison de Mitch est envahie par des milliers d''oiseaux. ','USA');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Reservoir dogs',1992,37,'Policier','Apres un hold-up manque, des cambrioleurs de haut vol font leurs comptes dans une confrontation violente, pour decouvrir lequel d''entre eux les a trahis. Voleurs de profession, Joe Cabot et son fils Eddie engagent un groupe de six criminels pour le cambriolage d''un diamantaire. Malgre toutes les precautions prises, la police est sur place le jour J, et l''operation se solde par un massacre. Les survivants du gang se reunissent pour regler leurs comptes, chacun soup�onnant l''autre d''avoir trahi. ','USA');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Eyes Wide Shut',1999,101,'Thriller','Un couple de bourgeois, cedant a la jalousie et a l''obsession sexuelle, entreprend un voyage psychologique a la recherche de son identite. Le mari, au bout de son periple nocturne, revenu de ses desirs, ne trouvera finalement aupres de son epouse qu''un compromis banal mais complice, les yeux ouverts a tout jamais sur un r�ve impossible. ','USA');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Shining',1980,101,'Horreur','Jack Torrance s''installe avec sa femme et son fils Danny dans un h�tel ferme a la morte saison afin d''ecrire un roman. Il apprend que le gardien precedent a tue sa femme et ses deux filles avant de se suicider. Tres vite, Jack va s''apercevoir que des choses etranges se passent autour de lui et que son fils a des pouvoirs extrasensoriels... ','FR');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Pas de printemps pour Marnie',1964,3,'Thriller','Marnie est engagee comme secretaire chez un editeur, Mark Rutland. Celui-ci amoureux d''elle, decouvre qu''elle est kleptomane et l''oblige a l''epouser en la mena�ant de la denoncer. En s''apercevant que Marnie a la phobie de la cou leur rouge, Mark tente de remonter dans le passe de la jeune femme afin de comprendre les raisons de sa nevrose. ','USA');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Fen�tre sur cour',1954,3,'Suspense','En repos force a cause d''une jambe pl�tree, le reporter L.B. Jefferies observe au teleobjectif les voisins de l''immeuble d''en face. C''est ainsi qu''il remarque le curieux manege d''un representant de commerce, M. Thorwald, qu''il soupconne tres vite d''avoir assassine sa femme... ','USA');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('La mort aux trousses',1959,3,'Suspense','Roger Thornhill, publiciste, est pris dans le hall de son h�tel pour un certain Kaplan, un espion. Deux hommes tentent de le tuer et quand il retrouve l''un de ses agresseurs, celui-ci est assassine devant ses yeux. Pris pour un meurtrier, il est oblige de fuir vers Chicago... ','USA');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Jeanne d''Arc',1999,111,'Guerre','','FR');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Le cinquieme element',1997,111,'Science-fiction','Au XXIIIeme siecle, dans un univers etrange et colore, o� tout espoir de survie est impossible sans la decouverte du Cinquieme Element, un heros peu ordinaire affronte le mal pour sauver l''humanite. ','FR');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Leon',1994,111,'Action','Leon est un tueur. Un de la pire espece. Il est introuvable, indetectable, pire qu''un sous-marin. Son ombre est comme une menace de danger permanent sur New York. Indestructible Leon ? Oui, jusqu''a ce qu''une petite souris penetre son univers. Une toute petite souris aux yeux immenses... ','FR');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Nikita',1990,111,'Thriller','Nikita, droguee et violente, est prise en mains par des psychiatres qui la reeduquent, la conditionnent, afin d''en faire une tueuse a la botte des Services Secrets. Plus tard, realisant ce qu''elle est devenue, un pion sans vie privee que l''on manipule, elle tente d''echapper a ses commanditaires. ','FR');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Le grand bleu',1988,111,'Drame','Jacques Mayol et Enzo Molinari se connaissent depuis l''enfance. Tous deux experts en apnee, s''affrontent continuellement pour obtenir le record du monde de plongee. Toujours en rivalite, les deux hommes descendent de plus en plus profond, au risque de leurs vies. Le film est ressorti en janvier 89 en version longue d''une duree de 2h40. ','FR');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Spider-Man',2002,123,'Action','Orphelin, Peter Parker est eleve par sa tante May et son oncle Ben dans le quartier Queens de New York. Tout en poursuivant ses etudes a l''universite, il trouve un emploi de photographe au journal Daily Bugle. Il partage son appartement avec Harry Osborn, son meilleur ami, et r�ve de seduire la belle Mary Jane. Cependant, apres avoir ete mordu par une araignee genetiquement modifiee, Peter voit son agilite et sa force s''accro�tre et se decouvre des pouvoirs surnaturels. Devenu Spider-Man, il decide d''utiliser ses nouvelles capacites au service du bien. Au m�me moment, le pere de Harry, le richissime industriel Norman Osborn, est victime d''un accident chimique qui a demesurement augmente ses facultes intellectuelles et sa force, mais l''a rendu fou. Il est devenu le Bouffon Vert, une creature demoniaque qui menace la ville. Entre lui et Spider-Man, une lutte sans merci s''engage.','USA');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('King of New York',1990,122,'Drame','L''histoire d''un gangster au grand coeur mais aux methodes definitives, surnomme par le presse The King of New York et qui r�ve de fonder un h�pital, confronte a des policiers opini�tres qui ont jure de l''abattre...','USA');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('The Matrix reloaded',2003,61,'Science-fiction','Neo apprend a mieux contr�ler ses dons naturels, alors m�me que Sion s''appr�te a tomber sous l''assaut de l''Armee des Machines. D''ici quelques heures, 250 000 Sentinelles programmees pour aneantir notre espece envahiront la derniere enclave humaine de la Terre. Mais Morpheus galvanise les citoyens de Sion en leur rappelant la Parole de l''Oracle : il est encore temps pour l''Elu d''arr�ter la guerre contre les Machines. Tous les espoirs se reportent des lors sur Neo. Au long de sa perilleuse plongee au sein de la Matrix et de sa propre destinee, ce dernier sera confronte a une resistance croissante, une verite encore plus aveuglante, un choix encore plus douloureux que tout ce qu''il avait jamais imagine.','USA');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('The Matrix Revolutions',2003,135,'Science-fiction','La longue qu�te de liberte des rebelles culmine en une bataille finale explosive. Tandis que l''armee des Machines seme la desolation sur Zion, ses citoyens organisent une defense acharnee. Mais pourront-ils retenir les nuees implacables des Sentinelles en attendant que Neo s''approprie l''ensemble de ses pouvoirs et mette fin a la guerre ? L''agent Smith est quant a lui parvenu a prendre possession de l''esprit de Bane, l''un des membres de l''equipage de l''aeroglisseur. De plus en plus puissant, il est desormais incontr�lable et n''obeit plus aux Machines : il menace de detruire leur empire ainsi que le monde reel et la Matrice...','USA');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('De bruit et de fureur',1988,138,'Drame','L''histoire de Bruno, enfant attarde des banlieues et des H.L.M., plonge dans la violence de son milieu, et dont la vie va se consumer comme une etoile filante.','FR');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Usual suspects',1995,142,'Thriller','Une legende du crime contraint cinq malfrats a aller s''aquitter d''une t�che tres perilleuse. Ceux qui survivent pourront se partager un butin de 90 millions de dollars.','USA');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Bad Lieutenant',1992,122,'Drame','La descente aux enfers d''un flic pourri qui enquete sur le viol d''une jolie religieuse.','USA');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Le parrain',1972,64,'Drame','En 1945, a New York, les Corleone sont une des cinq familles de la mafia. Don Vito Corleone, ''parrain'' de cette famille, marie sa fille a un bookmaker. Sollozzo, ''parrain '' de la famille Tattaglia, propose a Don Vito une association dans le trafic de drogue, mais celui-ci refuse. Sonny, un de ses fils, y est quant a lui favorable. Afin de traiter avec Sonny, Sollozzo tente de faire tuer Don Vito, mais celui-ci en rechappe. Michael, le frere cadet de Sonny, recherche alors les commanditaires de l''attentat et tue Sollozzo et le chef de la police, en represailles. Michael part alors en Sicile, o� il epouse Apollonia, mais celle-ci est assassinee a sa place. De retour a New York, Michael epouse Kay Adams et se prepare a devenir le successeur de son pere...','USA');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Le parrain II',1974,64,'Drame','A la mort de Vito Corleone, dit : le Parrain, c''est son fils, Michael, qui reprend les affaires familiales. Tres vite, son ascension dans le milieu mafiosi est fulgurante. Depuis la mort De Don Vito Corleone, son fils, Michael, regne sur la famille. Amene a negocier avec la mafia juive, il perd alors le soutien d''un de ses lieutenants, Frankie Pentageli. Echappant de justesse a un attentat, Michael tente de retrouver le coupable, soup�onnant Hyman Roth, le chef de la mafia juive. Vito Corleone, immigrant italien, arrive a New York au debut du siecle ; tres vite, il devient un des ca�ds du quartier, utilisant la violence comme moyen de regler toutes les affaires. Seul au depart, il b�tit peu a peu un veritable empire, origine de la fortune de la famille des Corleone. ','USA');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Le parrain III',1990,64,'Drame','Atteignant la soixantaine, Michael Corleone desire a la fois renouer avec les siens et se rehabiliter aux yeux de la societe, surtout de l''Eglise. Il arrivera presque a ses fins, mais sa vie passee et ses anciens ennemis le rattraperont plus vite. Michael Corleone est fatigue. Il veut prendre ses distances avec les activites mafieuses de sa famille. Il veut convertir ces activites en affaires legales. Kay, son ex-femme, lui fait m�me accepter que leur fils devienne un chanteur d''opera et ne reprenne pas les activites familiales. Pendant ce temps, la fille de Michael, Mary, et son neveu, le fils de Sonny, Vincent, nouent une idylle qui n''est pas la bienvenue dans la famille. Il decide d''aider le Vatican a renflouer ses caisses et re�oit en echange le contr�le d''une entreprise immobiliere leur appartenant. Attisant la jalousie de ses pairs, Michael echappe de justesse a un attentat commis par l''un d''eux. Vincent se propose alors pour reprendre les affaires de la famille en main.','USA');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Jackie Brown',1997,37,'Policier','Jackie Brown, h�tesse de l''air, arrondit ses fins de mois en convoyant de l''argent liquide pour le compte d''un trafiquant d''armes, Ordell Robbie. Un jour, un agent federal et un policier de Los Angeles la cueillent a l''aeroport. Ils comptent sur elle pour faire tomber le trafiquant. Jackie echafaude alors un plan audacieux pour doubler tout le monde lors d''un prochain transfert qui porte sur la modeste somme de cinq cent mille dollars. Mais il lui faudra compter avec les complices d''Ordell, qui ont des methodes plut�t expeditives.','USA');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Une journee en enfer',1995,168,'Action','John McClane est cette fois-ci aux prises avec un ma�tre chanteur, facetieux et dangereux, qui depose des bombes dans New York.','USA');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Sixieme sens',1999,170,'Fantastique','Cole Sear, garconnet de huit ans est hante par un terrible secret. Son imaginaire est visite par des esprits menacants. Trop jeune pour comprendre le pourquoi de ces apparitions et traumatise par ces pouvoirs paranormaux, Cole s''enferme dans une peur maladive et ne veut reveler a personne la cause de son enfermement, a l''exception d''un psychologue pour enfants. La recherche d''une explication rationnelle guidera l''enfant et le therapeute vers une verite foudroyante et inexplicable.','USA');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Lost in Translation',2003,172,'Comedie sentimentale','Bob Harris, acteur sur le declin, se rend a Tokyo pour touner un spot publicitaire. Il a conscience qu''il se trompe - il devrait �tre chez lui avec sa famille, jouer au the�tre ou encore chercher un r�le dans un film -, mais il a besoin d''argent. Du haut de son h�tel de luxe, il contemple la ville, mais ne voit rien. Il est ailleurs, detache de tout, incapable de s''integrer a la realite qui l''entoure, incapable egalement de dormir a cause du decalage horaire. Dans ce m�me etablissement, Charlotte, une jeune Americaine fra�chement dipl�mee, accompagne son mari, photographe de mode. Ce dernier semble s''interesser davantage a son travail qu''a sa femme. Se sentant delaissee, Charlotte cherche un peu d''attention. Elle va en trouver aupres de Bob...','USA');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Kill Bill',2003,37,'Drame','Au cours d''une ceremonie de mariage en plein desert, un commando fait irruption dans la chapelle et tire sur les convives. Laissee pour morte, la Mariee enceinte retrouve ses esprits apres un coma de quatre ans. Celle qui a auparavant exerce les fonctions de tueuse a gages au sein du Detachement International des Viperes Assassines n''a alors plus qu''une seule idee en t�te : venger la mort de ses proches en eliminant tous les membres de l''organisation criminelle, dont leur chef Bill qu''elle se reserve pour la fin.','USA');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Stalingrad',2001,34,'Drame','','USA');
INSERT INTO Film (titre, annee, id_realisateur, genre, resume, code_pays) VALUES ('Pour quelques dollars de plus',1965,219,'Western','Le colonel Douglas Mortimer collabore avec un chasseur de primes surnomme : L''Etranger. Tous les deux souhaitent capturer Indio, un tueur fou, qui seme la terreur autour de lui. Ce dernier et ses hommes sont sur le point de piller la banque d''El Paso.','IT');



INSERT INTO Notation (titre, email, note) VALUES ('La mort aux trousses','rigaux@cnam.fr',5);
INSERT INTO Notation (titre, email, note) VALUES ('Kill Bill','rigaux@cnam.fr',4);
INSERT INTO Notation (titre, email, note) VALUES ('Mission: Impossible','rigaux@cnam.fr',3);
INSERT INTO Notation (titre, email, note) VALUES ('Les dents de la mer','rigaux@cnam.fr',4);
INSERT INTO Notation (titre, email, note) VALUES ('Nikita','rigaux@cnam.fr',3);
INSERT INTO Notation (titre, email, note) VALUES ('Alien','rigaux@cnam.fr',5);
INSERT INTO Notation (titre, email, note) VALUES ('Van Gogh','rigaux@cnam.fr',4);
INSERT INTO Notation (titre, email, note) VALUES ('Titanic','rigaux@cnam.fr',5);
INSERT INTO Notation (titre, email, note) VALUES ('Terminator','rigaux@cnam.fr',2);
INSERT INTO Notation (titre, email, note) VALUES ('Seven','rigaux@cnam.fr',3);
INSERT INTO Notation (titre, email, note) VALUES ('Le cinquieme element','rigaux@cnam.fr',2);
INSERT INTO Notation (titre, email, note) VALUES ('Le parrain','rigaux@cnam.fr',5);
INSERT INTO Notation (titre, email, note) VALUES ('Psychose','davy@bnf.fr',5);
INSERT INTO Notation (titre, email, note) VALUES ('Leon','davy@bnf.fr',1);
INSERT INTO Notation (titre, email, note) VALUES ('Eyes Wide Shut','davy@bnf.fr',3);
INSERT INTO Notation (titre, email, note) VALUES ('Kill Bill','davy@bnf.fr',3);
INSERT INTO Notation (titre, email, note) VALUES ('Une journee en enfer','davy@bnf.fr',3);
INSERT INTO Notation (titre, email, note) VALUES ('Seven','davy@bnf.fr',2);
INSERT INTO Notation (titre, email, note) VALUES ('Shining','davy@bnf.fr',3);
INSERT INTO Notation (titre, email, note) VALUES ('Les dents de la mer','davy@bnf.fr',4);
INSERT INTO Notation (titre, email, note) VALUES ('Le monde perdu','davy@bnf.fr',2);
INSERT INTO Notation (titre, email, note) VALUES ('Nikita','davy@bnf.fr',3);
INSERT INTO Notation (titre, email, note) VALUES ('Usual suspects','davy@bnf.fr',5);
INSERT INTO Notation (titre, email, note) VALUES ('Sleepy Hollow','davy@bnf.fr',4);
INSERT INTO Notation (titre, email, note) VALUES ('Vertigo','davy@bnf.fr',2);
INSERT INTO Notation (titre, email, note) VALUES ('Fen�tre sur cour','davy@bnf.fr',2);
INSERT INTO Notation (titre, email, note) VALUES ('Godzilla','davy@bnf.fr',4);
INSERT INTO Notation (titre, email, note) VALUES ('American Beauty','davy@bnf.fr',4);
INSERT INTO Notation (titre, email, note) VALUES ('Sacrifice','davy@bnf.fr',1);
INSERT INTO Notation (titre, email, note) VALUES ('Terminator','davy@bnf.fr',3);
INSERT INTO Notation (titre, email, note) VALUES ('De bruit et de fureur','davy@bnf.fr',5);
INSERT INTO Notation (titre, email, note) VALUES ('Bad Lieutenant','davy@bnf.fr',2);
INSERT INTO Notation (titre, email, note) VALUES ('Volte/Face','davy@bnf.fr',4);
INSERT INTO Notation (titre, email, note) VALUES ('Blade Runner','davy@bnf.fr',4);
INSERT INTO Notation (titre, email, note) VALUES ('Kagemusha','davy@bnf.fr',5);
INSERT INTO Notation (titre, email, note) VALUES ('La mort aux trousses','davy@bnf.fr',3);
INSERT INTO Notation (titre, email, note) VALUES ('Une journee en enfer','waller@lri.fr',2);
INSERT INTO Notation (titre, email, note) VALUES ('Godzilla','waller@lri.fr',5);
INSERT INTO Notation (titre, email, note) VALUES ('Mission: Impossible','waller@lri.fr',2);
INSERT INTO Notation (titre, email, note) VALUES ('Top Gun','waller@lri.fr',3);
INSERT INTO Notation (titre, email, note) VALUES ('Volte/Face','waller@lri.fr',2);
INSERT INTO Notation (titre, email, note) VALUES ('Leon','waller@lri.fr',4);
INSERT INTO Notation (titre, email, note) VALUES ('Pulp fiction','waller@lri.fr',1);
INSERT INTO Notation (titre, email, note) VALUES ('Spider-Man','waller@lri.fr',2);
INSERT INTO Notation (titre, email, note) VALUES ('58 minutes pour vivre','waller@lri.fr',3);
INSERT INTO Notation (titre, email, note) VALUES ('Blade Runner','waller@lri.fr',3);
INSERT INTO Notation (titre, email, note) VALUES ('Piege de cristal','waller@lri.fr',5);
INSERT INTO Notation (titre, email, note) VALUES ('Les bronzes font du ski','waller@lri.fr',3);
INSERT INTO Notation (titre, email, note) VALUES ('Mary a tout prix','waller@lri.fr',3);
INSERT INTO Notation (titre, email, note) VALUES ('Le gendarme et les extra-terrestres','waller@lri.fr',4);
INSERT INTO Notation (titre, email, note) VALUES ('American Beauty','waller@lri.fr',5);



INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('American Beauty',19,'Carolyn Burnham');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('American Beauty',18,'Lester Burnham');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Alien',5,'Ripley');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Titanic',110,'Jack Dawson');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Volte/Face',11,'Sean Archer/Castor Troy');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Sleepy Hollow',14,'Constable Ichabod Crane');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Vertigo',15,'John Ferguson');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Vertigo',16,'Madeleine Elster');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Impitoyable',20,'William Munny');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Impitoyable',21,'Little Bill Dagget');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Impitoyable',22,'Ned Logan');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Gladiator',23,'Maximus');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Blade Runner',24,'Deckard');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Blade Runner',25,'Batty');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Piege de cristal',27,'McClane');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('58 minutes pour vivre',27,'McClane');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Van Gogh',30,'Van Gogh');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Seven',32,'Mills');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Seven',22,'Somerset');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Seven',18,'Doe');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('L''armee des douze singes',27,'Cole');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Le nom de la rose',35,'Baskerville');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Le nom de la rose',36,'de Melk');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Pulp fiction',11,'Vincent Vega');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Pulp fiction',38,'Jules Winnfield');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Pulp fiction',39,'Jody');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Pulp fiction',27,'Butch Coolidge');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Pulp fiction',40,'Mia Wallace');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Mary a tout prix',42,'Mary Jensen Matthews');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Mary a tout prix',43,'Pat Healy');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Terminator',44,'Terminator');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Les dents de la mer',46,'Martin Brody');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Les dents de la mer',47,'Quint');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Les dents de la mer',48,'Matt Hooper');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Le silence des agneaux',50,'Dr. Hannibal Lecter');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Le silence des agneaux',51,'Clarice Starling');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Godzilla',59,'Dr. Nikos Tatopoulos');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Godzilla',60,'Philippe Roache');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Matrix',62,'Neo');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Matrix',63,'Morpheus');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Mission: Impossible',65,'Ethan Hunt');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Mission: Impossible',66,'Jim Phelps');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Mission: Impossible',67,'Claire Phelps');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Mission: Impossible',60,'Franz Krieger');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Les pleins pouvoirs',20,'Luther Whitney');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Les pleins pouvoirs',21,'Le president Richmond');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Les pleins pouvoirs',69,'Seth Frank');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Eyes Wide Shut',65,'Docteur William Bill Harford');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Le gendarme et les extra-terrestres',72,'Inspecteur Cruchot');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Le gendarme et les extra-terrestres',73,'Adjudant Gerber');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Le monde perdu',57,'Dr. Ian Malcolm');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Rain Man',80,'Raymond Babbitt');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Rain Man',65,'Charlie Babbitt');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Top Gun',65,'Lt. Pete ''Maverick'' Mitchell');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Top Gun',82,'Charlotte Blackwood');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Top Gun',53,'Iceman');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Les bronzes font du ski',75,'Nathalie Morin');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Les bronzes font du ski',84,'Jean-Claude Dus');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Les bronzes font du ski',85,'Jer�me');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Les bronzes font du ski',76,'Christiane');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Les bronzes font du ski',86,'Popeye');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Psychose',88,'Bates');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Psychose',89,'Lila Crane');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Psychose',90,'Marion Crane');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Le retour du Jedi',92,'Luke Skywalker');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Le retour du Jedi',24,'Han Solo');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Le retour du Jedi',93,'Princesse Leia');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Les oiseaux',94,'Mitch Brenner');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Les oiseaux',95,'Melanie Daniels');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Sleepy Hollow',96,'Katrina Anne Van Tassel');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Sleepy Hollow',97,'Le cavalier');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Reservoir dogs',98,'Mr. White/Larry');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Reservoir dogs',99,'Freddy Newendyke/Mr. Orange');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Reservoir dogs',100,'Nice Guy Eddie');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Reservoir dogs',37,'Mr. Brown');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Volte/Face',12,'Castor Troy/Sean Archer');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Eyes Wide Shut',102,'Alice Harford');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Shining',103,'Jack Torrance');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Pas de printemps pour Marnie',95,'Marnie Edgar');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Pas de printemps pour Marnie',35,'Mark R');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('La mort aux trousses',105,'Roger O. Thornhill');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('La mort aux trousses',106,'Eve Kendall');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('La mort aux trousses',107,'Philipp Vandamm');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Titanic',109,'Rose DeWitt Bukater');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Jeanne d''Arc',112,'Jeanne d''Arc');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Jeanne d''Arc',80,'');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Jeanne d''Arc',113,'Yolande d''Aragon');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Jeanne d''Arc',114,'Charles VII');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Jeanne d''Arc',115,'Dunois');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Le cinquieme element',27,'Major Korben Dalla');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Le cinquieme element',116,'Jean-Baptiste Emmanuel Zorg');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Le cinquieme element',112,'Leeloo');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Le cinquieme element',117,'Vito Cornelius');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Leon',60,'Leon');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Leon',116,'Norman Stansfield');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Leon',118,'Mathilda');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Nikita',119,'Nikita');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Nikita',115,'Bob');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Nikita',120,'Marco');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Le grand bleu',39,'Johanna');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Le grand bleu',121,'Jacques Mayol');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Le grand bleu',60,'Enzo Molinari');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Spider-Man',124,'Spider-Man');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Spider-Man',125,'Norman Osborn');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Spider-Man',126,'Mary Jane Watson');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Spider-Man',127,'Oncle Ben');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Spider-Man',128,'Tante May');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('King of New York',97,'Frank White');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('King of New York',131,'Dennis Gilley');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('King of New York',63,'Jimmy Jump');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('King of New York',132,'Thomas Flanigan');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('The Matrix reloaded',63,'Morpheus');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('The Matrix reloaded',210,'Trinity');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('The Matrix reloaded',62,'Neo');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('The Matrix Revolutions',63,'Morpheus');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('The Matrix Revolutions',136,'Trinity');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('The Matrix Revolutions',62,'Neo');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('The Matrix Revolutions',134,'Agent Smith');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('The Matrix Revolutions',137,'L''Oracle');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('De bruit et de fureur',139,'Marcel');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('De bruit et de fureur',140,'Enseignante');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('De bruit et de fureur',141,'Bruno');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Usual suspects',143,'Micheal McManus');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Usual suspects',144,'Dean Keaton');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Usual suspects',145,'Fred Fenster');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Usual suspects',146,'Todd Hockney');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Usual suspects',18,'Roger Verbal Kint');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Bad Lieutenant',98,'Le lieutenant');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Gladiator',147,'Commode');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Gladiator',148,'Lucilla');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Gladiator',149,'Marc Aurele');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Le parrain',151,'Don Vito Corleone');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Le parrain',152,'Micheal');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Le parrain',153,'Sonny');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Le parrain',154,'Tom Hagen');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Le parrain',155,'Kay Adams');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Kill Bill',216,'Elle Driver');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Kill Bill',215,'Budd / Sidewinder');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Kill Bill',214,'Bill');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Kill Bill',213,'O-Ren Ishii');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Kill Bill',40,'La mariee, alias Black Mamba');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Reservoir dogs',218,'Mr Blue');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Reservoir dogs',215,'Mr Blonde');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Reservoir dogs',217,'Mr Pink');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Pulp fiction',99,'Pumpkin (Ringo)');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Pulp fiction',97,'Capt. Koons');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Pulp fiction',98,'Winston The Wolf Wolfe');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Pulp fiction',37,'Jimmy Dimmick');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Jackie Brown',169,'Melanie');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Jackie Brown',170,'Ray Nicolette');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Jackie Brown',167,'Luis Gara');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Jackie Brown',212,'Ordell Robbie');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Jackie Brown',168,'Jackie Brown');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Une journee en enfer',27,'McClane');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Une journee en enfer',169,'Simon Gruber');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Une journee en enfer',38,'Zeus Carver');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Sixieme sens',27,'Malcom Crowe');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Sixieme sens',171,'Cole Sear');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Lost in Translation',173,'Bob Harris');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Lost in Translation',174,'Charlotte');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Lost in Translation',175,'John');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Lost in Translation',176,'Kelly');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Lost in Translation',177,'Patron Nightclub');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('The Matrix reloaded',211,'Agent Smith');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Stalingrad',182,'Vassili Za�tzev');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Stalingrad',183,'major K�nig');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('King of New York',124,'Thomas Flanigan');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('King of New York',217,'Test tube');
INSERT INTO Role (titre, id_acteur, nom_role) VALUES ('Le bon, la brute et le truand',20,'');



  /* SELECTION */
