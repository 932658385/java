/**
 * Classe que representa um condômino em um condomínio.
 */
public class Condomico {
    private String nome; // Nome do condômino
    private double parcela; // Valor da parcela do condômino

    /**
     * Construtor da classe Condomico.
     * 
     * @param nome    O nome do condômino.
     * @param parcela O valor da parcela do condômino.
     */
    public Condomico(String nome, double parcela) {
        this.nome = nome;
        this.parcela = parcela;
    }

    /**
     * Obtém o nome do condômino.
     * 
     * @return O nome do condômino.
     */
    public String getNome() {
        return this.nome;
    }

    /**
     * Define o nome do condômino.
     * 
     * @param nome O nome do condômino.
     */
    public void setNome(String nome) {
        this.nome = nome;
    }

    /**
     * Obtém o valor da parcela do condômino.
     * 
     * @return O valor da parcela do condômino.
     */
    public double getParcela() {
        return this.parcela;
    }

    /**
     * Define o valor da parcela do condômino.
     * 
     * @param parcela O valor da parcela do condômino.
     */
    public void setParcela(double parcela) {
        this.parcela = parcela;
    }
}