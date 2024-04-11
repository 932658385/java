import java.util.Date;
import java.util.List;

public class CampeonatoFutsal extends Campeonato {
    private boolean necessidadeEquipeArbitragem;
    private List<Associado> equipeArbitragem;

    // Getters e Setters
    public boolean isNecessidadeEquipeArbitragem() {
        return necessidadeEquipeArbitragem;
    }

    public void setNecessidadeEquipeArbitragem(boolean necessidadeEquipeArbitragem) {
        this.necessidadeEquipeArbitragem = necessidadeEquipeArbitragem;
    }

    public List<Associado> getEquipeArbitragem() {
        return equipeArbitragem;
    }

    public void setEquipeArbitragem(List<Associado> equipeArbitragem) {
        this.equipeArbitragem = equipeArbitragem;
    }
}