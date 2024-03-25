import java.util.List;

/**
 * Classe que representa um orçamento para um determinado ano.
 */
public class Orcamento {
    private int ano;
    private double totalDespesas;
    private double totalReceitas;
    private double saldoPrevisto;
    private String comentarios;

    /**
     * Construtor da classe Orcamento.
     *
     * @param ano              O ano do orçamento.
     * @param totalDespesas     O total das despesas previstas.
     * @param totalReceitas     O total das receitas previstas.
     * @param saldoPrevisto     O saldo previsto, calculado como totalReceitas - totalDespesas.
     * @param comentarios       Comentários ou observações adicionais sobre o orçamento.
     */
    public Orcamento(int ano, double totalDespesas, double totalReceitas, double saldoPrevisto, String comentarios) {
        this.ano = ano;
        this.totalDespesas = totalDespesas;
        this.totalReceitas = totalReceitas;
        this.saldoPrevisto = saldoPrevisto;
        this.comentarios = comentarios;
    }

    /**
     * Obtém o ano do orçamento.
     *
     * @return O ano do orçamento.
     */
    public int getAno() {
        return this.ano;
    }

    /**
     * Define o ano do orçamento.
     *
     * @param ano O ano do orçamento.
     */
    public void setAno(int ano) {
        this.ano = ano;
    }

    /**
     * Obtém o total das despesas previstas.
     *
     * @return O total das despesas previstas.
     */
    public double getTotalDespesas() {
        return this.totalDespesas;
    }

    /**
     * Define o total das despesas previstas.
     *
     * @param totalDespesas O total das despesas previstas.
     */
    public void setTotalDespesas(double totalDespesas) {
        this.totalDespesas = totalDespesas;
    }

    /**
     * Obtém o total das receitas previstas.
     *
     * @return O total das receitas previstas.
     */
    public double getTotalReceitas() {
        return this.totalReceitas;
    }

    /**
     * Define o total das receitas previstas.
     *
     * @param totalReceitas O total das receitas previstas.
     */
    public void setTotalReceitas(double totalReceitas) {
        this.totalReceitas = totalReceitas;
    }

    /**
     * Obtém o saldo previsto.
     *
     * @return O saldo previsto.
     */
    public double getSaldoPrevisto() {
        return this.saldoPrevisto;
    }

    /**
     * Define o saldo previsto.
     *
     * @param saldoPrevisto O saldo previsto.
     */
    public void setSaldoPrevisto(double saldoPrevisto) {
        this.saldoPrevisto = saldoPrevisto;
    }

    /**
     * Obtém os comentários ou observações sobre o orçamento.
     *
     * @return Os comentários ou observações sobre o orçamento.
     */
    public String getComentarios() {
        return this.comentarios;
    }

    /**
     * Define os comentários ou observações sobre o orçamento.
     *
     * @param comentarios Os comentários ou observações sobre o orçamento.
     */
    public void setComentarios(String comentarios) {
        this.comentarios = comentarios;
    }
}