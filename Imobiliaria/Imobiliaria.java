import java.util.ArrayList;
import java.util.List;

/**
 * Classe para representar uma imobiliária.
 */
public class Imobiliaria {
    private List<Imovel> imoveis;
    private List<Cliente> clientes;
    private List<Funcionario> funcionarios;
    private List<Venda> vendas;

    /**
     * Construtor para a classe Imobiliaria. Inicializa as listas de imóveis, clientes,
     * funcionários e vendas.
     */
    public Imobiliaria() {
        this.imoveis = new ArrayList<>();
        this.clientes = new ArrayList<>();
        this.funcionarios = new ArrayList<>();
        this.vendas = new ArrayList<>();
    }

    /**
     * Obtém a lista de imóveis da imobiliária.
     * 
     * @return A lista de imóveis.
     */
    public List<Imovel> getImoveis() {
        return imoveis;
    }

    /**
     * Obtém a lista de clientes da imobiliária.
     * 
     * @return A lista de clientes.
     */
    public List<Cliente> getClientes() {
        return clientes;
    }

    /**
     * Obtém a lista de funcionários da imobiliária.
     * 
     * @return A lista de funcionários.
     */
    public List<Funcionario> getFuncionarios() {
        return funcionarios;
    }

    /**
     * Obtém a lista de vendas realizadas pela imobiliária.
     * 
     * @return A lista de vendas.
     */
    public List<Venda> getVendas() {
        return vendas;
    }

    /**
     * Adiciona um imóvel à lista de imóveis da imobiliária.
     * 
     * @param imovel O imóvel a ser adicionado.
     */
    public void adicionarImovel(Imovel imovel) {
        imoveis.add(imovel);
    }

    /**
     * Remove um imóvel da lista de imóveis da imobiliária.
     * 
     * @param imovel O imóvel a ser removido.
     */
    public void removerImovel(Imovel imovel) {
        imoveis.remove(imovel);
    }

    /**
     * Adiciona um cliente à lista de clientes da imobiliária.
     * 
     * @param cliente O cliente a ser adicionado.
     */
    public void adicionarCliente(Cliente cliente) {
        clientes.add(cliente);
    }

    /**
     * Remove um cliente da lista de clientes da imobiliária.
     * 
     * @param cliente O cliente a ser removido.
     */
    public void removerCliente(Cliente cliente) {
        clientes.remove(cliente);
    }

    /**
     * Adiciona um funcionário à lista de funcionários da imobiliária.
     * 
     * @param funcionario O funcionário a ser adicionado.
     */
    public void adicionarFuncionario(Funcionario funcionario) {
        funcionarios.add(funcionario);
    }

    /**
     * Remove um funcionário da lista de funcionários da imobiliária.
     * 
     * @param funcionario O funcionário a ser removido.
     */
    public void removerFuncionario(Funcionario funcionario) {
        funcionarios.remove(funcionario);
    }

    /**
     * Registra uma venda na imobiliária, adicionando-a à lista de vendas.
     * 
     * @param venda A venda a ser registrada.
     */
    public void registrarVenda(Venda venda) {
        vendas.add(venda);
    }
}