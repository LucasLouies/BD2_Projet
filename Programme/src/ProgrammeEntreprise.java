import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
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

            String codeEntreprise = identifiantsEntreprise[0];

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

                    try {
                        PreparedStatement ps = conn.prepareStatement("SELECT projet.encoder_offre_stage(?,?,?);");
                        ps.setString(1, reponseEncoderStage[0]);
                        ps.setString(2, codeEntreprise);
                        ps.setString(3, reponseEncoderStage[1]);

                        if(ps.execute()){
                            System.out.println("Insertion du stage reussie");
                        }
                    } catch (SQLException e) {
                        System.out.println("Erreur lors de l'insertion du stage");
                        e.printStackTrace();
                    }
                    break;
                case "2":
                    try {
                        PreparedStatement ps = conn.prepareStatement("SELECT * FROM projet.voir_mots_cle;");
                        main.displayData(ps.executeQuery());
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                    
                    break;
                case "3":
                    String[] questionAjouterMotCle = {
                        "Veuillez entrer le code du stage",
                        "Veuillez enter le mot cle"
                    };

                    String[] reponseAjouterMotCle = main.askForInput(questionAjouterMotCle);
                    try {
                        PreparedStatement ps = conn.prepareStatement("SELECT projet.ajouter_mot_cle(?,?);");
                        int i = 0;
                        for (String reponse : reponseAjouterMotCle) {
                            ps.setString(i + 1, reponse);
                            i++;
                        }

                        if (ps.execute()) {
                            System.out.println("Ajout du mot cle reussi");
                        }
                    } catch (SQLException e) {
                        System.out.println("Erreur lors de l'ajout du mot cle");
                        e.printStackTrace();
                    }
                    
                    break;
                case "4":
                    try {
                        PreparedStatement ps = conn.prepareStatement("SELECT * FROM projet.voir_offres_stage vos WHERE vos.code_offre_stage = ?;");
                        ps.setString(1, codeEntreprise);

                        main.displayData(ps.executeQuery());
                    } catch (Exception e) {
                        e.printStackTrace();
                    }

                    break;
                case "5":
                    //to do => réflechir à la vue projet.voir_candidatures_par_entreprise
                    break;
                case "6":
                    String[] questionSelectionnerEtudiant = {
                        "Veuillez entrer le code de l'offre",
                        "Veuillez entrer l'adresse email de l'étudiant"
                    };

                    String[] reponseSelectionnerEtudiant = main.askForInput(questionSelectionnerEtudiant);

                    try {
                        PreparedStatement ps = conn.prepareStatement("SELECT projet.selectionner_etudiant(?,?);");
                        int i = 0;
                        for (String reponse : reponseSelectionnerEtudiant) {
                            ps.setString(i + 1, reponse);
                            i++;
                        }

                        if (ps.execute()) {
                            System.out.println("Selection de l'etudiant reussie");
                        }
                    } catch (SQLException e) {
                        System.out.println("Erreur lors de la selection d'un etudiant");
                        e.printStackTrace();
                    }
                    break;
                case "7":
                    String[] questionAnnulerStage = {
                        "Veuillez entrer le code du stage à annuler"
                    };

                    String[] reponseAnnulerStage = main.askForInput(questionAnnulerStage);

                    try {
                        PreparedStatement ps = conn.prepareStatement("SELECT projet.annuler_stage(?);");
                        ps.setString(1, reponseAnnulerStage[0]);

                        if (ps.execute()) {
                            System.out.println("Annulation du stage reussie");   
                        }
                    } catch (SQLException e) {
                        System.out.println("Erreur lors de l'annulation d'un stage");
                        e.printStackTrace();
                    }
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
