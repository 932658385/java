package entidade;

public class Cidade {
    private int id;
    private String nome;
    private int paisId;

    public Cidade(int id, String nome, int paisId) {
        this.id = id;
        this.nome = nome;
        this.paisId = paisId;
    }

    public int getId() {return id;}
    public String getNome() {return nome;}
    public int getPaisId() {return paisId;}
    public void setId(int id) {this.id = id;}
    public void setNome(String nome) {this.nome = nome;}
    public void setPaisId(int paisId) {this.paisId = paisId;}


    @Override
    public String toString() {
        return "Cidade{" +
                "id=" + id +
                ", nome='" + nome + '\'' +
                ", paisId=" + paisId + 
                '}';
    }
}  