public class Cartao {
    public enum Tipo { AMARELO, VERMELHO }

    private Jogador jogador;
    private Tipo tipo;
    private int minuto;

    public Cartao(Jogador jogador, Tipo tipo, int minuto) {
        this.jogador = jogador;
        this.tipo = tipo;
        this.minuto = minuto;
    }

    public Jogador getJogador() {return jogador;}
    public void setJogador(Jogador jogador) {this.jogador = jogador;}

    public Tipo getTipo() {return tipo;}
    public void setTipTipo (Tipo tipo) {this.tipo = tipo;}

    public int getMinuto() {return minuto;}
    public void setMinuto(int minuto) {this.minuto = minuto;}
}