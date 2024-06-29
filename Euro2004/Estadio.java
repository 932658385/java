public class Estadio {
    private String nome;
    private String cidade;
    private int capacidade;

    public Estadio(String nome, String cidade, int capacidade) {
        this.nome = nome;
        this.cidade = cidade;
        this.capacidade = capacidade;
    }

    public String getNome() {return nome;}
    public void setNome(String nome) {this.nome = nome;}

    public String getCidade() {return cidade;}
    public void setCidade(String cidade) {this.cidade = cidade;}

    public int getCapacidade() {return capacidade;}
    public void setCapacidade(int capacidade) {this.capacidade = capacidade;}
}