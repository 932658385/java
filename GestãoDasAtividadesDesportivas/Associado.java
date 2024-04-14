import java.util.Date;
import java.util.List;

/**
 * Classe que representa um associado de uma associação desportiva.
 */
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

    /**
     * Obtém o nome do associado.
     * @return O nome do associado.
     */
    public String getNome() {
        return nome;
    }

    /**
     * Define o nome do associado.
     * @param nome O nome do associado.
     */
    public void setNome(String nome) {
        this.nome = nome;
    }

    /**
     * Obtém o número de sócio do associado.
     * @return O número de sócio do associado.
     */
    public int getNumeroSocio() {
        return numeroSocio;
    }

    /**
     * Define o número de sócio do associado.
     * @param numeroSocio O número de sócio do associado.
     */
    public void setNumeroSocio(int numeroSocio) {
        this.numeroSocio = numeroSocio;
    }

    /**
     * Obtém o número do bilhete de identidade do associado.
     * @return O número do bilhete de identidade do associado.
     */
    public int getNumeroBilheteIdentidade() {
        return numeroBilheteIdentidade;
    }

    /**
     * Define o número do bilhete de identidade do associado.
     * @param numeroBilheteIdentidade O número do bilhete de identidade do associado.
     */
    public void setNumeroBilheteIdentidade(int numeroBilheteIdentidade) {
        this.numeroBilheteIdentidade = numeroBilheteIdentidade;
    }

    /**
     * Obtém o número de contribuinte do associado.
     * @return O número de contribuinte do associado.
     */
    public int getNumeroContribuinte() {
        return numeroContribuinte;
    }

    /**
     * Define o número de contribuinte do associado.
     * @param numeroContribuinte O número de contribuinte do associado.
     */
    public void setNumeroContribuinte(int numeroContribuinte) {
        this.numeroContribuinte = numeroContribuinte;
    }

    /**
     * Obtém o endereço do associado.
     * @return O endereço do associado.
     */
    public String getEndereco() {
        return endereco;
    }

    /**
     * Define o endereço do associado.
     * @param endereco O endereço do associado.
     */
    public void setEndereco(String endereco) {
        this.endereco = endereco;
    }

    /**
     * Obtém o número de telefone do associado.
     * @return O número de telefone do associado.
     */
    public String getNumeroTelefone() {
        return numeroTelefone;
    }

    /**
     * Define o número de telefone do associado.
     * @param numeroTelefone O número de telefone do associado.
     */
    public void setNumeroTelefone(String numeroTelefone) {
        this.numeroTelefone = numeroTelefone;
    }

    /**
     * Obtém o email do associado.
     * @return O email do associado.
     */
    public String getEmail() {
        return email;
    }

    /**
     * Define o email do associado.
     * @param email O email do associado.
     */
    public void setEmail(String email) {
        this.email = email;
    }

    /**
     * Obtém a data de inscrição do associado.
     * @return A data de inscrição do associado.
     */
    public Date getDataInscricao() {
        return dataInscricao;
    }

    /**
     * Define a data de inscrição do associado.
     * @param dataInscricao A data de inscrição do associado.
     */
    public void setDataInscricao(Date dataInscricao) {
        this.dataInscricao = dataInscricao;
    }

    /**
     * Verifica se as quotas do associado estão em dia.
     * @return true se as quotas estiverem em dia, false caso contrário.
     */
    public boolean getQuotasEmDia() {
        return quotasEmDia;
    }

    /**
     * Define se as quotas do associado estão em dia.
     * @param quotasEmDia true se as quotas estiverem em dia, false caso contrário.
     */
    public void setQuotasEmDia(boolean quotasEmDia) {
        this.quotasEmDia = quotasEmDia;
    }

    /**
     * Obtém a lista de anos em que o associado tem quotas em atraso.
     * @return A lista de anos de quotas em atraso.
     */
    public List<Integer> getAnosQuotasAtrasadas() {
        return anosQuotasAtrasadas;
    }

    /**
     * Define a lista de anos em que o associado tem quotas em atraso.
     * @param anosQuotasAtrasadas A lista de anos de quotas em atraso.
     */
    public void setAnosQuotasAtrasadas(List<Integer> anosQuotasAtrasadas) {
        this.anosQuotasAtrasadas = anosQuotasAtrasadas;
    }

    /**
     * Obtém o estatuto do associado.
     * @return O estatuto do associado.
     */
    public String getEstatuto() {
        return estatuto;
    }

    /**
     * Define o estatuto do associado.
     * @param estatuto O estatuto do associado.
     */
    public void setEstatuto(String estatuto) {
        this.estatuto = estatuto;
    }

    /**
     * Obtém a identificação do associado.
     * @return A identificação do associado.
     */
    public String getIdentificacao() {
        return identificacao;
    }

    /**
     * Define a identificação do associado.
     * @param identificacao A identificação do associado.
     */
    public void setIdentificacao(String identificacao) {
        this.identificacao = identificacao;
    }

    /**
     * Obtém o associado responsável pela atividade do associado.
     * @return O associado responsável pela atividade.
     */
    public Associado getResponsavelAtividade() {
        return responsavelAtividade;
    }

    /**
     * Define o associado responsável pela atividade do associado.
     * @param responsavelAtividade O associado responsável pela atividade.
     */
    public void setResponsavelAtividade(Associado responsavelAtividade) {
        this.responsavelAtividade = responsavelAtividade;
    }

    /**
     * Obtém a lista de anos de mandato do associado.
     * @return A lista de anos de mandato.
     */
    public List<Integer> getAnosMandato() {
        return anosMandato;
    }

    /**
     * Define a lista de anos de mandato do associado.
     * @param anosMandato A lista de anos de mandato.
     */
    public void setAnosMandato(List<Integer> anosMandato) {
        this.anosMandato = anosMandato;
    }
}