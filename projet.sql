DROP SCHEMA IF EXISTS projet CASCADE;
CREATE SCHEMA projet;
CREATE TABLE projet.etudiants(
	id_etudiant SERIAL PRIMARY KEY,
	nom VARCHAR(100) NOT NULL CHECK (nom<>''),
	prenom VARCHAR(100) NOT NULL CHECK (prenom<>''),
	semestre_du_stage VARCHAR(2) NOT NULL CHECK (semestre_du_stage SIMILAR TO 'Q[1-2]'),
	mdp VARCHAR(100) NOT NULL CHECK (mdp <>''),
	nb_candidature_en_attente INTEGER NOT NULL DEFAULT 0 CHECK ( nb_candidature_en_attente >=0 ),
	mail VARCHAR(50) UNIQUE NOT NULL CHECK ( mail SIMILAR TO '\w+\.\w+@student\.vinci\.be')
);

CREATE TABLE projet.entreprises(
	id_entreprise VARCHAR(3) PRIMARY KEY CHECK ( id_entreprise SIMILAR TO '[A-Z]{3}'),
	mdp VARCHAR(100) NOT NULL,
	mail VARCHAR(50) NOT NULL CHECK ( mail SIMILAR TO '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}'),
	adresse VARCHAR(100) NOT NULL CHECK ( adresse <> '' ),
	nom VARCHAR(100) NOT NULL CHECK ( nom <> '' )
);

CREATE TABLE projet.mots_cle(
	code_mot_cle SERIAL PRIMARY KEY,
	libelle VARCHAR(50) UNIQUE NOT NULL CHECK ( libelle <> '' )
);

CREATE TABLE projet.offres_stage(
	code_offre_stage VARCHAR(4) PRIMARY KEY CHECK ( code_offre_stage SIMILAR TO '[A-Z]{3}[0-9]{1}'),
	description VARCHAR(50) NOT NULL CHECK ( description <> '' ),
	semestre VARCHAR(2) NOT NULL CHECK (semestre SIMILAR TO 'Q[1-2]'),
	etat VARCHAR(50) NOT NULL CHECK ( etat IN('Non Validée', 'Validée', 'Attribuée', 'Annulée') ) DEFAULT 'Non Validée',
	id_etudiant INTEGER REFERENCES projet.etudiants (id_etudiant),
	id_entreprise VARCHAR(3) REFERENCES projet.entreprises (id_entreprise) NOT NULL
);

CREATE TABLE projet.candidatures(
	id_candidature CHARACTER(10) PRIMARY KEY,
	etat VARCHAR(50) NOT NULL CHECK ( etat IN('En attente', 'Acceptée', 'Refusée', 'Annulée')) DEFAULT 'En attente',
	motivation VARCHAR(1000) NOT NULL,

	code_offre_stage VARCHAR(4) REFERENCES projet.offres_stage (code_offre_stage) NOT NULL,
	id_etudiant INTEGER REFERENCES projet.etudiants (id_etudiant) NOT NULL
);

CREATE TABLE projet.mots_cle_stage(
	code_mot_cle INTEGER REFERENCES projet.mots_cle (code_mot_cle) NOT NULL,
	code_offre_stage VARCHAR(4) REFERENCES projet.offres_stage (code_offre_stage) NOT NULL,

    PRIMARY KEY (code_mot_cle, code_offre_stage)
);


--PROFFESSEUR
--Prof .1
CREATE OR REPLACE FUNCTION projet.encoder_etudiant(_nom VARCHAR(100), _prenom VARCHAR(100), _mail VARCHAR(50),
    _semestre VARCHAR(2), _mdp VARCHAR(100)) RETURNS INTEGER AS $$
DECLARE

BEGIN
    INSERT INTO projet.etudiants VALUES (DEFAULT, _nom, _prenom, _semestre, _mdp, DEFAULT, _mail);
END;
$$ LANGUAGE plpgsql;

