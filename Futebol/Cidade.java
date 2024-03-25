/**
 * Classe que representa uma cidade onde ocorrem jogos de futebol.
 */
public class Cidade {
    private String nome;

    /**
     * Construtor da classe Cidade.
     * 
     * @param nome O nome da cidade.
     */
    public Cidade(String nome) {
        this.nome = nome;
    }

    /**
     * Obtém o nome da cidade.
     * 
     * @return O nome da cidade.
     */
    public String getNome() {
        return this.nome;
    }

    /**
     * Define o nome da cidade.
     * 
     * @param nome O nome da cidade a ser definido.
     */
    public void setNome(String nome) {
        this.nome = nome;
    }
}