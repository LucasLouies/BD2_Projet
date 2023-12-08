SELECT projet.encoder_etudiant('Jean', 'De', 'j.d@student.vinci.be', 'Q2', '$2a$12$eM21.NZvSeuVK9.krR4ipuOa.omF5QaJUzyTnnJvTbbyD3.AzkGb2');

SELECT projet.encoder_etudiant('Marc', 'Du', 'm.d@student.vinci.be', 'Q1',  '$2a$12$eM21.NZvSeuVK9.krR4ipuOa.omF5QaJUzyTnnJvTbbyD3.AzkGb2');

SELECT projet.encoder_mot_cle('Java');
SELECT projet.encoder_mot_cle('Web');
SELECT projet.encoder_mot_cle('Python');

SELECT projet.encoder_entreprise('VIN','Vinci','$2a$12$eM21.NZvSeuVK9.krR4ipuOa.omF5QaJUzyTnnJvTbbyD3.AzkGb2','vinci@vinci.be','Bruxelles');

SELECT projet.encoder_offre_stage('stage SAP', 'VIN', 'Q2');
SELECT projet.encoder_offre_stage('stage BI', 'VIN', 'Q2');
SELECT projet.encoder_offre_stage('stage Unity', 'VIN', 'Q2');
SELECT projet.encoder_offre_stage('stage IA ', 'VIN', 'Q2');
SELECT projet.encoder_offre_stage('stage mobile', 'VIN', 'Q1');

SELECT projet.valider_offre_stage('VIN1');
SELECT projet.valider_offre_stage('VIN4');
SELECT projet.valider_offre_stage('VIN5');

SELECT projet.ajouter_mot_cle('VIN3', 'Java', 'VIN');
SELECT projet.ajouter_mot_cle('VIN5', 'Java', 'VIN');

SELECT projet.poser_candidature('j.d@student.vinci.be','JSPENCORE', 'VIN4');
SELECT projet.poser_candidature('m.d@student.vinci.be','JSPENCORE', 'VIN5');

SELECT projet.encoder_entreprise('ULB','Universite LB','$2a$12$eM21.NZvSeuVK9.krR4ipuOa.omF5QaJUzyTnnJvTbbyD3.AzkGb2','vinci@vinci.be','Bruxelles');

SELECT projet.encoder_offre_stage('stage js', 'ULB', 'Q2');
SELECT projet.valider_offre_stage('ULB1');

------------------------------

/*
SELECT projet.encoder_etudiant('Pe','Luc','l.p@student.vinci.be','Q2','$2a$12$eM21.NZvSeuVK9.krR4ipuOa.omF5QaJUzyTnnJvTbbyD3.AzkGb2');

SELECT projet.encoder_entreprise('UCL', 'Uni CL', '$2a$12$eM21.NZvSeuVK9.krR4ipuOa.omF5QaJUzyTnnJvTbbyD3.AzkGb2', 'ulc@hotmail.com', 'Louvain la neuve');

SELECT projet.encoder_offre_stage('stage SQL', 'UCL', 'Q2');

SELECT projet.encoder_offre_stage('stage ODOO', 'UCL', 'Q1');

SELECT projet.ajouter_mot_cle('UCL1', 'Java', 'UCL');

SELECT projet.ajouter_mot_cle('UCL1', 'Web', 'UCL');

--ne doit pas fonctionner
--SELECT projet.ajouter_mot_cle('UCL1', 'SQL', 'UCL');

--ne doit pas fonctionner
--SELECT projet.ajouter_mot_cle('UCL1', 'Java', 'UCL');

--ne doit pas fonctionner
--SELECT projet.ajouter_mot_cle('VIN1', 'Java', 'UCL');

SELECT * FROM projet.voir_offres_stage WHERE id_entreprise = 'UCL';

--ne doit pas fonctionner
--SELECT projet.selectionner_etudiant('UCL1','j.d@student.vinci.be');

SELECT * FROM projet.voir_offre_stage_non_valide;

SELECT projet.valider_offre_stage('VIN2');

SELECT projet.valider_offre_stage('UCL1');

--ne doit pas fonctionner
SELECT projet.valider_offre_stage('UCL3');

SELECT * FROM projet.voir_offre_stage_valide;

--ne doit pas fonctionner
--SELECT projet.encoder_mot_cle('Java');

SELECT projet.encoder_mot_cle('SQL');

SELECT projet.ajouter_mot_cle('UCL1', 'Python', 'UCL');

--ne doit pas fonctionner
--SELECT projet.ajouter_mot_cle('UCL1', 'SQL', 'UCL');

SELECT code_offre_stage,nom_entreprise,adresse_entreprise,description,mots_cles FROM projet.get_offres_stage_valides WHERE mail_etudiant = 'j.d@student.vinci.be';

SELECT * FROM projet.rechercher_offres_par_mot_cle WHERE mail = 'j.d@student.vinci.be' AND mots_cles ILIKE '%Java%';

SELECT projet.poser_candidature('j.d@student.vinci.be','azeaze' , 'VIN1');

--ne doit pas fonctionner
--SELECT projet.poser_candidature('j.d@student.vinci.be','azeaze' , 'VIN1');

SELECT projet.poser_candidature('j.d@student.vinci.be','azeaze' , 'VIN2');

--ne doit pas fonctionner
--SELECT projet.poser_candidature('j.d@student.vinci.be','azeaze' , 'VIN3');

SELECT projet.poser_candidature('j.d@student.vinci.be','azeaze' , 'UCL1');

SELECT projet.poser_candidature('l.p@student.vinci.be','azeaze' , 'VIN1');

SELECT projet.poser_candidature('l.p@student.vinci.be','azeaze' , 'VIN4');

SELECT projet.poser_candidature('l.p@student.vinci.be','azeaze' , 'UCL1');

SELECT * FROM projet.voirOffresCandidatureEtudiant WHERE mail = 'l.p@student.vinci.be';

--ne doit pas fonctionner
--SELECT projet.poser_candidature('m.d@student.vinci.be','azeaze' , 'VIN1');

SELECT DISTINCT * FROM projet.voir_etudiants_sans_stages;

--ne doit pas fonctionner
--SELECT projet.annuler_stage('UCL1', 'VIN');

SELECT * FROM projet.voir_candidatures_par_entreprise('VIN','UCL1');

SELECT * FROM projet.voir_candidatures_par_entreprise('VIN','VIN1');

--ne doit pas fonctionner
SELECT projet.selectionner_etudiant('UCL1', 'j.d@student.vinci.be', 'VIN');

*/