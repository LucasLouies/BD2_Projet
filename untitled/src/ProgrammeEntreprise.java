import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ProgrammeEntreprise{

    public ProgrammeEntreprise() {
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
            System.out.println("Voici la section entreprise !");
            String[] questionChoixEntreprise =  {
                    "Encoder une offre de stage(1)\n" +
                            "Voir les mots clés(2)\n" +
                            "Ajouter un mot clé à une de vos offres(3)\n" +
                            "Voir ses offres de stages(4)\n" +
                            "Voir les candidatures d'une de vos offres(5)\n" +
                            "Sélectionner un étudiant pour l'une de vos offres(6)\n" +
                            "Annuler une offre de stage(7)\n" +
                            "Quitter(8)"
            };

            String[] reponseChoixEntreprise = main.askForInput(questionChoixEntreprise);

            switch (reponseChoixEntreprise[0]){
                case "1":
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
                    fini = true;
                    break;
            }
        }

    }
}
