import java.util.List;

/**
 * Classe que representa o campeonato europeu de futebol.
 * 
 * Esta classe armazena informações relevantes sobre o campeonato, como o país organizador,
 * os estádios onde os jogos ocorrem, as cidades onde os estádios estão localizados,
 * as fases de qualificação e grupo do campeonato.
 */
public class EuroFutebol implements Atualizavel {
    private Pais paisOrganizador;
    private List<Estadio> estadios;
    private List<Cidade> cidades;
    private FaseQualificacao faseQualificacao;
    private FaseGrupo faseGrupo;

    /**
     * Construtor da classe EuroFutebol.
     * 
     * @param paisOrganizador O país organizador do campeonato.
     * @param estadios A lista de estádios onde ocorrem os jogos do campeonato.
     * @param cidades A lista de cidades onde os estádios estão localizados.
     * @param faseQualificacao A fase de qualificação do campeonato.
     * @param faseGrupo A fase de grupo do campeonato.
     */
    public EuroFutebol(Pais paisOrganizador, List<Estadio> estadios, List<Cidade> cidades, FaseQualificacao faseQualificacao, FaseGrupo faseGrupo) {
        this.paisOrganizador = paisOrganizador;
        this.estadios = estadios;
        this.cidades = cidades;
        this.faseQualificacao = faseQualificacao;
        this.faseGrupo = faseGrupo;
    }

    /**
     * Obtém o país organizador do campeonato.
     * 
     * @return O país organizador do campeonato.
     */
    public Pais getPaisOrganizador() {
        return this.paisOrganizador;
    }

    /**
     * Define o país organizador do campeonato.
     * 
     * @param paisOrganizador O país organizador do campeonato a ser definido.
     */
    public void setPaisOrganizador(Pais paisOrganizador) {
        this.paisOrganizador = paisOrganizador;
    }

    /**
     * Obtém a lista de estádios onde ocorrem os jogos do campeonato.
     * 
     * @return A lista de estádios onde ocorrem os jogos do campeonato.
     */
    public List<Estadio> getEstadios() {
        return this.estadios;
    }

    /**
     * Define a lista de estádios onde ocorrem os jogos do campeonato.
     * 
     * @param estadios A lista de estádios a ser definida.
     */
    public void setEstadios(List<Estadio> estadios) {
        this.estadios = estadios;
    }

    /**
     * Obtém a lista de cidades onde os estádios estão localizados.
     * 
     * @return A lista de cidades onde os estádios estão localizados.
     */
    public List<Cidade> getCidades() {
        return this.cidades;
    }

    /**
     * Define a lista de cidades onde os estádios estão localizados.
     * 
     * @param cidades A lista de cidades a ser definida.
     */
    public void setCidades(List<Cidade> cidades) {
        this.cidades = cidades;
    }

    /**
     * Obtém a fase de qualificação do campeonato.
     * 
     * @return A fase de qualificação do campeonato.
     */
    public FaseQualificacao getFaseQualificacao() {
        return this.faseQualificacao;
    }

    /**
     * Define a fase de qualificação do campeonato.
     * 
     * @param faseQualificacao A fase de qualificação a ser definida.
     */
    public void setFaseQualificacao(FaseQualificacao faseQualificacao) {
        this.faseQualificacao = faseQualificacao;
    }

    /**
     * Obtém a fase de grupo do campeonato.
     * 
     * @return A fase de grupo do campeonato.
     */
    public FaseGrupo getFaseGrupo() {
        return this.faseGrupo;
    }

    /**
     * Define a fase de grupo do campeonato.
     * 
     * @param faseGrupo A fase de grupo a ser definida.
     */
    public void setFaseGrupo(FaseGrupo faseGrupo) {
        this.faseGrupo = faseGrupo;
    }

    /**
     * Método para atualizar os resultados de um jogo.
     * 
     * Este método é responsável por atualizar as informações pertinentes 
     * após a conclusão de um jogo, como a tabela de classificação, 
     * estatísticas dos jogadores e equipes, etc.
     * 
     * @param jogo O objeto representando o jogo cujos resultados serão atualizados.
     */
    @Override
    public void atualizarResultados(Jogo jogo) {
        // Implementação para atualizar as informações após um jogo
    }
}