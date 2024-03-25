import java.util.List;

/**
 * Classe que representa uma conta de condomínio.
 * Implementa a interface Conta para garantir a emissão de balancete.
 */
public class ContaCondominio implements Conta {
    private List<Condomico> condomicos; // Lista de condôminos relacionados à conta
    private List<DespesaComum> despesasComuns; // Lista de despesas comuns relacionadas à conta

    /**
     * Construtor da classe ContaCondominio.
     * 
     * @param condomicos     A lista de condôminos relacionados à conta.
     * @param despesasComuns A lista de despesas comuns relacionadas à conta.
     */
    public ContaCondominio(List<Condomico> condomicos, List<DespesaComum> despesasComuns) {
        this.condomicos = condomicos;
        this.despesasComuns = despesasComuns;
    }

    /**
     * Obtém a lista de condôminos relacionados à conta.
     * 
     * @return A lista de condôminos relacionados à conta.
     */
    public List<Condomico> getCondomicos() {
        return this.condomicos;
    }

    /**
     * Define a lista de condôminos relacionados à conta.
     * 
     * @param condomicos A lista de condôminos relacionados à conta.
     */
    public void setCondomicos(List<Condomico> condomicos) {
        this.condomicos = condomicos;
    }

    /**
     * Obtém a lista de despesas comuns relacionadas à conta.
     * 
     * @return A lista de despesas comuns relacionadas à conta.
     */
    public List<DespesaComum> getDespesasComuns() {
        return this.despesasComuns;
    }

    /**
     * Define a lista de despesas comuns relacionadas à conta.
     * 
     * @param despesasComuns A lista de despesas comuns relacionadas à conta.
     */
    public void setDespesasComuns(List<DespesaComum> despesasComuns) {
        this.despesasComuns = despesasComuns;
    }

    /**
     * Método para emitir um balancete da conta do condomínio.
     * 
     * Este método deve ser implementado para fornecer um balancete detalhado das despesas e receitas do condomínio.
     */
    @Override
    public void emitirBalancete() {
        // Implementação para emitir balancete da conta do condomínio
    }
}