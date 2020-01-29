# Introduction

> l'application et la base de données passent par SGBD

```
0 - Analyse et spécification des besoins
1 - Modelisation conceptuelle des données
2 - modélisation logique des données
3 - modélisation physiques des données
```

# MODELE ENTITE / ASSOCIATION (E/A)

- prpoposé par peter chen en 67
- il y a plusieurs method de CONCEPTION

# CONCEPTS DU MODELE E/A

- Attribut et domaine d'un attribut
- entite et association-type
- contraintes sur l'associations
- identité

# Le Concept d'entité

- Entité
  - un objet ou abstrait du monde réel qui se distingue des autres objets
  - tout objet du monde reel pertinent pour le monde reel

# IDENTIFIANT D’UNE ENTITE-TYPE

- une sous ensemble des attributs de l'entité type
- sert a distinguer les objets

# Type d'association

- association bnaire
- associatoin N-AIRES

# CONTRAINTE DE CARDINALITE

- L'ENTITÉ-TYPE LIGNE-COMMANDE DEPEND

# REGLES DE TRANSFORMATION D'UNE ENTITE TYPE

### la clé primaire d'une entité faible est

### une clé primaire peut etre une clé candidate

### a clé primaire d’une entité faible se construit par concaténation de l’identifiant de l’entité faible et de l’entité régulière dont dépend l’entité faible.

# REGLES DE TRANSFORMATION D'UNE ASSOCIATION BINAIRE (X-Y) - (1 - 1)

> eintité 1 est le pere
>
> enitité 2 est le fils
>
> du coup, le fils a un pere
>
> une ternaire avec 1-1 avec deux cotés == defaut de conception

# REGLES DE TRANSFORMATION D'UNE ASSOCIATION BINAIRE (X-Y) - (0 - 1)

- a voir les regles de transformation ::: ultra important
