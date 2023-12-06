DROP SCHEMA IF EXISTS projet CASCADE;
CREATE SCHEMA projet;
CREATE TABLE projet.etudiants
(
    id_etudiant               SERIAL PRIMARY KEY,
    nom                       VARCHAR(100)       NOT NULL CHECK (nom <> ''),
    prenom                    VARCHAR(100)       NOT NULL CHECK (prenom <> ''),
    semestre_du_stage         VARCHAR(2)         NOT NULL CHECK (semestre_du_stage SIMILAR TO 'Q[1-2]'),
    mdp                       VARCHAR(100)       NOT NULL CHECK (mdp <> ''),
    nb_candidature_en_attente INTEGER            NOT NULL DEFAULT 0 CHECK ( nb_candidature_en_attente >= 0 ),
    mail                      VARCHAR(50) UNIQUE NOT NULL CHECK ( mail SIMILAR TO '\w+\.\w+@[student\.]{0,1}vinci\.be')
);

CREATE TABLE projet.entreprises
(
    id_entreprise VARCHAR(3) PRIMARY KEY CHECK ( id_entreprise SIMILAR TO '[A-Z]{3}'),
    mdp           VARCHAR(100) NOT NULL,
    mail          VARCHAR(50)  NOT NULL CHECK ( mail SIMILAR TO '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}'),
    adresse       VARCHAR(100) NOT NULL CHECK ( adresse <> '' ),
    nom           VARCHAR(100) NOT NULL CHECK ( nom <> '' )
);

CREATE TABLE projet.mots_cle
(
    code_mot_cle SERIAL PRIMARY KEY,
    libelle      VARCHAR(50) UNIQUE NOT NULL CHECK ( libelle <> '' )
);

CREATE TABLE projet.offres_stage
(
    code_offre_stage VARCHAR(5) PRIMARY KEY CHECK (code_offre_stage SIMILAR TO '[A-Z]{3}[0-9]{1,2}'),
    description      VARCHAR(50)                                              NOT NULL CHECK ( description <> '' ),
    semestre         VARCHAR(2)                                               NOT NULL CHECK (semestre SIMILAR TO 'Q[1-2]'),
    etat             VARCHAR(17)                                              NOT NULL CHECK ( etat IN ('Non Validée', 'Validée', 'Attribuée', 'Annulée') ) DEFAULT 'Non Validée',
    id_etudiant      INTEGER REFERENCES projet.etudiants (id_etudiant),
    id_entreprise    VARCHAR(3) REFERENCES projet.entreprises (id_entreprise) NOT NULL
);

CREATE TABLE projet.candidatures
(
    id_candidature   SERIAL PRIMARY KEY,
    etat             VARCHAR(50)                                                  NOT NULL CHECK ( etat IN ('En attente', 'Acceptée', 'Refusée', 'Annulée')) DEFAULT 'En attente',
    motivation       VARCHAR(1000)                                                NOT NULL,

    code_offre_stage VARCHAR(5) REFERENCES projet.offres_stage (code_offre_stage) NOT NULL,
    id_etudiant      INTEGER REFERENCES projet.etudiants (id_etudiant)            NOT NULL
);

CREATE TABLE projet.mots_cle_stage
(
    code_mot_cle     INTEGER REFERENCES projet.mots_cle (code_mot_cle)            NOT NULL,
    code_offre_stage VARCHAR(5) REFERENCES projet.offres_stage (code_offre_stage) NOT NULL,

    PRIMARY KEY (code_mot_cle, code_offre_stage)
);





--PROFFESSEUR____________________________________________________________________________________________________________________________

--Prof .1
CREATE OR REPLACE FUNCTION projet.encoder_etudiant(_nom VARCHAR(100), _prenom VARCHAR(100), _mail VARCHAR(50),
                                                   _semestre VARCHAR(2), _mdp VARCHAR(100)) RETURNS VOID AS
$$
DECLARE
BEGIN
INSERT INTO projet.etudiants
VALUES (DEFAULT, _nom, _prenom, _semestre, _mdp, DEFAULT, _mail);
END;
$$ LANGUAGE plpgsql;

