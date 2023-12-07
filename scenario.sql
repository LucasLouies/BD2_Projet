SELECT projet.encoder_etudiant('Jean', 'De', 'j.d@vinci.be', 'Q2', '$2a$12$eM21.NZvSeuVK9.krR4ipuOa.omF5QaJUzyTnnJvTbbyD3.AzkGb2');

SELECT projet.encoder_etudiant('Marc', 'Du', 'm.d@vinci.be', 'Q1',  '$2a$12$eM21.NZvSeuVK9.krR4ipuOa.omF5QaJUzyTnnJvTbbyD3.AzkGb2');

SELECT projet.encoder_mot_cle('Java');
SELECT projet.encoder_mot_cle('Web');
SELECT projet.encoder_mot_cle('Python');

SELECT projet.encoder_entreprise('VIN','NOME1','$2a$12$eM21.NZvSeuVK9.krR4ipuOa.omF5QaJUzyTnnJvTbbyD3.AzkGb2','vinci@vinci.be','Bruxelles');

SELECT projet.encoder_offre_stage('descVIN1', 'VIN', 'Q2');
SELECT projet.encoder_offre_stage('descVIN2', 'VIN', 'Q2');
SELECT projet.encoder_offre_stage('descVIN3', 'VIN', 'Q2');
SELECT projet.encoder_offre_stage('descVIN4', 'VIN', 'Q2');
SELECT projet.encoder_offre_stage('descVIN5', 'VIN', 'Q1');

SELECT projet.valider_offre_stage('VIN1');
SELECT projet.valider_offre_stage('VIN4');
SELECT projet.valider_offre_stage('VIN5');

SELECT projet.ajouter_mot_cle('VIN3', 'Java', 'VIN');
SELECT projet.ajouter_mot_cle('VIN5', 'Java', 'VIN');

SELECT projet.poser_candidature('j.d@vinci.be','JSPENCORE', 'VIN4');
SELECT projet.poser_candidature('m.d@vinci.be','JSPENCORE', 'VIN5');

SELECT projet.encoder_entreprise('ULB','Universite LB','$2a$12$eM21.NZvSeuVK9.krR4ipuOa.omF5QaJUzyTnnJvTbbyD3.AzkGb2','vinci@vinci.be','Bruxelles');

SELECT projet.encoder_offre_stage('stage js', 'ULB', 'Q2');
SELECT projet.valider_offre_stage('ULB1');

------------------------------


