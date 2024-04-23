/**
 * A classe ContaOrdem representa uma conta corrente em um banco.
 * ContaOrdem é uma subclasse de ContaDeposito e herda os atributos e métodos dessa classe.
 * Esta classe define métodos específicos para operações em contas correntes, como depósito e levantamento.
 */
public class ContaOrdem extends ContaDeposito {

    /**
     * Constrói uma nova instância de ContaOrdem com os parâmetros fornecidos.
     * 
     * @param numeroConta O número da conta
     * @param saldo O saldo inicial da conta
     * @param dataInicio A data de início da conta
     */
    public ContaOrdem(int numeroConta, double saldo, String dataInicio) {
        super(numeroConta, saldo, 0, dataInicio);
    }

    /**
     * Deposita uma quantia na conta corrente.
     * 
     * @param quantia A quantia a ser depositada
     * @throws InvalidDepositException se o depósito for inválido
     */
    @Override
    public void depositar(double quantia) throws InvalidDepositException {
        if (quantia < 0) {
            throw new InvalidDepositException("Não é possível depositar uma quantia negativa.");
        }
        setSaldo(getSaldo() + quantia);
    }

    /**
     * Levanta uma quantia da conta corrente.
     * 
     * @param quantia A quantia a ser levantada
     * @throws InvalidWithdrawalException se o levantamento for inválido
     */
    @Override
    public void levantar(double quantia) throws InvalidWithdrawalException {
        if (quantia < 0 || quantia > getSaldo()) {
            throw new InvalidWithdrawalException("Não é possível levantar uma quantia negativa ou superior ao saldo.");
        }
        setSaldo(getSaldo() - quantia);
    }

    /**
     * Consulta o saldo atual da conta corrente.
     * 
     * @return O saldo atual da conta corrente
     */
    @Override
    public double consultarSaldo() {
        return getSaldo();
    }

    /**
     * Atualiza o saldo da conta corrente.
     * 
     * Este método não faz nada na classe ContaOrdem, pois não há taxa de juros associada a contas correntes.
     */
    @Override
    public void atualizarSaldo() {
        // Não há implementação para atualizar o saldo em uma conta corrente
        // Pois não há taxa de juros associada
    }
}