--Prof .2
CREATE OR REPLACE FUNCTION projet.encoder_entreprise(_identifiant VARCHAR(3), _nom VARCHAR(100), _mdp VARCHAR(100),
                                                     _mail VARCHAR(50), _adresse VARCHAR(100)) RETURNS varchar(3) AS
$$
DECLARE
id varchar(3) := '';
BEGIN
INSERT INTO projet.entreprises
VALUES (_identifiant, _mdp, _mail, _adresse, _nom)
    RETURNING id_entreprise INTO id;
RETURN id;
END;
$$ LANGUAGE plpgsql;

--Prof .3
CREATE OR REPLACE FUNCTION projet.encoder_mot_cle(_libelle VARCHAR(50)) RETURNS INTEGER AS
$$
DECLARE
id INTEGER := 0;
BEGIN
INSERT INTO projet.mots_cle
VALUES (DEFAULT, _libelle)
    RETURNING code_mot_cle INTO id;
RETURN id;
END;
$$ LANGUAGE plpgsql;

--Prof .4
CREATE VIEW projet.voir_offre_stage_non_valide AS
SELECT o.code_offre_stage, o.semestre, e.nom, o.description
FROM projet.offres_stage o,
     projet.entreprises e
WHERE o.id_entreprise = e.id_entreprise
  AND o.etat = 'Non Validée';

--Prof .5
CREATE OR REPLACE FUNCTION projet.valider_offre_stage(_code_offre VARCHAR(5)) RETURNS VARCHAR(5) AS
$$
DECLARE

BEGIN
UPDATE projet.offres_stage SET etat = 'Validée' WHERE code_offre_stage = _code_offre;
RETURN _code_offre;
END;
$$ LANGUAGE plpgsql;

--Prof .6
CREATE VIEW projet.voir_offre_stage_valide AS
SELECT o.code_offre_stage, o.semestre, e.nom, o.description
FROM projet.offres_stage o,
     projet.entreprises e
WHERE o.id_entreprise = e.id_entreprise
  AND o.etat = 'Validée';

--Prof .7
CREATE VIEW projet.voir_etudiants_sans_stages AS
SELECT e.nom, e.prenom, e.mail, e.semestre_du_stage, e.nb_candidature_en_attente
FROM projet.etudiants e,
     projet.candidatures c
WHERE (e.id_etudiant = c.id_etudiant AND c.etat != 'Acceptée')
   OR e.id_etudiant != c.id_etudiant;

--Prof .8
CREATE VIEW projet.voir_offres_stage_attribues AS
SELECT o.code_offre_stage, en.nom AS nom_entreprise, et.nom AS nom_etudiant, et.prenom
FROM projet.offres_stage o,
     projet.entreprises en,
     projet.etudiants et
WHERE o.id_etudiant = et.id_etudiant
  AND o.id_entreprise = en.id_entreprise
  AND o.etat = 'Attribuée';


--ENTREPRISE________________________________________________________________________________________________________________________

--connexion entreprise

--Entreprise .1
CREATE OR REPLACE FUNCTION projet.encoder_offre_stage(_description VARCHAR(50), _code_entreprise VARCHAR(3),
                                                      _semestre VARCHAR(2)) RETURNS VARCHAR(5) AS
$$
DECLARE
_code_offre_stage   VARCHAR(5);
    _numero_offre_stage VARCHAR(2);
BEGIN
SELECT COUNT(os.code_offre_stage) + 1
FROM projet.offres_stage os
WHERE os.id_entreprise = _code_entreprise
    INTO _numero_offre_stage;
_code_offre_stage := _code_entreprise || _numero_offre_stage;
INSERT INTO projet.offres_stage (code_offre_stage, description, semestre, etat, id_etudiant, id_entreprise)
VALUES (_code_offre_stage, _description, _semestre, DEFAULT, NULL, _code_entreprise);
RETURN _code_offre_stage;
END;
$$ LANGUAGE plpgsql;

--Entreprise .2
CREATE VIEW projet.voir_mots_cle AS
SELECT mc.libelle
FROM projet.mots_cle mc;

