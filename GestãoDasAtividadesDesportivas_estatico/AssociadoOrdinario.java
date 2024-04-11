import java.util.Date;

public class AssociadoOrdinario extends Associado {
    private String atividadeInscrita;
    private Date dataInscricaoAtividade;

    // Getters e Setters
    public String getAtividadeInscrita() {
        return atividadeInscrita;
    }

    public void setAtividadeInscrita(String atividadeInscrita) {
        this.atividadeInscrita = atividadeInscrita;
    }

    public Date getDataInscricaoAtividade() {
        return dataInscricaoAtividade;
    }

    public void setDataInscricaoAtividade(Date dataInscricaoAtividade) {
        this.dataInscricaoAtividade = dataInscricaoAtividade;
    }
}