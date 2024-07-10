package entidade;

public class Pais {
    private int id;
    private String nome;

    public Pais(int id, String nome) {
        this.id = id;
        this.nome = nome;
    } 

    public int getId() {return id;}
    public String getNome() {return nome;}

    @Override
    public String toString() {
        return "Pais{" +
                "id=" + id +
                ", nome='" + nome + '\'' +
                '}';
    }
}