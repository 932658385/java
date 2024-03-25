import java.util.Date;

/**
 * Representa uma transação de compra ou venda de um título.
 */
public class Transacao {
    private Titulo titulo; // O título envolvido na transação
    private int quantidade; // A quantidade de títulos transacionados
    private double valor; // O valor da transação
    private Date dataHora; // A data e hora da transação

    /**
     * Construtor para a classe Transacao.
     * 
     * @param titulo    O título envolvido na transação.
     * @param quantidade    A quantidade de títulos transacionados.
     * @param valor         O valor da transação.
     * @param dataHora      A data e hora da transação.
     */
    public Transacao(Titulo titulo, int quantidade, double valor, Date dataHora) {
        this.titulo = titulo;
        this.quantidade = quantidade;
        this.valor = valor;
        this.dataHora = dataHora;
    }

    // Getters e setters para os atributos

    /**
     * Retorna o título envolvido na transação.
     * 
     * @return O título envolvido na transação.
     */
    public Titulo getTitulo() {
        return this.titulo;
    }

    /**
     * Define o título envolvido na transação.
     * 
     * @param titulo O título envolvido na transação.
     */
    public void setTitulo(Titulo titulo) {
        this.titulo = titulo;
    }

    /**
     * Retorna a quantidade de títulos transacionados.
     * 
     * @return A quantidade de títulos transacionados.
     */
    public int getQuantidade() {
        return this.quantidade;
    }

    /**
     * Define a quantidade de títulos transacionados.
     * 
     * @param quantidade A quantidade de títulos transacionados.
     */
    public void setQuantidade(int quantidade) {
        this.quantidade = quantidade;
    }

    /**
     * Retorna o valor da transação.
     * 
     * @return O valor da transação.
     */
    public double getValor() {
        return this.valor;
    }

    /**
     * Define o valor da transação.
     * 
     * @param valor O valor da transação.
     */
    public void setValor(double valor) {
        this.valor = valor;
    }

    /**
     * Retorna a data e hora da transação.
     * 
     * @return A data e hora da transação.
     */
    public Date getDataHora() {
        return this.dataHora;
    }

    /**
     * Define a data e hora da transação.
     * 
     * @param dataHora A data e hora da transação.
     */
    public void setDataHora(Date dataHora) {
        this.dataHora = dataHora;
    }
}
