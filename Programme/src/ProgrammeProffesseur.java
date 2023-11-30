import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class ProgrammeProffesseur{

    boolean fini = false;
    public ProgrammeProffesseur() {
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
                            ps.setString(i+1, reponseInsertionEtudiant[i]);
                            i++;
                        }
                        if(ps.execute()){
                            System.out.println("OK");
                        }


                    } catch (SQLException e){
                        System.out.println("Erreur lors de l’insertion d'un étudiant!");
                        e.printStackTrace();
                    }

                    break;
                case "2":
                    break;
                case "3":
                    break;
                case "4":
                    break;
                case "5":
                    break;
                case "6":
                    break;
                case "7":
                    break;
                case "8":
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