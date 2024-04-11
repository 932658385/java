import java.util.List;

/**
 * Classe que representa uma equipe em um torneio desportivo.
 */
public class Equipe {
    private String nome;
    private String mascote;
    private List<Associado> membros;
    private int tamanho; // Adicionando o atributo tamanho

    /**
     * Obtém o nome da equipe.
     * @return O nome da equipe.
     */
    public String getNome() {
        return nome;
    }

    /**
     * Define o nome da equipe.
     * @param nome O nome da equipe.
     */
    public void setNome(String nome) {
        this.nome = nome;
    }

    /**
     * Obtém o mascote da equipe.
     * @return O mascote da equipe.
     */
    public String getMascote() {
        return mascote;
    }

    /**
     * Define o mascote da equipe.
     * @param mascote O mascote da equipe.
     */
    public void setMascote(String mascote) {
        this.mascote = mascote;
    }

    /**
     * Obtém a lista de membros da equipe.
     * @return A lista de membros da equipe.
     */
    public List<Associado> getMembros() {
        return membros;
    }

    /**
     * Define a lista de membros da equipe.
     * @param membros A lista de membros da equipe.
     */
    public void setMembros(List<Associado> membros) {
        this.membros = membros;
    }

    /**
     * Obtém o tamanho da equipe.
     * @return O tamanho da equipe.
     */
    public int getTamanho() {
        return tamanho;
    }

    /**
     * Define o tamanho da equipe.
     * @param tamanho O tamanho da equipe.
     */
    public void setTamanho(int tamanho) {
        this.tamanho = tamanho;
    }
}