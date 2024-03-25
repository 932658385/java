/**
 * Classe que representa uma seleção nacional de futebol.
 */
public class Selecao extends Equipe {
    private String confederacao;

    /**
     * Construtor da classe Selecao.
     * 
     * @param confederacao A confederação à qual a seleção nacional pertence.
     */
    public Selecao(String confederacao) {
        this.confederacao = confederacao;
    }
    
    /**
     * Obtém a confederação à qual a seleção nacional pertence.
     * 
     * @return A confederação à qual a seleção nacional pertence.
     */
    public String getConfederacao() {
        return this.confederacao;
    }

    /**
     * Define a confederação à qual a seleção nacional pertence.
     * 
     * @param confederacao A confederação à qual a seleção nacional pertence a ser definida.
     */
    public void setConfederacao(String confederacao) {
        this.confederacao = confederacao;
    }
}