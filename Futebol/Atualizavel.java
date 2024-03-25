// Interface para as operações de atualização de informações
interface Atualizavel {
    /**
     * Método para atualizar os resultados de um jogo.
     * 
     * Este método é responsável por atualizar as informações pertinentes 
     * após a conclusão de um jogo, como a tabela de classificação, 
     * estatísticas dos jogadores e equipes, etc.
     * 
     * @param jogo O objeto representando o jogo cujos resultados serão atualizados.
     */
    void atualizarResultados(Jogo jogo);
}
