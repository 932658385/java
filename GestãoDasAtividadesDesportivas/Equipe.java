import java.util.List;

public class Equipe {
    private String nome;
    private String mascote;
    private List<Associado> membros;
    private int tamanho; // Adicionando o atributo tamanho

    // Getters e Setters
    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getMascote() {
        return mascote;
    }

    public void setMascote(String mascote) {
        this.mascote = mascote;
    }

    public List<Associado> getMembros() {
        return membros;
    }

    public void setMembros(List<Associado> membros) {
        this.membros = membros;
    }

    public int getTamanho() {
        return tamanho;
    }

    public void setTamanho(int tamanho) {
        this.tamanho = tamanho;
    }
}