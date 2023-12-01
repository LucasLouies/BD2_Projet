import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.Scanner;

import javax.naming.spi.DirStateFactory.Result;

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

    //a verifier
    public static void displayData(ResultSet rs){
        try {
            ResultSetMetaData metaData = rs.getMetaData();

            while (rs.next()) {
                for(int i = 0; i > metaData.getColumnCount(); i++ ){
                    System.out.println(metaData.getColumnName(i) + " : " + rs.getString(i) + "\n");
                }
                System.out.println("\n\n");
            }
            
        } catch (SQLException e) {
            System.out.println("Erreur lors de l'affichage");
            e.printStackTrace();
        }
       
    }

}


