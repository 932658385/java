/**
 * Classe para representar um terreno.
 */
public class Terreno implements Imovel {
    private boolean zonaUrbana;
    private double area;

    /**
     * Construtor para a classe Terreno.
     * 
     * @param zonaUrbana Indica se o terreno está em zona urbana (true) ou rural (false).
     * @param area A área do terreno.
     */
    public Terreno(boolean zonaUrbana, double area) {
        this.zonaUrbana = zonaUrbana;
        this.area = area;
    }

    /**
     * Verifica se o terreno está em zona urbana.
     * 
     * @return true se o terreno estiver em zona urbana, false caso contrário.
     */
    public boolean isZonaUrbana() {
        return zonaUrbana;
    }

    /**
     * Define se o terreno está em zona urbana.
     * 
     * @param zonaUrbana true se o terreno está em zona urbana, false caso contrário.
     */
    public void setZonaUrbana(boolean zonaUrbana) {
        this.zonaUrbana = zonaUrbana;
    }

    /**
     * Obtém a área do terreno.
     * 
     * @return A área do terreno.
     */
    public double getArea() {
        return area;
    }

    /**
     * Define a área do terreno.
     * 
     * @param area A área do terreno.
     */
    public void setArea(double area) {
        this.area = area;
    }

    /**
     * Obtém o tipo do imóvel (no caso, "Terreno").
     * 
     * @return O tipo do imóvel.
     */
    @Override
    public String getTipo() {
        return "Terreno";
    }
}