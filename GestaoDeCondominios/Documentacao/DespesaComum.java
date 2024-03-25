/**
 * Classe que representa uma despesa comum em um edifício.
 */
public class DespesaComum {
    private String descricao; // Descrição da despesa
    private double valor; // Valor da despesa

    /**
     * Construtor da classe DespesaComum.
     * 
     * @param descricao A descrição da despesa.
     * @param valor O valor da despesa.
     */
    public DespesaComum(String descricao, double valor) {
        this.descricao = descricao;
        this.valor = valor;
    }

    /**
     * Obtém a descrição da despesa.
     * 
     * @return A descrição da despesa.
     */
    public String getDescricao() {
        return this.descricao;
    }

    /**
     * Define a descrição da despesa.
     * 
     * @param descricao A descrição da despesa.
     */
    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }

    /**
     * Obtém o valor da despesa.
     * 
     * @return O valor da despesa.
     */
    public double getValor() {
        return this.valor;
    }

    /**
     * Define o valor da despesa.
     * 
     * @param valor O valor da despesa.
     */
    public void setValor(double valor) {
        this.valor = valor;
    }
}