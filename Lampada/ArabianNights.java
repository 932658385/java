import java.util.ArrayList;

// Classe ArabianNights
public class ArabianNights {
    public static void main(String[] args) {
        // 1. Criar uma lâmpada mágica com capacidade para 4 gênios.
        LampadaMagica lampada = new LampadaMagica(4);
        
        // 2. Esfregar 5 vezes a lâmpada, indicando os números de desejos 2, 3, 4, 5, 1.
        lampada.rub(2);
        lampada.rub(3);
        lampada.rub(4);
        lampada.rub(5);
        lampada.rub(1);

        // 3. Invocar e imprimir o resultado do método toString sobre cada um dos gênios.
        ArrayList<Genio> genios = new ArrayList<>();
        for (int i = 0; i < 4; i++) {
            genios.add(new GenioBemHumorado());
        }
        genios.add(new GenioMalHumorado()); // Adicionando GenioMalHumorado
        genios.add(new DemonioReciclavel());

        for (Genio genio : genios) {
            System.out.println(genio.toString());
        }

        // 4. Pedir um desejo a cada um dos gênios.
        for (Genio genio : genios) {
            genio.grantWish(1);
        }

        // 5. Invocar e imprimir o resultado do método toString sobre cada um dos gênios.
        for (Genio genio : genios) {
            System.out.println(genio.toString());
        }

        // 6. Pedir um desejo a cada um dos gênios.
        for (Genio genio : genios) {
            genio.grantWish(1);
        }

        // 7. Invocar e imprimir o resultado do método toString sobre cada um dos gênios.
        for (Genio genio : genios) {
            System.out.println(genio.toString());
        }

        // 8. Colocar o demônio reciclável na lâmpada.
        lampada.rub(7);

        // 9. Esfregar a lâmpada, indicando 7 como número de desejos.
        lampada.rub(7);

        // 10. Invocar e imprimir o resultado do método toString sobre o gênio obtido.
        Genio genio = new DemonioReciclavel();
        System.out.println(genio.toString());
    }
}