--Prof .2
CREATE OR REPLACE FUNCTION projet.encoder_entreprise(_nom VARCHAR(100), _adresse VARCHAR(100), _mail VARCHAR(50),
    _identifiant VARCHAR(3), _mdp VARCHAR(100)) RETURNS INTEGER AS $$
DECLARE

BEGIN
    INSERT INTO projet.entreprises VALUES (_identifiant, _mdp, _mail, _adresse, _nom);
END;
$$ LANGUAGE plpgsql;
--Prof .3
CREATE OR REPLACE FUNCTION projet.encoder_mot_cle(_libelle VARCHAR(50)) RETURNS INTEGER AS $$
DECLARE

BEGIN
    INSERT INTO projet.mots_cle VALUES (DEFAULT, _libelle);
END;
$$ LANGUAGE plpgsql;
--Prof .4
CREATE VIEW projet.voir_offre_stage_non_valide AS
    SELECT o.code_offre_stage, o.semestre, e.nom, o.description
        FROM projet.offres_stage o, projet.entreprises e
        WHERE o.id_entreprise=e.id_entreprise AND o.etat = 'Non Validée';

--Prof .5
CREATE OR REPLACE FUNCTION projet.valider_offre_stage(_code_offre VARCHAR(4)) RETURNS INTEGER AS $$
DECLARE

BEGIN
    UPDATE projet.offres_stage SET etat = 'Validée' WHERE code_offre_stage = _code_offre;
END;
$$ LANGUAGE plpgsql;
--Prof .6
CREATE VIEW projet.voir_offre_stage_valide AS
    SELECT o.code_offre_stage, o.semestre, e.nom, o.description
        FROM projet.offres_stage o, projet.entreprises e
        WHERE o.id_entreprise = e.id_entreprise AND o.etat = 'Validée';

--Prof .7
CREATE VIEW projet.voir_etudiants_sans_stages AS
    SELECT e.nom, e.prenom, e.mail, e.semestre_du_stage, e.nb_candidature_en_attente
        FROM projet.etudiants e, projet.candidatures c
        WHERE e.id_etudiant = c.id_etudiant AND c.etat != 'Acceptée';

--Prof .8
CREATE VIEW projet.voir_offres_stage_attribues AS
    SELECT o.code_offre_stage, en.nom AS nom_entreprise, et.nom AS nom_etudiant, et.prenom
        FROM projet.offres_stage o, projet.entreprises en, projet.etudiants et
        WHERE o.id_etudiant=et.id_etudiant AND o.id_entreprise=en.id_entreprise AND o.etat = 'Attribuée';


--ENTREPRISE

--connexion entreprise

--Entreprise .1
CREATE OR REPLACE FUNCTION projet.encoder_offre_stage(_description VARCHAR(50), _semestre VARCHAR(2), _code_entreprise VARCHAR(3)) RETURNS INTEGER AS $$
DECLARE
    code_offre_stage VARCHAR (4);
    numero_offre_stage VARCHAR(1);
BEGIN
    SELECT COUNT(os.code_offre_stage) FROM projet.offres_stage os WHERE os.id_entreprise = _code_entreprise INTO numero_offre_stage;
    code_offre_stage = code_offre_stage || numero_offre_stage;
    INSERT INTO projet.entreprises VALUES (code_offre_stage, _description, _semestre, DEFAULT, NULL, _code_entreprise);
END;
$$ LANGUAGE plpgsql;

--Entreprise .2
CREATE VIEW projet.voir_mots_cle AS
    SELECT mc.libelle FROM projet.mots_cle mc;

--Entreprise .3
CREATE OR REPLACE FUNCTION projet.ajouter_mot_cle(_code_stage VARCHAR(3), _id_mot_cle INTEGER) RETURNS INTEGER AS $$
DECLARE
BEGIN
    INSERT INTO projet.mots_cle_stage VALUES (_id_mot_cle, _code_stage);
END;
$$ LANGUAGE plpgsql;

--Entreprise .4

--Entreprise .5

