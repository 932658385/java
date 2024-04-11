import java.util.List;

/**
 * Interface que define os métodos básicos para uma atividade desportiva em uma associação.
 */
public interface AtividadeDesportiva {
    /**
     * Obtém o nome da atividade desportiva.
     * @return O nome da atividade.
     */
    String getNome();

    /**
     * Obtém o local onde a atividade desportiva ocorre.
     * @return O local da atividade.
     */
    String getLocal();

    /**
     * Define o local onde a atividade desportiva ocorre.
     * @param local O local da atividade.
     */
    void setLocal(String local);

    /**
     * Obtém o associado responsável pela atividade.
     * @return O associado responsável.
     */
    Associado getResponsavel();

    /**
     * Define o associado responsável pela atividade.
     * @param responsavel O associado responsável.
     */
    void setResponsavel(Associado responsavel);

    /**
     * Obtém a lista de participantes da atividade.
     * @return A lista de participantes.
     */
    List<Associado> getParticipantes();

    /**
     * Define a lista de participantes da atividade.
     * @param participantes A lista de participantes.
     */
    void setParticipantes(List<Associado> participantes);

    /**
     * Obtém as atividades disponíveis para a atividade desportiva.
     * @return As atividades disponíveis.
     */
    List<String> getAtividadesDisponiveis();

    /**
     * Define as atividades disponíveis para a atividade desportiva.
     * @param atividadesDisponiveis As atividades disponíveis.
     */
    void setAtividadesDisponiveis(List<String> atividadesDisponiveis);

    /**
     * Obtém a lista de associados responsáveis pelas atividades da atividade desportiva.
     * @return A lista de associados responsáveis pelas atividades.
     */
    List<Associado> getResponsaveisAtividades();

    /**
     * Define a lista de associados responsáveis pelas atividades da atividade desportiva.
     * @param responsaveisAtividades A lista de associados responsáveis pelas atividades.
     */
    void setResponsaveisAtividades(List<Associado> responsaveisAtividades);

    /**
     * Obtém a lista de espaços associados à atividade desportiva.
     * @return A lista de espaços associados.
     */
    List<EspacoAssociacao> getEspacosAtividades();
}