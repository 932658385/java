import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;

public class FileUtil {

    public static void salvarEquipaTxt(Equipa equipa, String filename) {
        if (!filename.endsWith(".txt")) {
            filename += ".txt";
        }
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filename))) {
            writer.write(equipa.toString()); // Alteração aqui para chamar o método toString()
            System.out.println("Equipa salva com sucesso em " + filename);
        } catch (IOException e) {
            System.out.println("Erro ao salvar equipa: " + e.getMessage());
        }
    }

    public static void salvarJogadorTxt(Jogador jogador, String filename) {
        if (!filename.endsWith(".txt")) {
            filename += ".txt";
        }
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filename))) {
            writer.write(jogador.toString()); // Alteração aqui para chamar o método toString()
            System.out.println("Jogador salvo com sucesso em " + filename);
        } catch (IOException e) {
            System.out.println("Erro ao salvar jogador: " + e.getMessage());
        }
    }
}