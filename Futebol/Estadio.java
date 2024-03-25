/**
 * Classe que representa um estádio onde ocorrem jogos de futebol.
 */
public class Estadio {
    private String nome;
    private String cidade;

    /**
     * Construtor da classe Estadio.
     * 
     * @param nome O nome do estádio.
     * @param cidade A cidade onde está localizado o estádio.
     */
    public Estadio(String nome, String cidade) {
        this.nome = nome;
        this.cidade = cidade;
    }

    /**
     * Obtém o nome do estádio.
     * 
     * @return O nome do estádio.
     */
    public String getNome() {
        return this.nome;
    }

    /**
     * Define o nome do estádio.
     * 
     * @param nome O nome do estádio a ser definido.
     */
    public void setNome(String nome) {
        this.nome = nome;
    }

    /**
     * Obtém a cidade onde está localizado o estádio.
     * 
     * @return A cidade onde está localizado o estádio.
     */
}