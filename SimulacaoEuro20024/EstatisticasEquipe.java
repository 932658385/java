public class EstatisticasEquipe {
    private int remates;
    private int livres;
    private int forasDeJogo;

    public EstatisticasEquipe(int remates, int livres, int forasDeJogo) {
        this.remates = remates;
        this.livres = livres;
        this.forasDeJogo = forasDeJogo;
    }
    
    public int getRemates() {return this.remates;}
    public void setRemates(int remates) {this.remates = remates;}

    public int getLivres() {return this.livres;}
    public void setLivres(int livres) {this.livres = livres;}

    public int getForasDeJogo() {return this.forasDeJogo;}
    public void setForasDeJogo(int forasDeJogo) {this.forasDeJogo = forasDeJogo;}
    
}