import java.util.ArrayList;

/**
 * Classe que representa uma lâmpada mágica capaz de realizar desejos.
 */
public class LampadaMagica {
    private int capacidade; // Capacidade total de esfregadas
    private int esfregadas; // Número de esfregadas realizadas na lâmpada
    private int demoniosReciclados; // Número de demônios reciclados
    private ArrayList<Genio> geniosDisponiveis; // Lista de gênios disponíveis na lâmpada

    /**
     * Construtor da classe LampadaMagica.
     * @param capacidade A capacidade total de esfregadas da lâmpada.
     */
    public LampadaMagica(int capacidade) {
        this.capacidade = capacidade;
        this.esfregadas = 0;
        this.demoniosReciclados = 0;
        this.geniosDisponiveis = new ArrayList<>();
        // Inicializa a lista de gênios disponíveis com a capacidade especificada
        for (int i = 0; i < capacidade; i++) {
            this.geniosDisponiveis.add(new Genio());
        }
    }

    /**
     * Obtém o número de gênios disponíveis na lâmpada.
     * @return O número de gênios disponíveis.
     */
    public int getGeniosDisponiveis() {
        return this.geniosDisponiveis.size();
    }

    /**
     * Obtém o número de demônios reciclados.
     * @return O número de demônios reciclados.
     */
    public int getDemoniosReciclados() {
        return this.demoniosReciclados;
    }

    /**
     * Esfrega a lâmpada mágica para realizar desejos.
     * @param desejos O número de desejos a serem realizados.
     */
    public void rub(int desejos) {
        this.esfregadas++;
        // Verifica se o número de esfregadas é par e ainda há gênios disponíveis
        if (this.esfregadas % 2 == 0 && !this.geniosDisponiveis.isEmpty()) {
            // Remove o gênio utilizado e adiciona um novo gênio à lista
            this.geniosDisponiveis.remove(0);
            this.geniosDisponiveis.add(new Genio());
        } else {
            // Limpa a lista de gênios disponíveis e adiciona um demônio reciclável
            this.geniosDisponiveis.clear();
            this.geniosDisponiveis.add(new DemonioReciclavel());
            this.demoniosReciclados++; // Incrementa o número de demônios reciclados
        }
    }
}
