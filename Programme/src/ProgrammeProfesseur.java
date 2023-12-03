import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class ProgrammeProfesseur{

    boolean fini = false;
    public ProgrammeProfesseur() {
        String url="jdbc:postgresql://172.24.2.6:5432/dblucaslouies";
        Connection conn=null;
        try {
            conn= DriverManager.getConnection(url,"lucaslouies","AK7F8EJUC");
        } catch (SQLException e) {
            System.out.println("Impossible de joindre le server !");
            System.exit(1);
        }

        while (!fini){
            System.out.println("Voici la section professeur !");
            String[] questionChoixProf = {
                    "encoder un etudiant (1)\n" +
                            "encore une entreprise(2)\n" +
                            "encoder un mot-clé(3)\n" +
                            "voir les offres de stage validées(4)\n" +
                            "voir une offre de stage via son code(5)\n" +
                            "voir les offres de stage non validées(6)\n" +
                            "voir les étudiants qui n'ont pas de stage(7)\n" +
                            "voir les offres de stage attribuées(8)\n" +
                            "quitter(9)"};
            String[] reponseChoixProf = main.askForInput(questionChoixProf);

            switch (reponseChoixProf[0]){
                case "1":
                    String[] questionInsertionEtudiant  = {"Quel est le nom de l'étudiant?",
                            "Quel est le prenom de l'étudiant?",
                            "Quel est l'adresse mail de l'étudiant?",
                            "Quel est le semestre du stage de l'étudiant?",
                            "Quel est le mot de passe de l'étudiant?"
                    };
                    String[] reponseInsertionEtudiant = main.askForInput(questionInsertionEtudiant);

                    try {
                        PreparedStatement ps = conn.prepareStatement("SELECT projet.encoder_etudiant(?,?,?,?,?);");
                        int i = 0;
                        for (String reponse : reponseInsertionEtudiant){
                            ps.setString(i+1, reponse);
                            i++;
                        }
                        if(ps.execute()){
                            System.out.println("Insertion de l'étudiant réussie");
                        }


                    } catch (SQLException e){
                        System.out.println("Erreur lors de l’insertion d'un étudiant!");
                        e.printStackTrace();
                    }

                    break;
                case "2":
                    String[] questionInsertionEntreprise = {
                        "Veuillez entrer l'identifiant de l'entreprise",
                        "Quel est le nom de l'entreprise ?",
                        "Veuillez entrer le mot de passe de l'entreprise",
                        "Quelle est l'adresse mail de l'entreprise ?",
                        "Quelle est l'adresse de l'entreprise ?"
                    };

                    String[] reponseInsertionEntreprise = main.askForInput(questionInsertionEntreprise);

                    try {
                        PreparedStatement ps = conn.prepareStatement("SELECT projet.encoder_entreprise(?,?,?,?,?);");
                        int i = 0;
                        for (String reponse : reponseInsertionEntreprise){
                            ps.setString(i+1, reponse);
                            i++;
                        }
                        if(ps.execute()){
                            System.out.println("Insertion de l'entreprise réussie");
                        }
                    } catch (SQLException e) {
                        System.out.println("Erreur lors de l'insertion d'une entreprise");
                        e.printStackTrace();
                    }
                    break;
                case "3":
                    String[] questionInsertionMotCle = {"Quelle est le mot clé à insérer ?"};
                    String[] reponseInsertionMotCle = main.askForInput(questionInsertionMotCle);

                    try {
                        PreparedStatement ps = conn.prepareStatement("SELECT projet.encoder_mot_cle(?);");
                        ps.setString(1, reponseInsertionMotCle[0]);

                        if(ps.execute()){
                            System.out.println("Insertion du mot clé réussie");
                        }
                    } catch (SQLException e) {
                        System.out.println("Erreur lors de l'insertion d'un mot clé");
                        e.printStackTrace();
                    }
                    break;
                case "4":
                    try {
                        PreparedStatement ps = conn.prepareStatement("SELECT * FROM projet.voir_offre_non_valide;");
                        main.displayData(ps.executeQuery());
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                    break;
                case "5":
                    String[] questionValideOffre = {"Veuillez entrer le code de l'offre a valide"};
                    String[] reponseValideOffre = main.askForInput(questionValideOffre);
                    try {
                        PreparedStatement ps = conn.prepareStatement("SELECT projet.valider_offre_stage(?);");
                        ps.setString(1, reponseValideOffre[0]);
                        
                        if(ps.execute()) {
                            System.out.println("Validation de l'offre réussie");
                        }
                    } catch (SQLException e) {
                        System.out.println("Erreur lors de la validation de l'offre de stage");
                        e.printStackTrace();
                    }
                    
                    break;
                case "6":
                    try {
                        PreparedStatement ps = conn.prepareStatement("SELECT * FROM projet.voir_offre_stage_valide;");
                        main.displayData(ps.executeQuery());
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                    break;
                case "7":
                    try {
                        PreparedStatement ps = conn.prepareStatement("SELECT * FROM projet.voir_etudiants_sans_stage;");
                        main.displayData(ps.executeQuery());
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                    break;
                case "8":
                    try {
                        PreparedStatement ps = conn.prepareStatement("SELECT * FROM projet.voir_offre_stage_attribues;");
                        main.displayData(ps.executeQuery());
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                    break;
                case "9":
                    try {
                        conn.close();
                    } catch (SQLException e) {
                        System.out.println("echec de la fermeture de la connexion");
                    }
                    fini = true;
                    break;
            }
        }
    }
}