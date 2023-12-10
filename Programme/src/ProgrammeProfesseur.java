import java.sql.*;

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
        System.out.println("Voici la section professeur !");
        while (!fini){
            String[] questionChoixProf = {
                    "encoder un etudiant (1)\n" +
                            "encore une entreprise(2)\n" +
                            "encoder un mot-clé(3)\n" +
                            "voir les offres de stage non validées(4)\n" +
                            "valider une offre de stage via son code(5)\n"+
                             "voir les offres de stage validées(6)\n" +
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

                    String selEtudiant = BCrypt.gensalt();
                    reponseInsertionEtudiant[4] = BCrypt.hashpw(reponseInsertionEtudiant[4], selEtudiant);


                    try {
                        PreparedStatement ps = conn.prepareStatement("SELECT projet.encoder_etudiant(?,?,?,?,?);");
                        int i = 0;
                        for (String reponse : reponseInsertionEtudiant){
                            ps.setString(i+1, reponse);
                            i++;
                        }
                        if(ps.execute()){
                            System.out.println("Insertion de l'étudiant réussie\n");
                        }


                    } catch (SQLException e){
                        System.out.println("Erreur lors de l’insertion d'un étudiant!\n");
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

                    String selEntreprise = BCrypt.gensalt();
                    reponseInsertionEntreprise[2] = BCrypt.hashpw(reponseInsertionEntreprise[2], selEntreprise);

                    try {
                        PreparedStatement ps = conn.prepareStatement("SELECT projet.encoder_entreprise(?,?,?,?,?);");
                        int i = 0;
                        for (String reponse : reponseInsertionEntreprise){
                            ps.setString(i+1, reponse);
                            i++;
                        }
                        if(ps.execute()){
                            System.out.println("Insertion de l'entreprise réussie\n");
                        }
                    } catch (SQLException e) {
                        System.out.println("Erreur lors de l'insertion d'une entreprise\n");
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
                            System.out.println("Insertion du mot clé réussie\n");
                        }
                    } catch (SQLException e) {
                        System.out.println("Erreur lors de l'insertion d'un mot clé\n");
                        e.printStackTrace();
                    }
                    break;
                case "4":
                    try {
                        PreparedStatement ps = conn.prepareStatement("SELECT * FROM projet.voir_offre_stage_non_valide;");
                        ResultSet rs = ps.executeQuery();
                        main.displayData(rs);
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
                            System.out.println("Validation de l'offre réussie\n");
                        }
                    } catch (SQLException e) {
                        System.out.println("Erreur lors de la validation de l'offre de stage\n");
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
                        PreparedStatement ps = conn.prepareStatement("SELECT DISTINCT * FROM projet.voir_etudiants_sans_stages;");
                        main.displayData(ps.executeQuery());
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                    break;
                case "8":
                    try {
                        PreparedStatement ps = conn.prepareStatement("SELECT * FROM projet.voir_offres_stage_attribues;");
                        main.displayData(ps.executeQuery());
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                    break;
                case "9":
                    try {
                        conn.close();
                        fini = true;
                    } catch (SQLException e) {
                        System.out.println("echec de la fermeture de la connexion\n");
                    }
                    break;
            }
        }
    }
}