
public class ProgrammePrincipal {

    public ProgrammePrincipal() {
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            System.out.println("Driver PostgreSQL manquant !");
            System.exit(1);
        }
        System.out.println("Bienvenue dans le systeme de gestion de stage !\n");
        String[] questionLogin = {"Etes-vous un professeur(1), une entreprise(2) ou un etudiant(3)?"};
        String [] reponseLogin = main.askForInput(questionLogin);

        switch (reponseLogin[0]){
            case "1" :
                ProgrammeProfesseur programmeProfesseur = new ProgrammeProfesseur();
                break;
            case "2" :
                ProgrammeEntreprise programmeEntreprise = new ProgrammeEntreprise();
                break;
            case "3" :
                ProgrammeEtudiant programmeEtudiant = new ProgrammeEtudiant();
                break;
        }
        System.out.println("Au revoir !");
    }
}