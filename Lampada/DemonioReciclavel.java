/**
 * Uma subclasse da classe Genio que representa um demônio reciclável.
 * Este demônio pode conceder desejos até ser reciclado.
 */

public class DemonioReciclavel extends Genio {
    private int desejosConcedidos;
    private boolean reciclado;

    public DemonioReciclavel() {
        this.desejosConcedidos = 0;
        this.reciclado = false;
    }

    /**
     * Concede um desejo se o demônio não tiver sido reciclado.
     * @param desejos O número de desejos a ser concedido.
     * @return true se o(s) desejo(s) puder(em) ser concedido(s), false caso contrário.
    */

    @Override
    public boolean grantWish(int desejos) {
        if (!this.reciclado) {
            this.desejosConcedidos++;
            return true;
        }
        return false;
    }

    /**
     * Obtém o número total de desejos concedidos pelo demônio.
     * @return O número total de desejos concedidos.
    */

    @Override
    public int getGrantedWishes() {
        return this.desejosConcedidos;
    }


    /**
     * Recicla o demônio, impedindo-o de conceder mais desejos.
     * @return true se o demônio for reciclado com sucesso, false se já estiver reciclado.
    */

    public boolean recycle() {
        if (!this.reciclado) {
            this.reciclado = true;
            return true;
        }
        return false;
    }

    /**
     * Retorna uma representação de string do objeto DemonioReciclavel.
     * Se o demônio não tiver sido reciclado, inclui o número de desejos concedidos.
     * Se o demônio tiver sido reciclado, indica que o demônio foi reciclado.
     * @return Uma representação de string do status do demônio.
    */

    @Override
    public String toString() {
        if (!this.reciclado) {
            return "Demónio reciclável concedeu " + this.desejosConcedidos + " desejos.";
        } else {
            return "Demónio foi reciclado.";
        }
    }

    /**
     * Verifica se o demônio foi reciclado.
     * @return true se o demônio foi reciclado, false caso contrário.
    */

    public boolean isRecycled() {
        return this.reciclado;
    }
}