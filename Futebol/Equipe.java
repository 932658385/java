import java.util.List;

/**
 * Classe abstrata que representa uma equipe de futebol.
 * 
 * Esta classe serve como base para representar diferentes tipos de equipes,
 * como seleções nacionais, clubes, etc.
 */
abstract class Equipe {
    private String nome;
    private List<Jogador> jogadores;

    /**
     * Construtor da classe Equipe.
     * 
     * @param nome O nome da equipe.
     * @param jogadores A lista de jogadores da equipe.
     */
    public Equipe(String nome, List<Jogador> jogadores) {
        this.nome = nome;
        this.jogadores = jogadores;
    }
    
    /**
     * Obtém o nome da equipe.
     * 
     * @return O nome da equipe.
     */
    public String getNome() {
        return this.nome;
    }

    /**
     * Define o nome da equipe.
     * 
     * @param nome O nome da equipe a ser definido.
     */
    public void setNome(String nome) {
        this.nome = nome;
    }

    /**
     * Obtém a lista de jogadores da equipe.
     * 
     * @return A lista de jogadores da equipe.
     */
    public List<Jogador> getJogadores() {
        return this.jogadores;
    }

    /**
     * Define a lista de jogadores da equipe.
     * 
     * @param jogadores A lista de jogadores da equipe a ser definida.
     */
    public void setJogadores(List<Jogador> jogadores) {
        this.jogadores = jogadores;
    }
}
