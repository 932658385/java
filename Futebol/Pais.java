import java.util.List;

/**
 * Classe que representa um país participante em um campeonato de futebol.
 */
public class Pais {
    private String nome;
    private List<Jogador> jogadores;

    /**
     * Construtor da classe Pais.
     * 
     * @param nome O nome do país.
     * @param jogadores A lista de jogadores da seleção nacional do país.
     */
    public Pais(String nome, List<Jogador> jogadores) {
        this.nome = nome;
        this.jogadores = jogadores;
    }
    
    /**
     * Obtém o nome do país.
     * 
     * @return O nome do país.
     */
    public String getNome() {
        return this.nome;
    }

    /**
     * Define o nome do país.
     * 
     * @param nome O nome do país a ser definido.
     */
    public void setNome(String nome) {
        this.nome = nome;
    }

    /**
     * Obtém a lista de jogadores da seleção nacional do país.
     * 
     * @return A lista de jogadores da seleção nacional do país.
     */
    public List<Jogador> getJogadores() {
        return this.jogadores;
    }

    /**
     * Define a lista de jogadores da seleção nacional do país.
     * 
     * @param jogadores A lista de jogadores da seleção nacional do país a ser definida.
     */
    public void setJogadores(List<Jogador> jogadores) {
        this.jogadores = jogadores;
    }    
}