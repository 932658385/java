package entidade;

public class Substituicao {
    private int id;
    private int jogoId;
    private int jogadorSaiuId;
    private int jogadorEntrouId;
    private int minuto;

    public Substituicao(int id, int jogoId, int jogadorSaiuId, int jogadorEntrouId, int minuto) {
        this.id = id;
        this.jogoId = jogoId;
        this.jogadorSaiuId = jogadorSaiuId;
        this.jogadorEntrouId = jogadorEntrouId;
        this.minuto = minuto;
    }
 
    public int getId() {return id;}
    public int getJogoId() {return jogoId;}
    public int getJogadorSaiuId() {return jogadorSaiuId;}
    public int getJogadorEntrouId() {return jogadorEntrouId;}
    public int getMinuto() {return minuto;}

    @Override
    public String toString() {
        return "Substituicao{" +
                "id=" + id +
                ", jogoId=" + jogoId +
                ", jogadorSaiuId=" + jogadorSaiuId +
                ", jogadorEntrouId=" + jogadorEntrouId +
                ", minuto=" + minuto +
                '}';
    }
}