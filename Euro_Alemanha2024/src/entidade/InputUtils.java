package entidade;
import java.util.Scanner;


public class InputUtils {
    private static Scanner scanner = new Scanner(System.in);

    public static String getString(String prompt) {
        System.out.print(prompt);
        return scanner.nextLine();
    }

    public static int getInt(String prompt) {
        System.out.print(prompt);
        while (!scanner.hasNextInt()) {
            System.out.print("Por favor, insira um número inteiro: ");
            scanner.next();
        }
        int value = scanner.nextInt();
        scanner.nextLine();  // Limpar o buffer
        return value;
    }
 
    public static void closeScanner() {
        scanner.close();
    }
}
