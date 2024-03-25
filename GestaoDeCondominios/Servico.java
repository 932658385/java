/**
 * Interface que define um contrato para serviços.
 * Qualquer classe que implementa esta interface deve fornecer uma implementação
 * para o método executar(), que representa a execução do serviço específico.
 */
public interface Servico {

    /**
     * Método responsável por executar o serviço.
     * 
     * Este método deve ser implementado por qualquer classe que implemente esta interface.
     * Ele define o comportamento da execução do serviço específico.
     */
    void executar();
}
