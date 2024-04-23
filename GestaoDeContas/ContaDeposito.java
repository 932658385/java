/**
 * A classe abstrata ContaDeposito representa uma conta de depósito genérica em um banco.
 * ContaDeposito possui um número de conta, saldo, taxa de juros e data de início.
 * 
 * Esta classe define métodos abstratos para depositar, levantar, consultar saldo e atualizar saldo.
 * A implementação desses métodos é fornecida pelas subclasses concretas.
 * 
 * ContaDeposito também implementa a interface Comparable para permitir a ordenação com base no número de conta.
 */
public abstract class ContaDeposito implements Comparable<ContaDeposito> {
    /** O número da conta */
    private int numeroConta;
    
    /** O saldo da conta */
    private double saldo;
    
    /** A taxa de juros da conta */
    private double taxaJuros;
    
    /** A data de início da conta */
    private String dataInicio;

    /**
     * Constrói uma nova instância de ContaDeposito com os parâmetros fornecidos.
     * 
     * @param numeroConta O número da conta
     * @param saldo O saldo inicial da conta
     * @param taxaJuros A taxa de juros da conta
     * @param dataInicio A data de início da conta
     */
    public ContaDeposito(int numeroConta, double saldo, double taxaJuros, String dataInicio) {
        this.numeroConta = numeroConta;
        this.saldo = saldo;
        this.taxaJuros = taxaJuros;
        this.dataInicio = dataInicio;
    }

    /**
     * Retorna o número da conta.
     * 
     * @return O número da conta
     */
    public int getNumeroConta() {
        return numeroConta;
    }

    /**
     * Define o número da conta.
     * 
     * @param numeroConta O número da conta a ser definido
     */
    public void setNumeroConta(int numeroConta) {
        this.numeroConta = numeroConta;
    }

    /**
     * Retorna o saldo da conta.
     * 
     * @return O saldo da conta
     */
    public double getSaldo() {
        return saldo;
    }

    /**
     * Define o saldo da conta.
     * 
     * @param saldo O saldo da conta a ser definido
     */
    public void setSaldo(double saldo) {
        this.saldo = saldo;
    }

    /**
     * Retorna a taxa de juros da conta.
     * 
     * @return A taxa de juros da conta
     */
    public double getTaxaJuros() {
        return taxaJuros;
    }

    /**
     * Define a taxa de juros da conta.
     * 
     * @param taxaJuros A taxa de juros da conta a ser definida
     */
    public void setTaxaJuros(double taxaJuros) {
        this.taxaJuros = taxaJuros;
    }

    /**
     * Retorna a data de início da conta.
     * 
     * @return A data de início da conta
     */
    public String getDataInicio() {
        return dataInicio;
    }

    /**
     * Define a data de início da conta.
     * 
     * @param dataInicio A data de início da conta a ser definida
     */
    public void setDataInicio(String dataInicio) {
        this.dataInicio = dataInicio;
    }

    /**
     * Realiza um depósito na conta.
     * 
     * @param quantia A quantia a ser depositada
     * @throws InvalidDepositException se o depósito for inválido
     */
    public abstract void depositar(double quantia) throws InvalidDepositException;

    /**
     * Realiza um levantamento da conta.
     * 
     * @param quantia A quantia a ser levantada
     * @throws InvalidWithdrawalException se o levantamento for inválido
     */
    public abstract void levantar(double quantia) throws InvalidWithdrawalException;

    /**
     * Consulta o saldo atual da conta.
     * 
     * @return O saldo atual da conta
     */
    public abstract double consultarSaldo();

    /**
     * Atualiza o saldo da conta com base em operações específicas, como taxas de juros.
     */
    public abstract void atualizarSaldo();

    /**
     * Compara esta conta com outra conta com base no número da conta.
     * 
     * @param outraConta A outra conta a ser comparada
     * @return Um valor negativo, zero ou positivo se esta conta for menor, igual ou maior que a outra conta
     */
    @Override
    public int compareTo(ContaDeposito outraConta) {
        return this.getNumeroConta() - outraConta.getNumeroConta();
    }
}