/**
 * Uma exceção que indica uma tentativa inválida de levantamento de fundos de uma conta bancária.
 */
public class InvalidWithdrawalException extends Exception {
    /**
     * Cria uma nova exceção com a mensagem especificada.
     *
     * @param message a mensagem que descreve a exceção
     */
    public InvalidWithdrawalException(String message) {
        super(message);
    }
}