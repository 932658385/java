/**
 * Representa uma conta poupança que herda da classe abstrata ContaDeposito.
 */
public class ContaPoupanca extends ContaDeposito {
    private int duracaoDias;

    /**
     * Cria uma nova instância de ContaPoupanca com o número da conta, saldo inicial, taxa de juros, data de início e duração em dias.
     *
     * @param numeroConta o número da conta
     * @param saldo o saldo inicial da conta
     * @param taxaJuros a taxa de juros da conta
     * @param dataInicio a data de início da conta (no formato "DD/MM/AAAA")
     * @param duracaoDias a duração em dias da conta poupança
     */
    public ContaPoupanca(int numeroConta, double saldo, double taxaJuros, String dataInicio, int duracaoDias) {
        super(numeroConta, saldo, taxaJuros, dataInicio);
        this.duracaoDias = duracaoDias;
    }

    /**
     * Não é possível depositar em uma conta poupança. Lança uma exceção.
     *
     * @param quantia a quantia a ser depositada
     * @throws InvalidDepositException sempre lança essa exceção
     */
    @Override
    public void depositar(double quantia) throws InvalidDepositException {
        throw new InvalidDepositException("Não é possível depositar em uma conta poupança.");
    }

    /**
     * Não é possível levantar de uma conta poupança. Lança uma exceção.
     *
     * @param quantia a quantia a ser levantada
     * @throws InvalidWithdrawalException sempre lança essa exceção
     */
    @Override
    public void levantar(double quantia) throws InvalidWithdrawalException {
        throw new InvalidWithdrawalException("Não é possível levantar de uma conta poupança.");
    }

    /**
     * Consulta o saldo da conta poupança.
     *
     * @return o saldo da conta poupança
     */
    @Override
    public double consultarSaldo() {
        return getSaldo();
    }

    /**
     * Atualiza o saldo da conta poupança com base na taxa de juros e na duração.
     */
    @Override
    public void atualizarSaldo() {
        // Calcular juros e adicionar ao saldo
        double juros = (getSaldo() * getTaxaJuros() * duracaoDias) / 365;
        setSaldo(getSaldo() + juros);
    }
}