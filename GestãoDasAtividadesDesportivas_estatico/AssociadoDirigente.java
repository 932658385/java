import java.util.List;

public class AssociadoDirigente extends Associado {
    private List<Integer> anosMandato;

    // Getters e Setters
    public List<Integer> getAnosMandato() {
        return anosMandato;
    }

    public void setAnosMandato(List<Integer> anosMandato) {
        this.anosMandato = anosMandato;
    }
}