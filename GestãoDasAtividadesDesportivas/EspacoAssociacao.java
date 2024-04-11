/**
 * Classe que representa um espaço de uma associação desportiva.
 */
public class EspacoAssociacao {
    private String identificacao;
    private Associado responsavelAtividade;

    /**
     * Obtém a identificação do espaço da associação.
     * @return A identificação do espaço.
     */
    public String getIdentificacao() {
        return identificacao;
    }

    /**
     * Define a identificação do espaço da associação.
     * @param identificacao A identificação do espaço.
     */
    public void setIdentificacao(String identificacao) {
        this.identificacao = identificacao;
    }

    /**
     * Obtém o associado responsável pela atividade no espaço da associação.
     * @return O associado responsável pela atividade.
     */
    public Associado getResponsavelAtividade() {
        return responsavelAtividade;
    }

    /**
     * Define o associado responsável pela atividade no espaço da associação.
     * @param responsavelAtividade O associado responsável pela atividade.
     */
    public void setResponsavelAtividade(Associado responsavelAtividade) {
        this.responsavelAtividade = responsavelAtividade;
    }
}