public class Substituicao {
    private Jogador jogadorSai;
    private Jogador jogadorEntra;
    private int minuto;

    public Substituicao(Jogador jogadorSai, Jogador jogadorEntra, int minuto) {
        this.jogadorSai = jogadorSai;
        this.jogadorEntra = jogadorEntra;
        this.minuto = minuto;
    }

    public Jogador getJogadorSai() {return jogadorSai;}
    public void setJogadorSai(Jogador jogadorSai) {this.jogadorSai = jogadorSai;}

    public Jogador getJogadorEntra() {return jogadorEntra;}
    public void setJogadorEntra(Jogador jogadorEntra) {this.jogadorEntra = jogadorEntra;}

    public int getMinuto() {return minuto;}
    public void setMinuto(int minuto) {this.minuto = minuto;}
}