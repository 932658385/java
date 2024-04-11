import java.util.List;

/**
 * Classe que representa um campeonato de futsal.
 * Estende a classe Campeonato.
 */
public class CampeonatoFutsal extends Campeonato {
    private boolean necessidadeEquipeArbitragem;
    private List<Associado> equipeArbitragem;

    /**
     * Verifica se há necessidade de uma equipe de arbitragem para o campeonato de futsal.
     * @return true se houver necessidade, false caso contrário.
     */
    public boolean isNecessidadeEquipeArbitragem() {
        return necessidadeEquipeArbitragem;
    }

    /**
     * Define se há necessidade de uma equipe de arbitragem para o campeonato de futsal.
     * @param necessidadeEquipeArbitragem true se houver necessidade, false caso contrário.
     */
    public void setNecessidadeEquipeArbitragem(boolean necessidadeEquipeArbitragem) {
        this.necessidadeEquipeArbitragem = necessidadeEquipeArbitragem;
    }

    /**
     * Obtém a equipe de arbitragem do campeonato de futsal.
     * @return A equipe de arbitragem.
     */
    public List<Associado> getEquipeArbitragem() {
        return equipeArbitragem;
    }

    /**
     * Define a equipe de arbitragem do campeonato de futsal.
     * @param equipeArbitragem A equipe de arbitragem.
     */
    public void setEquipeArbitragem(List<Associado> equipeArbitragem) {
        this.equipeArbitragem = equipeArbitragem;
    }
}