-- Ajout d'étudiants avec des profils différents
SELECT projet.encoder_etudiant('Jean', 'De', 'j.d@vinci.be', 'Q2', 'Test');
SELECT projet.encoder_etudiant('Marc', 'Du', 'm.d@vinci.be', 'Q1',  'Test');

-- Ajout de mots-clés
SELECT projet.encoder_mot_cle('Java');
SELECT projet.encoder_mot_cle('Web');
SELECT projet.encoder_mot_cle('Python');

-- Ajout d'entreprises
SELECT projet.encoder_entreprise('VIN','NOME1','mdpE1','vinci@vinci.be','Bruxelles');

-- Ajout d'offres de stage pour les étudiants et les entreprises
SELECT projet.encoder_offre_stage('descVIN1', 'VIN', 'Q2');
SELECT projet.encoder_offre_stage('descVIN2', 'VIN', 'Q2');
SELECT projet.encoder_offre_stage('descVIN3', 'VIN', 'Q2');
SELECT projet.encoder_offre_stage('descVIN4', 'VIN', 'Q2');
SELECT projet.encoder_offre_stage('descVIN5', 'VIN', 'Q1');

-- Valider offre de stage
SELECT projet.valider_offre_stage('VIN1');
SELECT projet.valider_offre_stage('VIN4');
SELECT projet.valider_offre_stage('VIN5');


-- Assurez-vous que les étudiants et les offres de stage ont le même semestre
-- Exemple : Les étudiants posent des candidatures pour des offres de stage avec le même semestre
SELECT projet.poser_candidature('j.d@vinci.be','JSPENCORE', 'VIN4');
SELECT projet.poser_candidature('m.d@vinci.be','JSPENCORE', 'VIN5');

-- ajouter entreprise
SELECT projet.encoder_entreprise('ULB','Universite LB','mdpE1','ulb@ulb.be','Bruxelles');

-- encoder stage
SELECT projet.encoder_offre_stage('stage javascript', 'ULB', 'Q2');


-- Ajout de mots-clés pour les offres de stage
SELECT projet.ajouter_mot_cle('VIN3', 'Java');
SELECT projet.ajouter_mot_cle('VIN5', 'Java');

-- valider stage
SELECT projet.valider_offre_stage('ULB1');