--Entreprise .3
CREATE OR REPLACE FUNCTION projet.ajouter_mot_cle(_code_offre_stage VARCHAR(3), _libelle_mot_cle VARCHAR(50)) RETURNS VARCHAR(9) AS
$$
DECLARE
concatenated_value VARCHAR(50) := '';
    temp_code_mot_cle  INTEGER;
BEGIN
SELECT mc.code_mot_cle FROM projet.mots_cle mc WHERE mc.libelle = _libelle_mot_cle INTO temp_code_mot_cle;
concatenated_value := _libelle_mot_cle || '_' || _code_offre_stage;
INSERT INTO projet.mots_cle_stage(code_mot_cle, code_offre_stage) VALUES (temp_code_mot_cle, _code_offre_stage);
RETURN concatenated_value;
END;
$$ LANGUAGE plpgsql;

--Entreprise .4
/*YA
Voir ses offres de stages : Pour chaque offre de stage, on affichera son code, sa
description, son semestre, son état, le nombre de candidatures en attente et le nom
de l’étudiant qui fera le stage (si l’offre a déjà été attribuée). Si l'offre de stage n'a pas
encore été attribuée, il sera indiqué "pas attribuée" à la place du nom de l'étudiant.
  */
CREATE OR REPLACE VIEW projet.voir_offres_stage AS
SELECT os.id_entreprise,
       os.code_offre_stage,
       os.description,
       os.semestre,
       os.etat,
       (SELECT COUNT(*)
        FROM projet.candidatures c
        WHERE c.code_offre_stage = os.code_offre_stage
          AND c.etat = 'En attente')    AS nb_candidature_en_attente,
       COALESCE(e.nom, 'pas attribuée') AS nom_etudiant_attribue
FROM projet.offres_stage os
         LEFT JOIN
     projet.etudiants e ON os.id_etudiant = e.id_etudiant;


--Entreprise .5
/*YA
  Voir les candidatures pour une de ses offres de stages en donnant son code. Pour
chaque candidature, on affichera son état, le nom, prénom, adresse mail et les
motivations de l’étudiant. Si le code ne correspond pas à une offre de l’entreprise ou
qu’il n’y a pas de candidature pour cette offre, le message suivant sera affiché “Il n'y a
pas de candidatures pour cette offre ou vous n'avez pas d'offre ayant ce code”.
  */

CREATE OR REPLACE FUNCTION projet.voir_candidatures_par_entreprise(_id_entreprise VARCHAR(3))
    RETURNS TABLE
            (
                code_offre_stage VARCHAR(5),
                etat             VARCHAR(50),
                nom_etudiant     VARCHAR(100),
                prenom_etudiant  VARCHAR(100),
                mail_etudiant    VARCHAR(50),
                motivation       VARCHAR(1000)
            )
AS
$$
DECLARE
BEGIN
    IF NOT EXISTS(SELECT 1 FROM projet.offres_stage WHERE id_entreprise = _id_entreprise) THEN
        RAISE EXCEPTION 'Il n''y a pas d''offre pour cette entreprise';
END IF;
RETURN QUERY
SELECT c.code_offre_stage,
       c.etat,
       e.nom,
       e.prenom,
       e.mail,
       c.motivation
FROM projet.candidatures c
         JOIN
     projet.etudiants e ON c.id_etudiant = e.id_etudiant
         JOIN
     projet.offres_stage os ON c.code_offre_stage = os.code_offre_stage
WHERE os.id_entreprise = _id_entreprise;

END;
$$ LANGUAGE plpgsql;



--Entreprise .6
CREATE OR REPLACE FUNCTION projet.selectionner_etudiant(_code_stage VARCHAR(3), _mail_etudiant VARCHAR(100)) RETURNS INTEGER AS
$$
    --L’opération échouera si l’offre de stage n’est pas une offre de l’entreprise => A FAIRE EN JAVA
DECLARE
id_candidat INTEGER;
BEGIN
UPDATE projet.offres_stage SET etat = 'Attribuée' WHERE code_offre_stage = _code_stage;

