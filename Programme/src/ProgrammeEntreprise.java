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
            String[] questionIdentificationEntreprise = {
                "Quelle est votre identifiant ?",
                "Quelle est votre mot de passe"
            };
            String[] identifiantsEntreprise = main.askForInput(questionIdentificationEntreprise);


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
                    String[] questionEncoderStage = {
                        "Veuillez entrer la description de l'offre de stage",
                        "Veuillez entre le semestre du stage"
                    };

                    String[] reponseEncoderStage = main.askForInput(questionEncoderStage);
                    break;
                case "2":
                    
                    break;
                case "3":
                    String[] questionAjouterMotCle = {
                        "Veuillez entrer le code du stage",
                        "Veuillez enter le mot cle"
                    };

                    String[] reponseAjouterMotCle = main.askForInput(questionAjouterMotCle);
                    break;
                case "4":
                    break;
                case "5":
                    break;
                case "6":
                    String[] questionSelectionnerEtudiant = {
                        "Veuillez entrer le code de l'offre",
                        "Veuillez entrer l'adresse email de l'étudiant"
                    };

                    String[] reponseSelectionnerEtudiant = main.askForInput(questionSelectionnerEtudiant);
                    break;
                case "7":
                    String[] questionAnnulerStage = {
                        "Veuillez entrer le code du stage à annuler"
                    };

                    String[] reponseAnnulerStage = main.askForInput(questionAnnulerStage);
                    break;
                case "8":
                    fini = true;
                    try {
                        conn.close();
                    } catch (SQLException e) {
                        System.out.println("echec de la fermeture de la connexion");
                    }
                    
                    break;
            }
        }

    }
}
