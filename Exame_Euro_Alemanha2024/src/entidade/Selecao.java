package entidade;

public class Selecao {
    private int id;
    private String nome;
    private int paisId;
    private int pontos;
    private int saldoGols;
    private int grupoId;

    public Selecao() {}

    public Selecao(int id, String nome, int paisId, int grupoId) {
        this.id = id;
        this.nome = nome;
        this.paisId = paisId;
        this.grupoId = grupoId;
    }

    public Selecao(int id, String nome, int paisId, int pontos, int saldoGols, int grupoId) {
        this.id = id;
        this.nome = nome;
        this.paisId = paisId;
        this.pontos = pontos;
        this.saldoGols = saldoGols;
        this.grupoId = grupoId;
    }

    public int getId() { return id; }
    public String getNome() { return nome; }
    public int getPaisId() { return paisId; }
    public int getGrupoId() { return grupoId; }
    public int getPontos() { return pontos; }
    public int getSaldoGols() { return saldoGols; }

    public void setId(int id) { this.id = id; }
    public void setNome(String nome) { this.nome = nome; }
    public void setPaisId(int paisId) { this.paisId = paisId; }
    public void setGrupoId(int grupoId) { this.grupoId = grupoId; }
    public void setPontos(int pontos) { this.pontos = pontos; }
    public void setSaldoGols(int saldoGols) { this.saldoGols = saldoGols; }

    public void adicionarResultado(int golsFeitos, int golsSofridos) {
        if (golsFeitos > golsSofridos) {
            this.pontos += 3; // Vitória
        } else if (golsFeitos == golsSofridos) {
            this.pontos += 1; // Empate
        }
        this.saldoGols += (golsFeitos - golsSofridos);
    }

    @Override
    public String toString() {
        return "Selecao{" +
                "id=" + id +
                ", nome='" + nome + '\'' +
                ", paisId=" + paisId +
                ", pontos=" + pontos +
                ", saldoGols=" + saldoGols +
                ", grupoId=" + grupoId +
                '}';
    }
}