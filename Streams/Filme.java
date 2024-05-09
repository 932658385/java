/**
 * Representa um filme com título, diretor, duração em minutos e ano de lançamento.
 */
public class Filme {
    private String titulo;
    private String diretor;
    private int duracaoMinutos;
    private int ano;

    /**
     * Construtor da classe Filme.
     *
     * @param titulo          O título do filme.
     * @param diretor         O diretor do filme.
     * @param duracaoMinutos  A duração do filme em minutos.
     * @param ano             O ano de lançamento do filme.
     */
    public Filme(String titulo, String diretor, int duracaoMinutos, int ano) {
        this.titulo = titulo;
        this.diretor = diretor;
        this.duracaoMinutos = duracaoMinutos;
        this.ano = ano;
    }

    /**
     * Obtém o título do filme.
     *
     * @return O título do filme.
     */
    public String getTitulo() {
        return titulo;
    }

    /**
     * Obtém o diretor do filme.
     *
     * @return O diretor do filme.
     */
    public String getDiretor() {
        return diretor;
    }

    /**
     * Obtém a duração do filme em minutos.
     *
     * @return A duração do filme em minutos.
     */
    public int getDuracaoMinutos() {
        return duracaoMinutos;
    }

    /**
     * Obtém o ano de lançamento do filme.
     *
     * @return O ano de lançamento do filme.
     */
    public int getAno() {
        return ano;
    }
}