import java.util.Scanner;

public class main {
    static Scanner scanner = new Scanner(System.in);

    public static void main(String[] args) {
        ProgrammePrincipal pp = new ProgrammePrincipal();
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