SELECT e.id_etudiant FROM projet.etudiants e WHERE e.mail = _mail_etudiant INTO id_candidat;
UPDATE projet.candidatures SET etat = 'Acceptée' WHERE id_etudiant = id_candidat;
RETURN id_candidat;
END;
$$ LANGUAGE plpgsql;


--Entreprise .7
CREATE OR REPLACE FUNCTION projet.annuler_stage(_code_stage VARCHAR(3)) RETURNS VOID AS
$$
DECLARE
BEGIN
UPDATE projet.offres_stage SET etat = 'Annulée' WHERE code_offre_stage = _code_stage;
END;
$$ LANGUAGE plpgsql;


--ETUDIANT__________________________________________________________________________________________________________________________________

--connexion etudiant

--Etudiant .1
/*YA
  Voir toutes les offres de stage dans l’état « validée » correspondant au semestre où
l’étudiant fera son stage. Pour une offre de stage, on affichera son code, le nom de
l’entreprise, son adresse, sa description et les mots-clés (séparés par des virgules sur
une même ligne).
  */
--todo le faire en view
CREATE VIEW projet.get_offres_stage_valides AS
SELECT et.mail AS mail_etudiant,
       os.code_offre_stage,
       e.nom                                 AS nom_entreprise,
       e.adresse                             AS adresse_entreprise,
       os.description,
       STRING_AGG(mc.libelle, ', ')::VARCHAR AS mots_cles
FROM projet.offres_stage os
         JOIN
     projet.entreprises e ON os.id_entreprise = e.id_entreprise
         LEFT JOIN
     projet.mots_cle_stage mcs ON os.code_offre_stage = mcs.code_offre_stage
         LEFT JOIN
     projet.mots_cle mc ON mcs.code_mot_cle = mc.code_mot_cle,
     projet.etudiants et

WHERE os.etat = 'Validée'
  AND os.semestre = et.semestre_du_stage --TODO
GROUP BY et.mail, os.code_offre_stage, e.nom, e.adresse, os.description;

--Etudiant .2
/*YA
  Recherche d’une offre de stage par mot clé. Cette recherche n’affichera que les offres de stages validées
  et correspondant au semestre où l’étudiant fera son stage.
  Les offres de stage seront affichées comme au point précédent.
*/
--todo le faire en view
/*
CREATE OR REPLACE FUNCTION projet.rechercher_offres_par_mot_cle(_etudiant_mail VARCHAR(50), _mot_cle VARCHAR(50))
    RETURNS TABLE
            (
                code_offre_stage   VARCHAR(5),
                nom_entreprise     VARCHAR(100),
                adresse_entreprise VARCHAR(100),
                description        VARCHAR(50),
                mots_cles          VARCHAR
            )
AS
$$
DECLARE
    temp_etudiant_id INTEGER;
BEGIN
    SELECT e.id_etudiant FROM projet.etudiants e WHERE e.mail = _etudiant_mail INTO temp_etudiant_id;
    RETURN QUERY
        SELECT *
        FROM projet.get_offres_stage_valides(_etudiant_mail) AS result
        WHERE result.mots_cles ILIKE '%' || _mot_cle || '%'; -- Filtrer par mot clé

END;
$$ LANGUAGE plpgsql;
*/

CREATE VIEW projet.rechercher_offres_par_mot_cle AS
SELECT et.mail,
       os.code_offre_stage,
       e.nom                                 AS nom_entreprise,
       e.adresse                             AS adresse_entreprise,
       os.description,
       STRING_AGG(mc.libelle, ', ')::VARCHAR AS mots_cles

FROM projet.offres_stage os
         JOIN
     projet.entreprises e ON os.id_entreprise = e.id_entreprise
         LEFT JOIN
     projet.mots_cle_stage mcs ON os.code_offre_stage = mcs.code_offre_stage
         LEFT JOIN
     projet.mots_cle mc ON mcs.code_mot_cle = mc.code_mot_cle,
     projet.etudiants et

WHERE et.semestre_du_stage = os.semestre
  AND os.etat = 'Validée'
GROUP BY et.mail, os.code_offre_stage, e.nom, e.adresse, os.description;


