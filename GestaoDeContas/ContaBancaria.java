import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

/**
 * Representa uma conta bancária que pode conter uma conta corrente e várias contas poupança.
 */
public class ContaBancaria implements Comparable<ContaBancaria> {
    private int numeroConta;
    private List<Titular> titulares;
    private ContaOrdem contaOrdem;
    private List<ContaPoupanca> contasPoupanca;

    /**
     * Cria uma nova instância de ContaBancaria com o número da conta e uma conta corrente associada.
     *
     * @param numeroConta o número da conta
     * @param contaOrdem  a conta corrente associada
     */
    public ContaBancaria(int numeroConta, ContaOrdem contaOrdem) {
        this.numeroConta = numeroConta;
        this.titulares = new ArrayList<>();
        this.contaOrdem = contaOrdem;
        this.contasPoupanca = new ArrayList<>();
    }

    /**
     * Obtém o número da conta.
     *
     * @return o número da conta
     */
    public int getNumeroConta() {
        return numeroConta;
    }

    /**
     * Define o número da conta.
     *
     * @param numeroConta o número da conta
     */
    public void setNumeroConta(int numeroConta) {
        this.numeroConta = numeroConta;
    }

    /**
     * Obtém a lista de titulares da conta.
     *
     * @return a lista de titulares
     */
    public List<Titular> getTitulares() {
        return titulares;
    }

    /**
     * Define a lista de titulares da conta.
     *
     * @param titulares a lista de titulares
     */
    public void setTitulares(List<Titular> titulares) {
        this.titulares = titulares;
    }

    /**
     * Obtém a conta corrente associada.
     *
     * @return a conta corrente
     */
    public ContaOrdem getContaOrdem() {
        return contaOrdem;
    }

    /**
     * Define a conta corrente associada.
     *
     * @param contaOrdem a conta corrente
     */
    public void setContaOrdem(ContaOrdem contaOrdem) {
        this.contaOrdem = contaOrdem;
    }

    /**
     * Obtém a lista de contas poupança associadas.
     *
     * @return a lista de contas poupança
     */
    public List<ContaPoupanca> getContasPoupanca() {
        return contasPoupanca;
    }

    /**
     * Define a lista de contas poupança associadas.
     *
     * @param contasPoupanca a lista de contas poupança
     */
    public void setContasPoupanca(List<ContaPoupanca> contasPoupanca) {
        this.contasPoupanca = contasPoupanca;
    }

    /**
     * Realiza um depósito na conta corrente.
     *
     * @param quantia a quantia a ser depositada
     * @throws InvalidDepositException se a quantia for negativa
     */
    public void depositar(double quantia) throws InvalidDepositException {
        contaOrdem.depositar(quantia);
    }

    /**
     * Realiza um levantamento na conta corrente.
     *
     * @param quantia a quantia a ser levantada
     * @throws InvalidWithdrawalException se a quantia for negativa ou superior ao saldo
     */
    public void levantar(double quantia) throws InvalidWithdrawalException {
        contaOrdem.levantar(quantia);
    }

    /**
     * Consulta o saldo corrente da conta.
     *
     * @return o saldo corrente
     */
    public double consultarSaldoCorrente() {
        return contaOrdem.consultarSaldo();
    }

    /**
     * Consulta o saldo total da conta, incluindo a conta corrente e as contas poupança.
     *
     * @return o saldo total
     */
    public double consultarSaldoTotal() {
        double saldoTotal = contaOrdem.consultarSaldo();
        for (ContaPoupanca poupanca : contasPoupanca) {
            saldoTotal += poupanca.consultarSaldo();
        }
        return saldoTotal;
    }

    /**
     * Lista os titulares da conta.
     *
     * @return a lista de titulares
     */
    public List<Titular> listarTitulares() {
        return titulares;
    }

    /**
     * Lista as contas poupança associadas.
     *
     * @return a lista de contas poupança
     */
    public List<ContaPoupanca> listarContasPoupanca() {
        return contasPoupanca;
    }

    /**
     * Adiciona uma nova conta poupança à lista de contas poupança associadas.
     *
     * @param poupanca a conta poupança a ser adicionada
     */
    public void adicionarContaPoupanca(ContaPoupanca poupanca) {
        contasPoupanca.add(poupanca);
    }

    /**
     * Verifica se a conta pode ser removida do banco.
     *
     * @return true se o saldo total da conta for zero, caso contrário false
     */
    public boolean podeSerRemovida() {
        return consultarSaldoTotal() == 0;
    }

    /**
     * Atualiza o saldo de todas as contas poupança associadas.
     */
    public void atualizarSaldo() {
        for (ContaPoupanca poupanca : contasPoupanca) {
            poupanca.atualizarSaldo();
        }
    }

    @Override
    public int compareTo(ContaBancaria outraConta) {
        return this.getNumeroConta() - outraConta.getNumeroConta();
    }
}