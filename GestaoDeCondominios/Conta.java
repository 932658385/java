/**
 * Interface que define um contrato para emissão de balancete de contas.
 * Qualquer classe que implementa esta interface deve fornecer uma implementação
 * para o método emitirBalancete(), que representa a emissão de um balancete.
 */
public interface Conta {

    /**
     * Método responsável por emitir um balancete de contas.
     * 
     * Este método deve ser implementado por qualquer classe que implemente esta interface.
     * Ele define o comportamento da emissão de um balancete de contas específico.
     */
    void emitirBalancete();
}