--Etudiant .3
/*YA
  Poser sa candidature. Pour cela, il doit donner le code de l’offre de stage et donner ses motivations sous format textuel.
  Il ne peut poser de candidature s’il a déjà une candidature acceptée,
  s’il a déjà posé sa candidature pour cette offre,
  si l’offre n’est pas dans l’état validée ou si l’offre ne correspond pas au bon semestre.
  */
CREATE
OR REPLACE FUNCTION projet.poser_candidature(_mail_etudiant VARCHAR(50), _motivation VARCHAR(1000),
                                                 _code_offre_stage VARCHAR(5)) RETURNS INTEGER
AS
$$
DECLARE
_id_candidature INTEGER;
    _id_etudiant    INTEGER;
BEGIN
SELECT e.id_etudiant FROM projet.etudiants e WHERE e.mail = _mail_etudiant INTO _id_etudiant;
INSERT INTO projet.candidatures (etat, motivation, code_offre_stage, id_etudiant)
VALUES ('En attente', _motivation, _code_offre_stage, _id_etudiant)
    RETURNING id_candidature INTO _id_candidature;

RETURN _id_candidature;
END;
$$ LANGUAGE plpgsql;


--Etudiant .4
/*YA
Voir les offres de stage pour lesquels l’étudiant a posé sa candidature. Pour chaque
offre, on verra le code de l’offre, le nom de l’entreprise ainsi que l’état de sa
candidature.
*/

CREATE VIEW projet.voirOffresCandidatureEtudiant AS
SELECT os.code_offre_stage, en.nom, c.etat, os.id_etudiant, et.mail
FROM projet.offres_stage os
         JOIN projet.candidatures c ON c.code_offre_stage = os.code_offre_stage
         JOIN projet.etudiants et ON c.id_etudiant = et.id_etudiant
         JOIN projet.entreprises en ON os.id_entreprise = en.id_entreprise;


--Etudiant .5
/*YA
   Annuler une candidature en précisant le code de l’offre de stage. Les candidatures ne
peuvent être annulées que si elles sont « en attente ».
  */

CREATE OR REPLACE FUNCTION projet.annuler_candidature(_mail_etudiant VARCHAR(50), _code_offre_stage VARCHAR(5)) RETURNS VARCHAR(5) AS --fixme décrémenter nb candidature en attente
$$
DECLARE
_id_etudiant INTEGER;
BEGIN
SELECT e.id_etudiant FROM projet.etudiants e WHERE e.mail = _mail_etudiant INTO _id_etudiant;
UPDATE projet.candidatures
SET etat = 'Annulée'
WHERE code_offre_stage = _code_offre_stage
      AND etat = 'En attente'
      AND id_etudiant = _id_etudiant;
RETURN _code_offre_stage;
END;
$$ LANGUAGE plpgsql;

--Permissions____________________________________________________________________________________________________________________________
GRANT CONNECT ON DATABASE dblucaslouies TO mohamednori, youssefabouhamid;
GRANT USAGE ON SCHEMA projet TO mohamednori, youssefabouhamid;

--Entreprise
GRANT INSERT, SELECT, UPDATE ON projet.offres_stage TO mohamednori;
GRANT SELECT ON projet.mots_cle TO mohamednori;
GRANT INSERT ON projet.mots_cle_stage TO mohamednori;
GRANT SELECT ON projet.etudiants TO mohamednori;
GRANT SELECT, UPDATE ON projet.candidatures TO mohamednori;
GRANT SELECT ON projet.voir_mots_cle TO mohamednori;
GRANT SELECT ON projet.voir_offres_stage TO mohamednori;
GRANT SELECT ON projet.entreprises TO mohamednori;



