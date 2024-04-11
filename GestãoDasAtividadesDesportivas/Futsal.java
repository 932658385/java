import java.util.List;

/**
 * Classe que representa uma atividade de Futsal.
 */
public class Futsal implements AtividadeDesportiva {
    private String nome;
    private String local;
    private Associado responsavel;
    private List<Associado> participantes;
    private List<EspacoAssociacao> espacoAssociacao; // Adicionado o atributo
    private List<String> atividadesDisponiveis;
    private List<EspacoAssociacao> espacosAtividades;
    private List<Associado> responsaveisAtividades;

    /**
     * Obtém o nome da atividade de Futsal.
     * @return O nome da atividade.
     */
    @Override
    public String getNome() {
        return nome;
    }
    
    /**
     * Define o nome da atividade de Futsal.
     * @param nome O nome da atividade.
     */
    public void setNome(String nome) {
        this.nome = nome;
    }

    /**
     * Obtém o local da atividade de Futsal.
     * @return O local da atividade.
     */
    @Override
    public String getLocal() {
        return local;
    }

    /**
     * Define o local da atividade de Futsal.
     * @param local O local da atividade.
     */
    @Override
    public void setLocal(String local) {
        this.local = local;
    }

    /**
     * Obtém o responsável pela atividade de Futsal.
     * @return O responsável pela atividade.
     */
    @Override
    public Associado getResponsavel() {
        return responsavel;
    }

    /**
     * Define o responsável pela atividade de Futsal.
     * @param responsavel O responsável pela atividade.
     */
    @Override
    public void setResponsavel(Associado responsavel) {
        this.responsavel = responsavel;
    }

    /**
     * Obtém a lista de participantes da atividade de Futsal.
     * @return A lista de participantes.
     */
    @Override
    public List<Associado> getParticipantes() {
        return participantes;
    }

    /**
     * Define a lista de participantes da atividade de Futsal.
     * @param participantes A lista de participantes.
     */
    @Override
    public void setParticipantes(List<Associado> participantes) {
        this.participantes = participantes;
    }

    /**
     * Obtém a lista de espaços associados à atividade de Futsal.
     * @return A lista de espaços associados.
     */
    public List<EspacoAssociacao> getEspacosAtividades() {
        return espacoAssociacao;
    }

    /**
     * Define a lista de espaços associados à atividade de Futsal.
     * @param espacosAtividades A lista de espaços associados.
     */
    public void setEspacosAtividades(List<EspacoAssociacao> espacosAtividades) {
        this.espacosAtividades = espacosAtividades;
    }

    /**
     * Define as atividades disponíveis para a atividade de Futsal.
     * @param atividadesDisponiveis As atividades disponíveis.
     */
    @Override
    public void setAtividadesDisponiveis(List<String> atividadesDisponiveis) {
        this.atividadesDisponiveis = atividadesDisponiveis;
    }

    /**
     * Obtém as atividades disponíveis para a atividade de Futsal.
     * @return As atividades disponíveis.
     */
    @Override
    public List<String> getAtividadesDisponiveis() {
        return atividadesDisponiveis;
    }

    /**
     * Obtém a lista de responsáveis pelas atividades de Futsal.
     * @return A lista de responsáveis pelas atividades.
     */
    @Override
    public List<Associado> getResponsaveisAtividades() {
        return responsaveisAtividades;
    }

    /**
     * Define a lista de responsáveis pelas atividades de Futsal.
     * @param responsaveisAtividades A lista de responsáveis pelas atividades.
     */
    @Override
    public void setResponsaveisAtividades(List<Associado> responsaveisAtividades) {
        this.responsaveisAtividades = responsaveisAtividades;
    }
}