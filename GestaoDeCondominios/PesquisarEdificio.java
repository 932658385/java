/**
 * Classe que representa uma operação de pesquisa de informações relativas a um edifício.
 * Implementa a interface Pesquisa para garantir a realização da pesquisa.
 */
public class PesquisarEdificio implements Pesquisa {
    private Edificio edificio;

    /**
     * Construtor da classe PesquisaEdificio.
     * 
     * @param edificio O edifício para o qual a pesquisa será realizada.
     */
    public PesquisarEdificio(Edificio edificio) {
        this.edificio = edificio;
    }

    /**
     * Método responsável por realizar a pesquisa de informações relativas ao edifício.
     * 
     * Aqui você deve adicionar a implementação específica para realizar a pesquisa de informações sobre o edifício,
     * como balancetes, relatórios de contas, orçamento, etc.
     */
    @Override
    public void realizarPesquisa() {
        // Implementação para realizar pesquisa de informações relativas ao edifício
    }
}
