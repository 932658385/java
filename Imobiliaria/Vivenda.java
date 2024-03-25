/**
 * Classe para representar uma vivenda.
 */
public class Vivenda extends ImovelBase {
    private String tipologia;

    /**
     * Construtor para a classe Vivenda.
     * 
     * @param anoConstrucao O ano de construção da vivenda.
     * @param area A área da vivenda.
     * @param localizacao A localização da vivenda.
     * @param preco O preço da vivenda.
     * @param tipologia A tipologia da vivenda (T1, T2, etc.).
     */
    public Vivenda(int anoConstrucao, double area, String localizacao, double preco, String tipologia) {
        super(anoConstrucao, area, localizacao, preco);
        this.tipologia = tipologia;
    }

    /**
     * Obtém a tipologia da vivenda.
     * 
     * @return A tipologia da vivenda.
     */
    public String getTipologia() {
        return tipologia;
    }

    /**
     * Define a tipologia da vivenda.
     * 
     * @param tipologia A tipologia da vivenda.
     */
    public void setTipologia(String tipologia) {
        this.tipologia = tipologia;
    }

    /**
     * Obtém o tipo do imóvel (no caso, "Vivenda").
     * 
     * @return O tipo do imóvel.
     */
    @Override
    public String getTipo() {
        return "Vivenda";
    }
}
