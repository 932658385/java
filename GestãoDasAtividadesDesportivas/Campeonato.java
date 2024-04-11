import java.util.Date;
import java.util.List;

/**
 * Classe que representa um campeonato desportivo.
 */
public class Campeonato {
    private String nomeAtividade;
    private Date dataInicio;
    private Date dataFim;
    private List<Equipe> equipesParticipantes;
    private List<Partida> partidas; // Adicionando o atributo partidas

    /**
     * Obtém o nome do campeonato.
     * @return O nome do campeonato.
     */
    public String getNomeAtividade() {
        return nomeAtividade;
    }

    /**
     * Define o nome do campeonato.
     * @param nomeAtividade O nome do campeonato.
     */
    public void setNomeAtividade(String nomeAtividade) {
        this.nomeAtividade = nomeAtividade;
    }

    /**
     * Obtém a data de início do campeonato.
     * @return A data de início do campeonato.
     */
    public Date getDataInicio() {
        return dataInicio;
    }

    /**
     * Define a data de início do campeonato.
     * @param dataInicio A data de início do campeonato.
     */
    public void setDataInicio(Date dataInicio) {
        this.dataInicio = dataInicio;
    }

    /**
     * Obtém a data de fim do campeonato.
     * @return A data de fim do campeonato.
     */
    public Date getDataFim() {
        return dataFim;
    }

    /**
     * Define a data de fim do campeonato.
     * @param dataFim A data de fim do campeonato.
     */
    public void setDataFim(Date dataFim) {
        this.dataFim = dataFim;
    }

    /**
     * Obtém a lista de equipes participantes no campeonato.
     * @return A lista de equipes participantes.
     */
    public List<Equipe> getEquipesParticipantes() {
        return equipesParticipantes;
    }

    /**
     * Define a lista de equipes participantes no campeonato.
     * @param equipesParticipantes A lista de equipes participantes.
     */
    public void setEquipesParticipantes(List<Equipe> equipesParticipantes) {
        this.equipesParticipantes = equipesParticipantes;
    }

    /**
     * Obtém a lista de partidas do campeonato.
     * @return A lista de partidas.
     */
    public List<Partida> getPartidas() {
        return partidas;
    }

    /**
     * Define a lista de partidas do campeonato.
     * @param partidas A lista de partidas.
     */
    public void setPartidas(List<Partida> partidas) {
        this.partidas = partidas;
    }
}