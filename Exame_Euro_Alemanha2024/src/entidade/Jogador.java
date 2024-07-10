package entidade;
 
public class Jogador {
    private int id;
    private String nome;
    private String posicao;
    private int selecaoId;
    private int gols;

    public Jogador(int id, String nome, String posicao, int selecaoId) {
        this.id = id;
        this.nome = nome;
        this.posicao = posicao;
        this.selecaoId = selecaoId;
    }

    // Getters e Setters
    public int getId() {return id;}
    public void setId(int id) {this.id = id;}
    public String getNome() {return nome;}
    public void setNome(String nome) {this.nome = nome;}
    public String getPosicao() {return posicao;}
    public void setPosicao(String posicao) {this.posicao = posicao;}
    public int getSelecaoId() {return selecaoId;}
    public void setSelecaoId(int selecaoId) {this.selecaoId = selecaoId;}
    public int getGols() {return gols;}
    public void setGols(int gols) {this.gols = gols;}

    @Override
    public String toString() {
        return "Jogador{" +
                "id=" + id +
                ", nome='" + nome + '\'' +
                ", posicao='" + posicao + '\'' +
                ", selecaoId=" + selecaoId +
                ", gols=" + gols +
                '}';
    }
}