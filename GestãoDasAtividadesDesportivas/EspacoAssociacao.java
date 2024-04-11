public class EspacoAssociacao {
    private String identificacao;
    private Associado responsavelAtividade;

    // Getters e Setters
    public String getIdentificacao() {
        return identificacao;
    }

    public void setIdentificacao(String identificacao) {
        this.identificacao = identificacao;
    }

    public Associado getResponsavelAtividade() {
        return responsavelAtividade;
    }

    public void setResponsavelAtividade(Associado responsavelAtividade) {
        this.responsavelAtividade = responsavelAtividade;
    }
}