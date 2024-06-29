public class Jogador {
    private int id;
    private String nome;
    private int idade;
    private Pais pais;
    private String posicao;


    public Jogador(int id, String nome, int idade, Pais pais, String posicao) {
        this.id = id;
        this.nome = nome;
        this.idade = idade;
        this.pais = pais;
        this.posicao = posicao;
    }

    public int getId() {return this.id;}
    public void setId(int id) {this.id = id;}

    public String getNome() {return this.nome;}
    public void setNome(String nome) {this.nome = nome;}

    public int getIdade() {return this.idade;}
    public void setIdade(int idade) {this.idade = idade;}

    public Pais getPais() {return this.pais;}
    public void setPais(Pais pais) {this.pais = pais;}

    public String getPosicao() {return this.posicao;}
    public void setPosicao(String posicao) {this.posicao = posicao;}
}