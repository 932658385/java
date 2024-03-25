import java.util.List;

/**
 * Classe que representa a fase de qualificação de um campeonato de futebol.
 */
public class FaseQualificacao {
    private List<Jogo> jogos;

    /**
     * Construtor da classe FaseQualificacao.
     * 
     * @param jogos A lista de jogos que compõem a fase de qualificação.
     */
    public FaseQualificacao(List<Jogo> jogos) {
        this.jogos = jogos;
    }
    
    /**
     * Obtém a lista de jogos que compõem a fase de qualificação.
     * 
     * @return A lista de jogos da fase de qualificação.
     */
    public List<Jogo> getJogos() {
        return this.jogos;
    }

    /**
     * Define a lista de jogos que compõem a fase de qualificação.
     * 
     * @param jogos A lista de jogos a ser definida.
     */
    public void setJogos(List<Jogo> jogos) {
        this.jogos = jogos;
    }
}
