import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ProgrammeEtudiant{
    public ProgrammeEtudiant() {
        String url="jdbc:postgresql://172.24.2.6:5432/dblucaslouies";
        Connection conn=null;
        try {
            conn= DriverManager.getConnection(url,"youssefabouhamid","B529DJVR0");
        } catch (SQLException e) {
            System.out.println("Impossible de joindre le server !");
            System.exit(1);
        }

        boolean fini = false;
        String[] questionIdentifiantEtudiant = {
                "Quelle est votre adresse mail?",
                "Quel est votre mot de passe?"
        };

        String[] identifiantsEtudiant = main.askForInput(questionIdentifiantEtudiant);
        String mailEtudiant = identifiantsEtudiant[0];

        try {
            PreparedStatement ps = conn.prepareStatement("SELECT projet.connexionEtudiant(?)");
            ps.setString(1, mailEtudiant);

            ResultSet rs = ps.executeQuery();
            rs.next();

            String hashedMdp = rs.getString(1);

            if(!BCrypt.checkpw(identifiantsEtudiant[1], hashedMdp)){
                System.out.println("Identifiant erronee");
                System.exit(1);
            }
        }catch (SQLException e){
            System.out.println("Erreur lors de l'identification");
            e.printStackTrace();
        }

        System.out.println("Voici la section etudiant !");
        while (!fini){
            String[] questionChoixEtudiant = {
                    "Voir les offres de stage validées(1)\n" +
                            "Rechercher les offres de stages via mot clé(2)\n" +
                            "Poser une candidature(3)\n" +
                            "Voir les offres de stage dont vous êtes un candidat(4)\n" +
                            "Annuler une candidature(5)\n" +
                            "Quitter(6)"
            };

            String[] reponseChoixEtudiant = main.askForInput(questionChoixEtudiant);

            switch (reponseChoixEtudiant[0]) {
                case "1" :
                    try {
                        PreparedStatement ps = conn.prepareStatement("SELECT  code_offre_stage,nom_entreprise,adresse_entreprise,description,mots_cles " +
                                "FROM projet.get_offres_stage_valides WHERE mail_etudiant = ?;");
                        ps.setString(1, mailEtudiant);

                        main.displayData(ps.executeQuery());
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }

                    break;
                case "2" :
                    String[] questionMotCle = {"Veuillez entrer un mot cle"};
                    String[] reponseMotCle = main.askForInput(questionMotCle);
                    try {
                        PreparedStatement ps = conn.prepareStatement("SELECT * FROM projet.rechercher_offres_par_mot_cle WHERE mail = ? AND mots_cles ILIKE % || ? || %;");
                        ps.setString(1, mailEtudiant);
                        ps.setString(2, reponseMotCle[0]);

                        main.displayData(ps.executeQuery());
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                    break;
                case "3" :
                    String[] questionPoserCandidature = {
                            "Quel est le code du stage qui vous interesse ?",
                            "Quelles sont vos motivations pour ce stage ?"
                    };

                    String[] reponsePoserCandidature = main.askForInput(questionPoserCandidature);
                    try {
                        PreparedStatement ps = conn.prepareStatement("SELECT projet.poser_candidature(?, ?, ?);");
                        ps.setString(1, mailEtudiant);
                        ps.setString(2, reponsePoserCandidature[1]);
                        ps.setString(3, reponsePoserCandidature[0]);

                        if(ps.execute()){
                            System.out.println("Insertion de la candidature reussie");
                        }
                    } catch (SQLException e) {
                        System.out.println("Insertion de la candidature echouee");
                        e.printStackTrace();
                    }
                    break;
                case "4" :
                    try {
                        PreparedStatement ps = conn.prepareStatement("SELECT * FROM projet.voirOffresCandidatureEtudiant WHERE mail = ?;");
                        ps.setString(1, mailEtudiant);

                        main.displayData(ps.executeQuery());
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                    break;
                case "5" :
                    String[] questionAnnulationCandidature = {"Quel est le code du stage de la candidature a annule ?"};
                    String[] reponseAnnulationCandidature = main.askForInput(questionAnnulationCandidature);
                    try {
                        PreparedStatement ps = conn.prepareStatement("SELECT projet.annuler_candidature(?,?);");
                        ps.setString(1, mailEtudiant);
                        ps.setString(2, reponseAnnulationCandidature[0]);

                        if(ps.execute()){
                            System.out.println("annulation de la candidature reussie");
                        }
                    } catch (SQLException e) {
                        System.out.println("annulation de la candidature echouee");
                        e.printStackTrace();
                    }
                    break;
                case "6" :
                    try {
                        conn.close();
                        fini = true;
                    } catch (SQLException e) {
                        System.out.println("echec de la fermeture de la connexion");
                    }
                    break;
            }
        }
    }
}
