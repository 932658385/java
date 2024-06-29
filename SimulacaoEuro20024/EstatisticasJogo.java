public class EstatisticasJogo {
    private Jogo jogo;
    private Map<Jogador, EstatisticasIndividuais> estatisticasIndividuais;
    private Map<Pais, EstatisticasEquipe> estatisticasEquipe;


    public EstatisticasJogo(Jogo jogo, Map<Jogador,EstatisticasIndividuais> estatisticasIndividuais, Map<Pais,EstatisticasEquipe> estatisticasEquipe) {
        this.jogo = jogo;
        this.estatisticasIndividuais = estatisticasIndividuais;
        this.estatisticasEquipe = estatisticasEquipe;
    }
    
    public Jogo getJogo() {return this.jogo;}
    public void setJogo(Jogo jogo) {this.jogo = jogo;}

    public Map<Jogador,EstatisticasIndividuais> getEstatisticasIndividuais() {
        return this.estatisticasIndividuais;
    }

    public void setEstatisticasIndividuais(Map<Jogador,EstatisticasIndividuais> estatisticasIndividuais) {
        this.estatisticasIndividuais = estatisticasIndividuais;
    }

    public Map<Pais,EstatisticasEquipe> getEstatisticasEquipe() {
        return this.estatisticasEquipe;
    }

    public void setEstatisticasEquipe(Map<Pais,EstatisticasEquipe> estatisticasEquipe) {
        this.estatisticasEquipe = estatisticasEquipe;
    }
    
}