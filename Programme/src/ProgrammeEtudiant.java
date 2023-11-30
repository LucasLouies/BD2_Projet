import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ProgrammeEtudiant{
    public ProgrammeEtudiant() {
        String url="jdbc:postgresql://172.24.2.6:5432/dblucaslouies";
        Connection conn=null;
        try {
            conn= DriverManager.getConnection(url,"lucaslouies","AK7F8EJUC");
        } catch (SQLException e) {
            System.out.println("Impossible de joindre le server !");
            System.exit(1);
        }

        boolean fini = false;
        while (!fini){
            System.out.println("Voici la section etudiant !");
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
                    break;
                case "2" :
                    break;
                case "3" :
                    break;
                case "4" :
                    break;
                case "5" :
                    break;
                case "6" :
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
