public class Jogo {
    private int id;
    private Grupo grupo;
    private Pais timeCasa;
    private Pais timeVisitante;
    private String data;
    private String estadio;
    private int golsCasa;
    private int golsVisitante;

    public Jogo(int id, Grupo grupo, Pais timeCasa, Pais timeVisitante, String data, String estadio, int golsCasa, int golsVisitante) {
        this.id = id;
        this.grupo = grupo;
        this.timeCasa = timeCasa;
        this.timeVisitante = timeVisitante;
        this.data = data;
        this.estadio = estadio;
        this.golsCasa = golsCasa;
        this.golsVisitante = golsVisitante;
    }

    public int getId() { return id; }
    public Grupo getGrupo() { return grupo; }
    public Pais getTimeCasa() { return timeCasa; }
    public Pais getTimeVisitante() { return timeVisitante; }
    public String getData() { return data; }
    public String getEstadio() { return estadio; }
    public int getGolsCasa() { return golsCasa; }
    public void setGolsCasa(int golsCasa) { this.golsCasa = golsCasa; }
    public int getGolsVisitante() { return golsVisitante; }
    public void setGolsVisitante(int golsVisitante) { this.golsVisitante = golsVisitante; }
}