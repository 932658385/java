import java.util.List;

/**
 * Classe que representa um associado dirigente em uma associação desportiva.
 * Estende a classe Associado.
 */
public class AssociadoDirigente extends Associado {
    private List<Integer> anosMandato;

    /**
     * Obtém a lista de anos de mandato do associado dirigente.
     * @return A lista de anos de mandato.
     */
    public List<Integer> getAnosMandato() {
        return anosMandato;
    }

    /**
     * Define a lista de anos de mandato do associado dirigente.
     * @param anosMandato A lista de anos de mandato.
     */
    public void setAnosMandato(List<Integer> anosMandato) {
        this.anosMandato = anosMandato;
    }
}
