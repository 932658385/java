/**
 * Interface que define um contrato para a geração de relatórios.
 * Qualquer classe que implementa esta interface deve fornecer uma implementação
 * para o método gerar(), que representa a geração de um relatório.
 */
public interface Relatorio {

    /**
     * Método responsável por gerar um relatório.
     * 
     * Este método deve ser implementado por qualquer classe que implemente esta interface.
     * Ele define o comportamento da geração de um relatório específico.
     */
    void gerar();
}