/**
 * Uma exceção que indica uma tentativa inválida de depósito em uma conta bancária.
 */
public class InvalidDepositException extends Exception {
    /**
     * Cria uma nova exceção com a mensagem especificada.
     *
     * @param message a mensagem que descreve a exceção
     */
    public InvalidDepositException(String message) {
        super(message);
    }
}