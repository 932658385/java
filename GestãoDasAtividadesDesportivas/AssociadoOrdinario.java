import java.util.Date;

/**
 * Classe que representa um associado ordinário em uma associação desportiva.
 * Estende a classe Associado.
 */
public class AssociadoOrdinario extends Associado {
    private String atividadeInscrita;
    private Date dataInscricaoAtividade;

    /**
     * Obtém a atividade inscrita pelo associado ordinário.
     * @return A atividade inscrita.
     */
    public String getAtividadeInscrita() {
        return atividadeInscrita;
    }

    /**
     * Define a atividade inscrita pelo associado ordinário.
     * @param atividadeInscrita A atividade inscrita.
     */
    public void setAtividadeInscrita(String atividadeInscrita) {
        this.atividadeInscrita = atividadeInscrita;
    }

    /**
     * Obtém a data de inscrição na atividade pelo associado ordinário.
     * @return A data de inscrição na atividade.
     */
    public Date getDataInscricaoAtividade() {
        return dataInscricaoAtividade;
    }

    /**
     * Define a data de inscrição na atividade pelo associado ordinário.
     * @param dataInscricaoAtividade A data de inscrição na atividade.
     */
    public void setDataInscricaoAtividade(Date dataInscricaoAtividade) {
        this.dataInscricaoAtividade = dataInscricaoAtividade;
    }
}