import java.util.List;
import java.util.Map;

/**
 * Classe para representar um grupo de equipes em um campeonato.
 */
public class Grupo {
    private List<Equipe> equipes; // Lista de equipes pertencentes ao grupo
    private Map<Equipe, Integer> pontuacao; // Pontuação de cada equipe no grupo

    /**
     * Construtor da classe Grupo.
     * 
     * @param equipes   Lista de equipes pertencentes ao grupo.
     * @param pontuacao Mapa representando a pontuação de cada equipe no grupo.
     */
    public Grupo(List<Equipe> equipes, Map<Equipe,Integer> pontuacao) {
        this.equipes = equipes;
        this.pontuacao = pontuacao;
    }

    /**
     * Obtém a lista de equipes pertencentes ao grupo.
     * 
     * @return A lista de equipes.
     */
    public List<Equipe> getEquipes() {
        return this.equipes;
    }

    /**
     * Define a lista de equipes pertencentes ao grupo.
     * 
     * @param equipes A nova lista de equipes.
     */
    public void setEquipes(List<Equipe> equipes) {
        this.equipes = equipes;
    }

    /**
     * Obtém o mapa representando a pontuação de cada equipe no grupo.
     * 
     * @return O mapa de pontuação.
     */
    public Map<Equipe,Integer> getPontuacao() {
        return this.pontuacao;
    }

    /**
     * Define o mapa representando a pontuação de cada equipe no grupo.
     * 
     * @param pontuacao O novo mapa de pontuação.
     */
    public void setPontuacao(Map<Equipe,Integer> pontuacao) {
        this.pontuacao = pontuacao;
    }    
}