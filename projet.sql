DROP SCHEMA IF EXISTS projet CASCADE;
CREATE SCHEMA projet;
CREATE TABLE projet.etudiants(
	id_etudiant SERIAL PRIMARY KEY,
	nom VARCHAR(100) NOT NULL CHECK (nom<>''),
	prenom VARCHAR(100) NOT NULL CHECK (prenom<>''),
	semestre_du_stage VARCHAR(2) NOT NULL CHECK (semestre_du_stage SIMILAR TO 'Q[1-2]'),
	mdp VARCHAR(50) NOT NULL CHECK (mdp <>''),
	nb_candidature_en_attente INTEGER NOT NULL DEFAULT 0 CHECK ( nb_candidature_en_attente >=0 ),
	mail VARCHAR(50) NOT NULL CHECK ( mail SIMILAR TO '^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
);

CREATE TABLE projet.entreprises(
	id_entreprise VARCHAR(3) PRIMARY KEY CHECK ( id_entreprise SIMILAR TO '^[A-Z]{3}$'),
	mdp VARCHAR(50) NOT NULL,
	mail VARCHAR(50) NOT NULL CHECK ( mail SIMILAR TO '^\w+\.\w+@student\.vinci\.be$'),
	adresse VARCHAR(50) NOT NULL CHECK ( adresse <> '' )
);

CREATE TABLE projet.mots_cle(
	code_mot_cle SERIAL PRIMARY KEY,
	libelle VARCHAR(50) UNIQUE NOT NULL CHECK ( libelle <> '' )
);

CREATE TABLE projet.offres_stage(
	code_offre_stage VARCHAR(4) PRIMARY KEY CHECK ( code_offre_stage SIMILAR TO '^[A-Z]{3}[0-9]{1}$'),
	description VARCHAR(50) NOT NULL CHECK ( description <> '' ),
	semestre VARCHAR(2) NOT NULL CHECK (semestre SIMILAR TO 'Q[1-2]'),
	etat VARCHAR(50) NOT NULL CHECK ( etat IN('Non Validé', 'Validé', 'Attribué', 'Annulé') ),
	id_etudiant INTEGER REFERENCES projet.etudiants (id_etudiant),
	id_entreprise VARCHAR(3) REFERENCES projet.entreprises (id_entreprise) NOT NULL
);

CREATE TABLE projet.candidatures(
	id_candidature CHARACTER(10) PRIMARY KEY,
	etat VARCHAR(50) NOT NULL CHECK ( etat IN('En attente', 'Accepté', 'Resufé', 'Annulé')),
	motivation VARCHAR(1000) NOT NULL,

	code_offre_stage VARCHAR(4) REFERENCES projet.offres_stage (code_offre_stage) NOT NULL,
	id_etudiant INTEGER REFERENCES projet.etudiants (id_etudiant) NOT NULL
);

CREATE TABLE projet.mots_cle_stage(
	code_mot_cle INTEGER REFERENCES projet.mots_cle (code_mot_cle) NOT NULL,
	code_offre_stage VARCHAR(4) REFERENCES projet.offres_stage (code_offre_stage) NOT NULL,

    PRIMARY KEY (code_mot_cle, code_offre_stage)
);