--Entreprise .6
CREATE OR REPLACE FUNCTION projet.selectionner_etudiant(_code_stage VARCHAR(3), _mail_etudiant VARCHAR(100)) RETURNS INTEGER AS $$
    --L’opération échouera si l’offre de stage n’est pas une offre de l’entreprise => A FAIRE EN JAVA
DECLARE
    id_candidat INTEGER;
BEGIN
    UPDATE projet.offres_stage SET etat = 'Attribuée' WHERE code_offre_stage = _code_stage;

    SELECT e.id_etudiant FROM projet.etudiants e WHERE e.mail = _mail_etudiant INTO id_candidat;
    UPDATE projet.candidatures SET etat = 'Acceptée' WHERE id_etudiant = id_candidat;
END;
$$ LANGUAGE plpgsql;


--Entreprise .7
CREATE OR REPLACE FUNCTION projet.annuler_stage(_code_stage VARCHAR(3)) RETURNS INTEGER AS $$
DECLARE
BEGIN
    UPDATE projet.offres_stage SET etat = 'Annulée' WHERE code_offre_stage = _code_stage;
END;
$$ LANGUAGE plpgsql;


--ETUDIANT

--connexion etudiant

--Etudiant .1
-- Création de la vue
CREATE OR REPLACE VIEW projet.offres_validees AS
SELECT
    os.code_offre_stage,
    e.nom AS nom_entreprise,
    e.adresse AS adresse_entreprise,
    os.description,
    string_agg(mc.libelle, ', ') AS mots_cles
FROM
    projet.offres_stage os,
    projet.entreprises e,
    projet.mots_cle_stage mcs,
    projet.mots_cle mc,
    projet.etudiants et
WHERE
    os.id_entreprise = e.id_entreprise
    AND os.code_offre_stage = mcs.code_offre_stage
    AND mcs.code_mot_cle = mc.code_mot_cle
    AND os.id_etudiant = et.id_etudiant
    AND os.etat = 'Validée'
    AND os.semestre = et.semestre_du_stage
GROUP BY
    os.code_offre_stage, e.nom, e.adresse, os.description;


--Etudiant .2

--Etudiant .3
CREATE OR REPLACE FUNCTION projet.poser_candidature(_id_etudiant INTEGER, _motivation VARCHAR(1000),
        _code_offre_stage VARCHAR(4) ) RETURNS INTEGER AS $$
DECLARE
BEGIN

END;
$$ LANGUAGE plpgsql;


--Etudiant .4

--Etudiant .5

--Triggers

CREATE OR REPLACE FUNCTION projet.vérification_etat_offre_stage() RETURNS TRIGGER AS $$
DECLARE

BEGIN
    IF (old.etat ='Non Validée' AND new.etat = 'Attribuée')
        THEN RAISE 'changement d etat non valide';
    END IF;

    IF (old.etat ='Validée' AND new.etat = 'Non Validée')
        THEN RAISE 'changement d etat non valide';
    END IF;

    IF (old.etat ='Attribuée' AND new.etat!= 'Attribuée')
        THEN RAISE 'changement d etat non valide';
    END IF;

    IF (old.etat ='Annulée' AND new.etat!= 'Annulée')
        THEN RAISE 'changement d etat non valide';
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_vérification_etat_offre_stage AFTER UPDATE ON projet.offres_stage
	FOR EACH ROW EXECUTE PROCEDURE projet.vérification_etat_offre_stage();


CREATE OR REPLACE FUNCTION projet.vérification_etat_candidature() RETURNS TRIGGER AS $$
DECLARE

BEGIN
    IF ( (old.etat ='Annulée' OR old.etat='Acceptée' OR old.etat ='Refusée') AND old.etat != new.etat  )
        THEN RAISE 'Chanement d etat non valide';
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_vérification_etat_candidature AFTER UPDATE ON projet.candidatures
	FOR EACH ROW EXECUTE PROCEDURE projet.vérification_etat_candidature();


