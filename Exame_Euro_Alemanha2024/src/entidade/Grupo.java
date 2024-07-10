package entidade;

public class Grupo {
    private int id;
    private String nome;

    public Grupo(int id, String nome) { 
        this.id = id;
        this.nome = nome;
    }

    public int getId() {return id;}
    public String getNome() {return nome;}

    @Override
    public String toString() {
        return "Grupo{" +
                "id=" + id +
                ", nome='" + nome + '\'' +
                '}';
    }
}