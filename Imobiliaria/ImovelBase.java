/**
 * Classe abstrata que serve como base para representar um imóvel.
 */
public abstract class ImovelBase implements Imovel {
    private int anoConstrucao;
    private double area;
    private String localizacao;
    private double preco;

    /**
     * Construtor para a classe ImovelBase.
     * 
     * @param anoConstrucao O ano de construção do imóvel.
     * @param area A área do imóvel.
     * @param localizacao A localização do imóvel.
     * @param preco O preço do imóvel.
     */
    public ImovelBase(int anoConstrucao, double area, String localizacao, double preco) {
        this.anoConstrucao = anoConstrucao;
        this.area = area;
        this.localizacao = localizacao;
        this.preco = preco;
    }

    /**
     * Obtém o ano de construção do imóvel.
     * 
     * @return O ano de construção do imóvel.
     */
    public int getAnoConstrucao() {
        return anoConstrucao;
    }

    /**
     * Define o ano de construção do imóvel.
     * 
     * @param anoConstrucao O ano de construção do imóvel.
     */
    public void setAnoConstrucao(int anoConstrucao) {
        this.anoConstrucao = anoConstrucao;
    }

    /**
     * Obtém a área do imóvel.
     * 
     * @return A área do imóvel.
     */
    public double getArea() {
        return area;
    }

    /**
     * Define a área do imóvel.
     * 
     * @param area A área do imóvel.
     */
    public void setArea(double area) {
        this.area = area;
    }

    /**
     * Obtém a localização do imóvel.
     * 
     * @return A localização do imóvel.
     */
    public String getLocalizacao() {
        return localizacao;
    }

    /**
     * Define a localização do imóvel.
     * 
     * @param localizacao A localização do imóvel.
     */
    public void setLocalizacao(String localizacao) {
        this.localizacao = localizacao;
    }

    /**
     * Obtém o preço do imóvel.
     * 
     * @return O preço do imóvel.
     */
    public double getPreco() {
        return preco;
    }

    /**
     * Define o preço do imóvel.
     * 
     * @param preco O preço do imóvel.
     */
    public void setPreco(double preco) {
        this.preco = preco;
    }
}