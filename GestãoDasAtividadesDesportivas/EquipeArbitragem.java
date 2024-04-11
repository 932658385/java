import java.util.List;

/**
 * Classe que representa uma equipe de arbitragem em um evento desportivo.
 */
public class EquipeArbitragem {
    private List<Associado> arbitros;

    /**
     * Obtém a lista de árbitros da equipe de arbitragem.
     * @return A lista de árbitros.
     */
    public List<Associado> getArbitros() {
        return arbitros;
    }

    /**
     * Define a lista de árbitros da equipe de arbitragem.
     * @param arbitros A lista de árbitros.
     */
    public void setArbitros(List<Associado> arbitros) {
        this.arbitros = arbitros;
    }
}