package entidade;

public class EstatisticasJogador {
    private int id;
    private int jogoId;
    private int jogadorId;
    private int passes; 
    private int assistencias;
    private int remates;
    private int minutosJogados;

    public EstatisticasJogador(int id, int jogoId, int jogadorId, int passes, int assistencias, int remates, int minutosJogados) {
        this.id = id;
        this.jogoId = jogoId;
        this.jogadorId = jogadorId;
        this.passes = passes;
        this.assistencias = assistencias;
        this.remates = remates;
        this.minutosJogados = minutosJogados;
    }

    public int getId() { return id; }
    public int getJogoId() { return jogoId; }
    public int getJogadorId() { return jogadorId; }
    public int getPasses() { return passes; }
    public int getAssistencias() { return assistencias; }
    public int getRemates() { return remates; }
    public int getMinutosJogados() { return minutosJogados; }

    @Override
    public String toString() {
        return "EstatisticasJogador{" +
                "id=" + id +
                ", jogoId=" + jogoId +
                ", jogadorId=" + jogadorId +
                ", passes=" + passes +
                ", assistencias=" + assistencias +
                ", remates=" + remates +
                ", minutosJogados=" + minutosJogados +
                '}';
    }
}