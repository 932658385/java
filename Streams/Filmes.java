import java.util.stream.Collectors;
import java.util.Comparator;
import java.util.List;
import java.util.Map;

/**
 * Representa uma coleção de filmes e fornece métodos para operar sobre eles usando streams.
 */
public class Filmes {
    private List<Filme> filmes;

    /**
     * Construtor da classe Filmes.
     *
     * @param filmes A lista de filmes.
     */
    public Filmes(List<Filme> filmes) {
        this.filmes = filmes;
    }

    /**
     * Conta o total de filmes na lista.
     *
     * @return O número total de filmes.
     */
    public long contarTotalFilmes() {
        return filmes.stream().count();
    }

    /**
     * Conta o número de filmes dirigidos por um diretor específico.
     *
     * @param nomeDiretor O nome do diretor.
     * @return O número de filmes dirigidos pelo diretor.
     */
    public long contarFilmesPorDiretor(String nomeDiretor) {
        return filmes.stream()
                     .filter(filme -> filme.getDiretor().equals(nomeDiretor))
                     .count();
    }

    /**
     * Obtém uma lista de filmes com duração menor que um valor específico.
     *
     * @param duracao A duração máxima desejada para os filmes.
     * @return Uma lista de filmes com duração menor que o valor especificado.
     */
    public List<Filme> obterFilmesComDuracaoMenorQue(int duracao) {
        return filmes.stream()
                     .filter(filme -> filme.getDuracaoMinutos() < duracao)
                     .collect(Collectors.toList());
    }

    /**
     * Mapeia os diretores para a lista de filmes que dirigiram.
     *
     * @return Um mapa contendo diretores como chaves e listas de filmes como valores.
     */
    public Map<String, List<Filme>> mapearDiretorParaFilmes() {
        return filmes.stream()
                     .collect(Collectors.groupingBy(Filme::getDiretor));
    }

    /**
     * Encontra o filme com a duração mais longa.
     *
     * @return O filme com a duração mais longa.
     */
    public Filme encontrarFilmeMaisLongo() {
        return filmes.stream()
                     .max(Comparator.comparingInt(Filme::getDuracaoMinutos))
                     .orElse(null);
    }

    /**
     * Encontra o filme com a duração mais curta.
     *
     * @return O filme com a duração mais curta.
     */
    public Filme encontrarFilmeMaisCurto() {
        return filmes.stream()
                     .min(Comparator.comparingInt(Filme::getDuracaoMinutos))
                     .orElse(null);
    }

    /**
     * Ordena os filmes por ano de lançamento.
     *
     * @return Uma lista de filmes ordenada por ano de lançamento.
     */
    public List<Filme> ordenarFilmesPorAno() {
        return filmes.stream()
                     .sorted(Comparator.comparingInt(Filme::getAno))
                     .collect(Collectors.toList());
    }
}