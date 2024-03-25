/**
 * Classe para representar uma venda de um imóvel.
 */
public class Venda {
    private String agencia;
    private String data;
    private Funcionario vendedor;
    private Imovel imovel;
    private Cliente clienteComprador;
    private Cliente clienteProprietario;

    /**
     * Construtor para a classe Venda.
     * 
     * @param agencia A agência onde a venda foi realizada.
     * @param data A data da venda.
     * @param vendedor O funcionário que realizou a venda.
     * @param imovel O imóvel que foi vendido.
     * @param clienteComprador O cliente que comprou o imóvel.
     * @param clienteProprietario O cliente que é proprietário do imóvel vendido.
     */
    public Venda(String agencia, String data, Funcionario vendedor, Imovel imovel, Cliente clienteComprador, Cliente clienteProprietario) {
        this.agencia = agencia;
        this.data = data;
        this.vendedor = vendedor;
        this.imovel = imovel;
        this.clienteComprador = clienteComprador;
        this.clienteProprietario = clienteProprietario;
    }

    /**
     * Obtém a agência onde a venda foi realizada.
     * 
     * @return A agência da venda.
     */
    public String getAgencia() {
        return this.agencia;
    }

    /**
     * Define a agência onde a venda foi realizada.
     * 
     * @param agencia A agência da venda.
     */
    public void setAgencia(String agencia) {
        this.agencia = agencia;
    }

    /**
     * Obtém a data da venda.
     * 
     * @return A data da venda.
     */
    public String getData() {
        return this.data;
    }

    /**
     * Define a data da venda.
     * 
     * @param data A data da venda.
     */
    public void setData(String data) {
        this.data = data;
    }

    /**
     * Obtém o vendedor da venda.
     * 
     * @return O funcionário que realizou a venda.
     */
    public Funcionario getVendedor() {
        return this.vendedor;
    }

    /**
     * Define o vendedor da venda.
     * 
     * @param vendedor O funcionário que realizou a venda.
     */
    public void setVendedor(Funcionario vendedor) {
        this.vendedor = vendedor;
    }

    /**
     * Obtém o imóvel vendido.
     * 
     * @return O imóvel que foi vendido.
     */
    public Imovel getImovel() {
        return this.imovel;
    }

    /**
     * Define o imóvel vendido.
     * 
     * @param imovel O imóvel que foi vendido.
     */
    public void setImovel(Imovel imovel) {
        this.imovel = imovel;
    }

    /**
     * Obtém o cliente comprador do imóvel.
     * 
     * @return O cliente que comprou o imóvel.
     */
    public Cliente getClienteComprador() {
        return this.clienteComprador;
    }

    /**
     * Define o cliente comprador do imóvel.
     * 
     * @param clienteComprador O cliente que comprou o imóvel.
     */
    public void setClienteComprador(Cliente clienteComprador) {
        this.clienteComprador = clienteComprador;
    }

    /**
     * Obtém o cliente proprietário do imóvel vendido.
     * 
     * @return O cliente que é proprietário do imóvel vendido.
     */
    public Cliente getClienteProprietario() {
        return this.clienteProprietario;
    }

    /**
     * Define o cliente proprietário do imóvel vendido.
     * 
     * @param clienteProprietario O cliente que é proprietário do imóvel vendido.
     */
    public void setClienteProprietario(Cliente clienteProprietario) {
        this.clienteProprietario = clienteProprietario;
    }
}