--Etudiant
GRANT INSERT, SELECT, UPDATE ON projet.candidatures TO youssefabouhamid;
GRANT SELECT ON projet.etudiants TO youssefabouhamid;
GRANT SELECT ON projet.offres_stage TO youssefabouhamid;
GRANT SELECT ON projet.entreprises TO youssefabouhamid;
GRANT SELECT ON projet.mots_cle_stage TO youssefabouhamid;
GRANT SELECT ON projet.mots_cle TO youssefabouhamid;
GRANT SELECT ON projet.get_offres_stage_valides TO youssefabouhamid;
GRANT SELECT ON projet.rechercher_offres_par_mot_cle TO youssefabouhamid;
GRANT SELECT ON projet.voirOffresCandidatureEtudiant TO youssefabouhamid;


--Triggers__________________________________________________________________________________________________________________________________________________________

CREATE OR REPLACE FUNCTION projet.vérification_etat_offre_stage() RETURNS TRIGGER AS
$$
DECLARE

BEGIN
    IF (OLD.etat = 'Non Validée' AND NEW.etat = 'Attribuée') OR
       (OLD.etat = 'Validée' AND NEW.etat = 'Non Validée') OR
       (OLD.etat = 'Attribuée' AND NEW.etat != 'Attribuée') OR
       (OLD.etat = 'Annulée' AND NEW.etat != 'Annulée')
    THEN
        RAISE 'Changement d''état non valide';
END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_vérification_etat_offre_stage
    AFTER UPDATE
    ON projet.offres_stage
    FOR EACH ROW
    EXECUTE PROCEDURE projet.vérification_etat_offre_stage();


CREATE OR REPLACE FUNCTION projet.vérification_etat_candidature() RETURNS TRIGGER AS
$$
DECLARE

BEGIN
    IF ((old.etat = 'Annulée' OR old.etat = 'Acceptée' OR old.etat = 'Refusée') AND old.etat != new.etat)
    THEN
        RAISE 'Chanement d etat non valide';
END IF;
RETURN new;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_vérification_etat_candidature
    AFTER UPDATE
    ON projet.candidatures
    FOR EACH ROW
    EXECUTE PROCEDURE projet.vérification_etat_candidature();


CREATE OR REPLACE FUNCTION projet.vérification_insert_offre_stage() RETURNS TRIGGER AS
$$
DECLARE
    --id_entreprise VARCHAR(3);
BEGIN
    --check si l'entreprise n'a pas déjà une offre de stage déjà attribuée durant ce semestre
    IF EXISTS(SELECT *
              FROM projet.entreprises en,
                   projet.offres_stage os
              WHERE os.id_entreprise = en.id_entreprise
                AND os.etat = 'Attribuée'
                AND os.semestre = NEW.semestre)
    THEN
        RAISE 'offre de stage déjà attribuée lors de ce semestre';

END IF;
RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER vérification_insert_offre_stage
    AFTER INSERT
    ON projet.offres_stage
    FOR EACH ROW
    EXECUTE PROCEDURE projet.vérification_insert_offre_stage();


CREATE OR REPLACE FUNCTION projet.vérification_insert_stage_mot_cle() RETURNS TRIGGER AS
$$
DECLARE
etat_stage     VARCHAR(50);
    nombre_mot_cle INTEGER;
BEGIN
SELECT os.etat FROM projet.offres_stage os WHERE NEW.code_offre_stage = os.code_offre_stage INTO etat_stage;
IF (etat_stage = 'Attribuée' OR etat_stage = 'Annulée')
    THEN
        RAISE 'offre de stage indisponible';
END IF;

SELECT COUNT(mcs.code_mot_cle)
FROM projet.mots_cle_stage mcs
WHERE mcs.code_offre_stage = NEW.code_offre_stage
    INTO nombre_mot_cle;

IF (nombre_mot_cle >= 4)
    THEN
        RAISE 'nombre de mot cles atteints';
END IF;
RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER vérification_insert_offre_stage
    AFTER INSERT
    ON projet.mots_cle_stage
    FOR EACH ROW
    EXECUTE PROCEDURE projet.vérification_insert_stage_mot_cle();


CREATE OR REPLACE FUNCTION projet.annulation_validation_stage() RETURNS TRIGGER AS
$$
DECLARE

BEGIN
    IF ((OLD.etat = 'Validée' AND NEW.etat = 'Annulée'))
    THEN
