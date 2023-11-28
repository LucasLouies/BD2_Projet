import java.sql.*;
import java.util.Scanner;

public class main {
    static Scanner scanner = new Scanner(System.in);

    public static void main(String[] args) {

        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            System.out.println("Driver PostgreSQL manquant !");
            System.exit(1);
        }

        String url="jdbc:postgresql://172.24.2.6:5432/dblucaslouies";
        Connection conn=null;
        try {
            conn= DriverManager.getConnection(url,"lucaslouies","AK7F8EJUC");
        } catch (SQLException e) {
            System.out.println("Impossible de joindre le server !");
            System.exit(1);
        }

        System.out.println("Bienvenue dans le systeme de gestion de stage !\n");

        String[] questionLogin = {"Etes-vous un professeur(1), une entreprise(2) ou un etudiant(3)?"};
        String [] reponseLogin = askForInput(questionLogin);

        boolean fini = false;

        switch (reponseLogin[0]){
            case "1":
                while (!fini){
                    System.out.println("Voici dans la section professeur !");
                    String[] questionChoixProf = {"encoder un etudiant (1)\n" +
                            "encore une entreprise(2)\n" +
                            "encoder un mot-clé(3)\n" +
                            "voir les offres de stage validées(4)\n" +
                            "voir une offre de stage via son code(5)\n" +
                            "voir les offres de stage non validées(6)\n" +
                            "voir les étudiants qui n'ont pas de stage(7)\n" +
                            "voir les offres de stage attribuées(8)\n" +
                            "quitter(9)"};
                    String[] reponseChoixProf = askForInput(questionChoixProf);

                    switch (reponseChoixProf[0]){
                        case "1":
                            String[] questionInsertionEtudiant  = {"Quel est le nom de l'étudiant?",
                                    "Quel est le prenom de l'étudiant?",
                                    "Quel est l'adresse mail de l'étudiant?",
                                    "Quel est le semestre du stage de l'étudiant?",
                                    "Quel est le mot de passe de l'étudiant?"
                            };
                            String[] reponseInsertionEtudiant = askForInput(questionInsertionEtudiant);

                            try {
                                PreparedStatement ps = conn.prepareStatement("SELECT projet.encoder_etudiant(?,?,?,?,?);");
                                int i = 0;
                                for (String reponse : reponseInsertionEtudiant){
                                    ps.setString(i+1, reponseInsertionEtudiant[i]);
                                    i++;
                                }
                                ps.executeUpdate();
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
                            fini = true;
                            break;
                    }
                }
                break;

            case "2":
                while (!fini){
                    System.out.println("Voici dans la section entreprise !");
                }
                break;

            case "3":
                while (!fini){
                    System.out.println("Voici dans la section etudiant !");
                }
                break;
        }

        System.out.println("Au revoir !");

    }

    public static String[] askForInput(String[] questions){
        String[] answers = new String[questions.length];
        int i = 0;

        for (String question: questions) {
            System.out.println(question);
            answers[i] = scanner.nextLine();
            i++;

        }
        return answers;
    }



}
