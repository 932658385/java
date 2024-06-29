package entidade;

public class EstatisticasEquipe {
    private int id;
    private int jogoId;
    private int selecaoId;
    private int remates;
    private int livres;
    private int forasDeJogo;

    public EstatisticasEquipe(int id, int jogoId, int selecaoId, int remates, int livres, int forasDeJogo) {
        this.id = id;
        this.jogoId = jogoId;
        this.selecaoId = selecaoId;
        this.remates = remates;
        this.livres = livres;
        this.forasDeJogo = forasDeJogo;
    }

    public int getId() {return id;}
    public int getJogoId() {return jogoId;}
    public int getSelecaoId() {return selecaoId;}
    public int getRemates() {return remates;}
    public int getLivres() {return livres;}
    public int getForasDeJogo() {return forasDeJogo;}

    @Override
    public String toString() {
        return "EstatisticasEquipe{" +
                "id=" + id +
                ", jogoId=" + jogoId +
                ", selecaoId=" + selecaoId +
                ", remates=" + remates +
                ", livres=" + livres +
                ", forasDeJogo = " + forasDeJogo + 
                '}';
    }
}