UPDATE projet.candidatures SET etat = 'Refusée' WHERE code_offre_stage = NEW.code_offre_stage;
END IF;

    IF (OLD.etat = 'Validée' AND NEW.etat = 'Attribuée')
    THEN

UPDATE projet.candidatures
SET etat = 'Refusée'
WHERE code_offre_stage = NEW.code_offre_stage
  AND id_etudiant != NEW.id_etudiant;

UPDATE projet.candidatures
SET etat = 'Annulée'
WHERE id_etudiant = NEW.id_etudiant
  AND code_offre_stage != NEW.code_offre_stage;

UPDATE projet.offres_stage
SET etat = 'Annulée'
WHERE id_entreprise = NEW.id_entreprise
  AND code_offre_stage != NEW.code_offre_stage
          AND semestre = NEW.semestre;
END IF;
RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER annulation_validation_stage
    AFTER UPDATE
    ON projet.offres_stage
    FOR EACH ROW
    EXECUTE PROCEDURE projet.annulation_validation_stage();


CREATE OR REPLACE FUNCTION projet.verification_poser_candidature() RETURNS TRIGGER AS
$$
DECLARE
candidature_acceptee   INTEGER;
    candidature_existante  INTEGER;
    offre_validee          INTEGER;
    semestre_correspondant INTEGER;
BEGIN
    -- Vérification : Il ne peut poser de candidature s’il a déjà une candidature acceptée
SELECT COUNT(*)
INTO candidature_acceptee
FROM projet.candidatures
WHERE id_etudiant = NEW.id_etudiant
  AND etat = 'Acceptée';

IF candidature_acceptee > 0 THEN
        RAISE 'Vous avez déjà une candidature acceptée.';
END IF;

    -- Vérification : S’il a déjà posé sa candidature pour cette offre
SELECT COUNT(*)
INTO candidature_existante
FROM projet.candidatures
WHERE id_etudiant = NEW.id_etudiant
  AND code_offre_stage = NEW.code_offre_stage;

IF candidature_existante > 0 THEN
        RAISE 'Vous avez déjà posé une candidature pour cette offre.';
END IF;

    -- Vérification : Si l’offre n’est pas dans l’état validée
SELECT COUNT(*)
INTO offre_validee
FROM projet.offres_stage
WHERE code_offre_stage = NEW.code_offre_stage
  AND etat = 'Validée';

IF offre_validee = 0 THEN
        RAISE 'Cette offre de stage n''est pas dans l''état validée.';
END IF;

    -- Vérification : Si l’offre ne correspond pas au bon semestre
SELECT COUNT(*)
INTO semestre_correspondant
FROM projet.etudiants e
WHERE e.id_etudiant = NEW.id_etudiant
  AND e.semestre_du_stage =
      (SELECT semestre FROM projet.offres_stage WHERE code_offre_stage = NEW.code_offre_stage);

IF semestre_correspondant = 0 THEN
        RAISE 'Cette offre de stage ne correspond pas à votre semestre.';
END IF;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--todo à tester et à valider
CREATE OR REPLACE FUNCTION projet.mettre_a_jour_nb_candidature_en_attente() RETURNS TRIGGER AS
$$
DECLARE
_nb_candidature_en_attente INTEGER;
BEGIN
SELECT COUNT(c.id_etudiant)
FROM projet.candidatures c
WHERE c.id_etudiant = NEW.id_etudiant
  AND c.etat = 'En attente'
    INTO _nb_candidature_en_attente;

UPDATE
    projet.etudiants
SET nb_candidature_en_attente = _nb_candidature_en_attente
    where id_etudiant = new.id_etudiant;

RETURN new;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_verification_poser_candidature --fixme
    BEFORE INSERT
    ON projet.candidatures
    FOR EACH ROW
    EXECUTE PROCEDURE projet.verification_poser_candidature();

CREATE TRIGGER trigger_mettre_a_jour_nb_candidature_en_attente -- TODO À TESTER
    AFTER INSERT OR UPDATE
                        ON projet.candidatures
                        FOR EACH ROW
                        EXECUTE PROCEDURE projet.mettre_a_jour_nb_candidature_en_attente();
