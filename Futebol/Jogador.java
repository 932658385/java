/**
 * Classe que representa um jogador de futebol.
 */
public class Jogador {
    private String nome;
    private int idade;

    /**
     * Construtor da classe Jogador.
     * 
     * @param nome O nome do jogador.
     * @param idade A idade do jogador.
     */
    public Jogador(String nome, int idade) {
        this.nome = nome;
        this.idade = idade;
    }
    
    /**
     * Obtém o nome do jogador.
     * 
     * @return O nome do jogador.
     */
    public String getNome() {
        return this.nome;
    }

    /**
     * Define o nome do jogador.
     * 
     * @param nome O nome do jogador a ser definido.
     */
    public void setNome(String nome) {
        this.nome = nome;
    }

    /**
     * Obtém a idade do jogador.
     * 
     * @return A idade do jogador.
     */
    public int getIdade() {
        return this.idade;
    }

    /**
     * Define a idade do jogador.
     * 
     * @param idade A idade do jogador a ser definida.
     */
    public void setIdade(int idade) {
        this.idade = idade;
    }
}