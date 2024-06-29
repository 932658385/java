public class Grupo {
    private int id;
    private String nome;
    private List<Pais> selecoes;

    public Grupo(int id, String nome, List<Pais> selecoes) {
        this.id = id;
        this.nome = nome;
        this.selecoes = selecoes;
    }
    
    public int getId() {return this.id;}
    public void setId(int id) {this.id = id;}

    public String getNome() {return this.nome;}
    public void setNome(String nome) {this.nome = nome;}

    public List<Pais> getSelecoes() {return this.selecoes;}
    public void setSelecoes(List<Pais> selecoes) {this.selecoes = selecoes;}
    
}