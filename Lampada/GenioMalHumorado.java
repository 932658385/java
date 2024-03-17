/**
 * A classe GenioMalHumorado representa um tipo especial de gênio que pode conceder apenas um desejo.
 * Depois que um desejo é concedido, o gênio se torna mal-humorado e não concede mais desejos.
 */
public class GenioMalHumorado extends Genio {

    // Variável para rastrear se o desejo foi concedido
    private boolean desejoConcedido;

    /**
     * Construtor padrão para criar um novo GenioMalHumorado.
     * Inicializa o estado do desejo como não concedido.
     */
    public GenioMalHumorado() {
        this.desejoConcedido = false;
    }

    /**
     * Método para conceder um desejo ao usuário.
     * Este gênio mal-humorado pode conceder apenas um desejo.
     * 
     * @param desejos O número de desejos a serem concedidos (neste caso, sempre 1).
     * @return true se o desejo foi concedido com sucesso, false caso contrário.
     */
    @Override
    public boolean grantWish(int desejos) {
        if (!this.desejoConcedido) {
            this.desejoConcedido = true;
            return true; // Desejo concedido com sucesso
        }
        return false; // Gênio já concedeu um desejo
    }

    /**
     * Método para obter o número de desejos concedidos por este gênio.
     * Como este gênio pode conceder apenas um desejo, retorna 1 se o desejo foi concedido e 0 caso contrário.
     * 
     * @return 1 se o desejo foi concedido, 0 caso contrário.
     */
    @Override
    public int getGrantedWishes() {
        return this.desejoConcedido ? 1 : 0;
    }

    /**
     * Retorna uma representação em formato de string do estado atual do gênio.
     * Se um desejo foi concedido, retorna uma mensagem indicando isso.
     * Caso contrário, informa que o gênio tem um desejo para conceder.
     * 
     * @return Representação em string do gênio.
     */
    @Override
    public String toString() {
        if (this.desejoConcedido) {
            return "Génio mal-humorado concedeu um desejo.";
        } else {
            return "Génio mal-humorado tem um desejo para conceder.";
        }
    }
}