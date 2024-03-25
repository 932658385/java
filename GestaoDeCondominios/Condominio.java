import java.util.List;
import java.util.ArrayList;

/**
 * Classe que representa um condomínio.
 */
public class Condominio {
    private String nome; // Nome do condomínio
    private List<Edificio> edificios; // Lista de edifícios do condomínio

    /**
     * Construtor da classe Condominio.
     * 
     * @param nome O nome do condomínio.
     */
    public Condominio(String nome) {
        this.nome = nome;
        this.edificios = new ArrayList<>();
    }

    /**
     * Obtém o nome do condomínio.
     * 
     * @return O nome do condomínio.
     */
    public String getNome() {
        return this.nome;
    }

    /**
     * Define o nome do condomínio.
     * 
     * @param nome O nome do condomínio.
     */
    public void setNome(String nome) {
        this.nome = nome;
    }

    /**
     * Obtém a lista de edifícios do condomínio.
     * 
     * @return A lista de edifícios do condomínio.
     */
    public List<Edificio> getEdificios() {
        return this.edificios;
    }

    /**
     * Define a lista de edifícios do condomínio.
     * 
     * @param edificios A lista de edifícios do condomínio.
     */
    public void setEdificios(List<Edificio> edificios) {
        this.edificios = edificios;
    }

    /**
     * Adiciona um edifício à lista de edifícios do condomínio.
     * 
     * @param edificio O edifício a ser adicionado.
     */
    public void adicionarEdificio(Edificio edificio) {
        edificios.add(edificio);
    }
}
