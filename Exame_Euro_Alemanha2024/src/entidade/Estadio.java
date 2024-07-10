package entidade;

public class Estadio {
    private int id;
    private String nome;
    private int cidadeId;
    private int capacidade;

    public Estadio(int id, String nome, int cidadeId, int capacidade) {
        this.id = id;
        this.nome = nome;
        this.cidadeId = cidadeId;
        this.capacidade = capacidade; 
    }

    public int getId() {return id;}
    public String getNome() {return nome;}
    public int getCidadeId() {return cidadeId;}
    public int getCapacidade() {return capacidade;}

    @Override
    public String toString() {
        return "Estadio{" +
                "id=" + id +
                ", nome='" + nome + '\'' +
                ", cidadeId=" + cidadeId +
                ", capacidade=" + capacidade +
                '}';
    }
}