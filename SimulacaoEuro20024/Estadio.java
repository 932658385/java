public class Estadio {
    private int id;
    private String nome;
    private String cidade;
    private int capacidade;

    public Estadio(int id, String nome, String cidade, int capacidade) {
        this.id = id;
        this.nome = nome;
        this.cidade = cidade;
        this.capacidade = capacidade;
    }
    
    public int getId() {return this.id;}
    public void setId(int id) {this.id = id;}

    public String getNome() {return this.nome;}
    public void setNome(String nome) {this.nome = nome;}

    public String getCidade() {return this.cidade;}
    public void setCidade(String cidade) {this.cidade = cidade;}

    public int getCapacidade() {return this.capacidade;}
    public void setCapacidade(int capacidade) {this.capacidade = capacidade;}

}