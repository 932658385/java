import java.util.Date;
import java.util.List;

public class Campeonato {
    private String nomeAtividade;
    private Date dataInicio;
    private Date dataFim;
    private List<Equipe> equipesParticipantes;
    private List<Partida> partidas; // Adicionando o atributo partidas

    // Getters e Setters
    public String getNomeAtividade() {
        return nomeAtividade;
    }

    public void setNomeAtividade(String nomeAtividade) {
        this.nomeAtividade = nomeAtividade;
    }

    public Date getDataInicio() {
        return dataInicio;
    }

    public void setDataInicio(Date dataInicio) {
        this.dataInicio = dataInicio;
    }

    public Date getDataFim() {
        return dataFim;
    }

    public void setDataFim(Date dataFim) {
        this.dataFim = dataFim;
    }

    public List<Equipe> getEquipesParticipantes() {
        return equipesParticipantes;
    }

    public void setEquipesParticipantes(List<Equipe> equipesParticipantes) {
        this.equipesParticipantes = equipesParticipantes;
    }

    public List<Partida> getPartidas() {
        return partidas;
    }

    public void setPartidas(List<Partida> partidas) {
        this.partidas = partidas;
    }
}