CREATE OR REPLACE FUNCTION projet.vérification_insert_offre_stage() RETURNS TRIGGER AS $$
DECLARE
    --id_entreprise VARCHAR(3);
BEGIN
    --SELECT en.id_entreprise FROM projet.entreprises en WHERE en.id_entreprise = NEW.id_entreprise INTO id_entreprise;
    --check le code de l'offre grace au code de l'entreprise
    --IF (NOT (NEW.code_offre_stage SIMILAR TO id_entreprise))
        --THEN RAISE 'code de l offre de stage invalide';
    --END IF;


    --check si l'entreprise n'a pas déjà une offre de stage déjà attribuée durant ce semestre
    IF EXISTS (SELECT * FROM projet.entreprises en, projet.offres_stage os
                        WHERE os.id_entreprise = en.id_entreprise AND os.etat='Attribuée' AND os.semestre=NEW.semestre)
        THEN RAISE 'offre de stage déjà attribuée lors de ce semestre';

    END IF;

END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER vérification_insert_offre_stage AFTER INSERT ON projet.offres_stage
	FOR EACH ROW EXECUTE PROCEDURE projet.vérification_insert_offre_stage();


CREATE OR REPLACE FUNCTION projet.vérification_insert_stage_mot_cle() RETURNS TRIGGER AS $$
DECLARE
    etat_stage VARCHAR(50);
    nombre_mot_cle INTEGER;
BEGIN
    SELECT os.etat FROM projet.offres_stage os WHERE NEW.code_offre_stage = os.code_offre_stage INTO etat_stage;
    IF ( etat_stage = 'Attribuée' OR etat_stage = 'Annulée' )
        THEN RAISE 'offre de stage indisponible';
    END IF;

    SELECT COUNT(mcs.code_mot_cle) FROM projet.mots_cle_stage mcs
                                   WHERE mcs.code_offre_stage = NEW.code_offre_stage INTO nombre_mot_cle;

    IF(nombre_mot_cle >= 4)
        THEN RAISE 'nombre de mot cles atteints';
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER vérification_insert_offre_stage AFTER INSERT ON projet.mots_cle_stage
	FOR EACH ROW EXECUTE PROCEDURE projet.vérification_insert_stage_mot_cle();


CREATE OR REPLACE FUNCTION projet.annulation_validation_stage() RETURNS TRIGGER AS $$
DECLARE

BEGIN
    IF ((OLD.etat = 'Validée' AND NEW.etat = 'Annulée'))
        THEN UPDATE projet.candidatures SET etat = 'Refusée' WHERE code_offre_stage = NEW.code_offre_stage;
    END IF;

    IF (OLD.etat = 'Validée' AND NEW.etat = 'Attribuée')
        THEN

        UPDATE projet.candidatures SET etat = 'Refusée'
            WHERE code_offre_stage = NEW.code_offre_stage AND id_etudiant != NEW.id_etudiant;

        UPDATE projet.candidatures SET etat = 'Annulée'
            WHERE id_etudiant = NEW.id_etudiant AND code_offre_stage != NEW.code_offre_stage;

        UPDATE projet.offres_stage SET etat = 'Annulée'
            WHERE id_entreprise = NEW.id_entreprise AND code_offre_stage != NEW.code_offre_stage
            AND semestre= NEW.semestre;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER annulation_validation_stage AFTER UPDATE ON projet.offres_stage
	FOR EACH ROW EXECUTE PROCEDURE projet.annulation_validation_stage();


CREATE OR REPLACE FUNCTION projet.vérification_poser_candidature() RETURNS TRIGGER AS $$
DECLARE

BEGIN
    --Il ne peut poser de candidature s’il a déjà une candidature acceptée

    --s’il a déjà posé sa candidature pour cette offre

    --si l’offre n’est pas dans l’état validée

    --si l’offre ne correspond pas au bon semestre
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER vérification_poser_candidature AFTER INSERT ON projet.candidatures
	FOR EACH ROW EXECUTE PROCEDURE projet.vérification_poser_candidature();