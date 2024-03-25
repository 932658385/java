import java.util.Date;

/**
 * Representa um título de participação em uma empresa.
 */
public class Titulo {
    private String designacao; // Designação do título
    private Date dataEmissao; // Data de emissão do título
    private double valorFacial; // Valor facial do título

    /**
     * Construtor para a classe Titulo.
     * 
     * @param designacao    A designação do título.
     * @param dataEmissao   A data de emissão do título.
     * @param valorFacial   O valor facial do título.
     */
    public Titulo(String designacao, Date dataEmissao, double valorFacial) {
        this.designacao = designacao;
        this.dataEmissao = dataEmissao;
        this.valorFacial = valorFacial;
    }

    // Getters e setters para os atributos

    /**
     * Retorna a designação do título.
     * 
     * @return A designação do título.
     */
    public String getDesignacao() {
        return this.designacao;
    }

    /**
     * Define a designação do título.
     * 
     * @param designacao A designação do título.
     */
    public void setDesignacao(String designacao) {
        this.designacao = designacao;
    }

    /**
     * Retorna a data de emissão do título.
     * 
     * @return A data de emissão do título.
     */
    public Date getDataEmissao() {
        return this.dataEmissao;
    }

    /**
     * Define a data de emissão do título.
     * 
     * @param dataEmissao A data de emissão do título.
     */
    public void setDataEmissao(Date dataEmissao) {
        this.dataEmissao = dataEmissao;
    }

    /**
     * Retorna o valor facial do título.
     * 
     * @return O valor facial do título.
     */
    public double getValorFacial() {
        return this.valorFacial;
    }

    /**
     * Define o valor facial do título.
     * 
     * @param valorFacial O valor facial do título.
     */
    public void setValorFacial(double valorFacial) {
        this.valorFacial = valorFacial;
    }
}