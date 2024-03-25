/**
 * Interface que define as operações básicas de uma carteira.
 */
interface Carteira {
    /**
     * Adiciona uma transação à carteira.
     * 
     * @param transacao A transação a ser adicionada.
     */
    void adicionarTransacao(Transacao transacao);
    
    /**
     * Remove uma transação da carteira.
     * 
     * @param transacao A transação a ser removida.
     */
    void removerTransacao(Transacao transacao);
}
