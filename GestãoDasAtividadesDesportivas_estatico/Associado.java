import java.util.Date;
import java.util.List;

public class Associado {
    private String nome;
    private int numeroSocio;
    private int numeroBilheteIdentidade;
    private int numeroContribuinte;
    private String endereco;
    private String numeroTelefone;
    private String email;
    private String estatuto;
    private Date dataInscricao;
    private boolean quotasEmDia;
    private List<Integer> anosQuotasAtrasadas;
    private String identificacao;
    private Associado responsavelAtividade;
    private List<Integer> anosMandato;

    // Getters e Setters
    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public int getNumeroSocio() {
        return numeroSocio;
    }

    public void setNumeroSocio(int numeroSocio) {
        this.numeroSocio = numeroSocio;
    }

    public int getNumeroBilheteIdentidade() {
        return numeroBilheteIdentidade;
    }

    public void setNumeroBilheteIdentidade(int numeroBilheteIdentidade) {
        this.numeroBilheteIdentidade = numeroBilheteIdentidade;
    }

    public int getNumeroContribuinte() {
        return numeroContribuinte;
    }

    public void setNumeroContribuinte(int numeroContribuinte) {
        this.numeroContribuinte = numeroContribuinte;
    }

    public String getEndereco() {
        return endereco;
    }

    public void setEndereco(String endereco) {
        this.endereco = endereco;
    }

    public String getNumeroTelefone() {
        return numeroTelefone;
    }

    public void setNumeroTelefone(String numeroTelefone) {
        this.numeroTelefone = numeroTelefone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Date getDataInscricao() {
        return dataInscricao;
    }

    public void setDataInscricao(Date dataInscricao) {
        this.dataInscricao = dataInscricao;
    }

    public boolean isQuotasEmDia() {
        return quotasEmDia;
    }

    public void setQuotasEmDia(boolean quotasEmDia) {
        this.quotasEmDia = quotasEmDia;
    }

    public List<Integer> getAnosQuotasAtrasadas() {
        return anosQuotasAtrasadas;
    }

    public void setAnosQuotasAtrasadas(List<Integer> anosQuotasAtrasadas) {
        this.anosQuotasAtrasadas = anosQuotasAtrasadas;
    }

    public String getEstatuto() {
        return estatuto;
    }

    public void setEstatuto(String estatuto) {
        this.estatuto = estatuto;
    }

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

    public List<Integer> getAnosMandato() {
        return anosMandato;
    }

    public void setAnosMandato(List<Integer> anosMandato) {
        this.anosMandato = anosMandato;
    }
}