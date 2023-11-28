-- Ajout d'étudiants avec des profils différents
SELECT projet.encoder_etudiant('Dupont', 'Jean', 'jean.dupont@student.vinci.be', 'Q1', 'mdp1');
SELECT projet.encoder_etudiant('Martin', 'Alice', 'alice.martin@student.vinci.be', 'Q2', 'mdp2');
SELECT projet.encoder_etudiant('Lefevre', 'Pierre', 'pierre.lefevre@student.vinci.be', 'Q1', 'mdp3');

-- Ajout d'entreprises
SELECT projet.encoder_entreprise('ABC', 'Entreprise ABC', 'mdpABC', 'entreprise.abc@popo.be',
                                 '123 Rue de l''Entreprise');
SELECT projet.encoder_entreprise('XYZ', 'Entreprise XYZ', 'mdpXYZ', 'entreprise.xyz@yoyo21.be',
                                 '456 Rue de l''Entreprise');

-- Ajout de mots-clés
SELECT projet.encoder_mot_cle('Java');
SELECT projet.encoder_mot_cle('SQL');
SELECT projet.encoder_mot_cle('Web');

-- Ajout d'offres de stage pour les étudiants et les entreprises
SELECT projet.encoder_offre_stage('Description stage ABC1', 'ABC', 'Q1');
SELECT projet.encoder_offre_stage('Description stage ABC2', 'ABC', 'Q2');
SELECT projet.encoder_offre_stage('Description stage XYZ1', 'XYZ', 'Q1');
SELECT projet.encoder_offre_stage('Description stage XYZ2', 'XYZ', 'Q2');

-- Ajout de mots-clés pour les offres de stage
SELECT projet.valider_offre_stage('ABC1');
SELECT projet.valider_offre_stage('ABC2');
SELECT projet.valider_offre_stage('XYZ1');
SELECT projet.valider_offre_stage('XYZ2');

-- Assurez-vous que les étudiants et les offres de stage ont le même semestre
-- Exemple : Les étudiants posent des candidatures pour des offres de stage avec le même semestre
SELECT projet.poser_candidature(1, 'Motivation pour ABC1', 'ABC1');
SELECT projet.poser_candidature(1, 'Motivation pour XYZ1', 'XYZ1');

select projet.ajouter_mot_cle('ABC1', 1);
select projet.ajouter_mot_cle('ABC1', 2);

SELECT *
FROM projet.get_offres_stage_valides(1);

SELECT * FROM projet.get_offres_stage_valides(1);

SELECT *
FROM projet.rechercher_offres_par_mot_cle(1,'Java');
SELECT *
FROM projet.rechercher_offres_par_mot_cle(1,'SQL');
SELECT *
FROM projet.rechercher_offres_par_mot_cle(1,'Web');

select *
from projet.voir_offres_stage;


