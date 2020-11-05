--create tables and constraints


CREATE TABLE equipes (
    code CHAR(3) CONSTRAINT pk_equipes PRIMARY KEY,
    nom VARCHAR2(80) NOT NULL,
    nationalite CHAR(3) NOT NULL,
    directeur VARCHAR2(80) NOT NULL,
    constraint ch_equipes_code CHECK(code = UPPER(code)),
    constraint ch_equipes_nationalite CHECK(nationalite = UPPER(nationalite))
);

CREATE TABLE coureurs (
    dossard NUMBER(6) GENERATED ALWAYS AS IDENTITY
        CONSTRAINT pk_coureur PRIMARY KEY,
    nom VARCHAR2(80) NOT NULL,
    prenom VARCHAR2(80) NOT NULL,
    nationalite CHAR(3) NOT NULL CONSTRAINT ch_courreurs_nationalite
        CHECK( nationalite = upper(nationalite)),
    equipe CHAR(3) CONSTRAINT fk_courreurs_equipes
        REFERENCES equipes(code)
);

CREATE TABLE etapes (
    code CHAR(8) CONSTRAINT pk_etapes PRIMARY KEY,
    jour DATE NOT NULL,
    villeDepart VARCHAR2(80) NOT NULL,
    villeArrivee VARCHAR2(80) NOT NULL,
    distance NUMBER(5,2) NOT NULL
);

CREATE TABLE resultats (
    coureur NUMBER(6) CONSTRAINT fk_resultats_coureurs
        REFERENCES coureurs(dossard),
    etape CHAR(8) CONSTRAINT fk_resultats_etapes
        REFERENCES etapes(code),
    temps DATE,
    CONSTRAINT pk_resultats PRIMARY KEY(coureur, etape)
);



























