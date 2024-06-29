public class Pais {
    private int id;
    private String nome;
    private String codigo;

    public Pais(int id, String nome, String codigo) {
        this.id = id;
        this.nome = nome;
        this.codigo = codigo;
    }

    public int getId() {return this.id;}
    public void setId(int id) {this.id = id;}

    public String getNome() {return this.nome;}
    public void setNome(String nome) {this.nome = nome;}

    public String getCodigo() {return this.codigo;}
    public void setCodigo(String codigo) {this.codigo = codigo;}
    
}