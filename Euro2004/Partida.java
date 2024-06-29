import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

public class Partida {
    private int id;
    private Equipe equipeCasa;
    private Equipe equipeFora;
    private int golsCasa;
    private int golsFora;
    private LocalDateTime data;
    private List<Substituicao> substituicoes;
    private List<Cartao> cartoes;
    private Map<Equipe, EstatisticasEquipe> estatisticasEquipe;
    private Map<Jogador, EstatisticasIndividuais> estatisticasIndividuais;

    public Partida(int id, Equipe equipeCasa, Equipe equipeFora, int golsCasa, int golsFora, LocalDateTime data,
                   List<Substituicao> substituicoes, List<Cartao> cartoes, Map<Equipe, EstatisticasEquipe> estatisticasEquipe,
                   Map<Jogador, EstatisticasIndividuais> estatisticasIndividuais) {
        this.id = id;
        this.equipeCasa = equipeCasa;
        this.equipeFora = equipeFora;
        this.golsCasa = golsCasa;
        this.golsFora = golsFora;
        this.data = data;
        this.substituicoes = substituicoes;
        this.cartoes = cartoes;
        this.estatisticasEquipe = estatisticasEquipe;
        this.estatisticasIndividuais = estatisticasIndividuais;
    }

    public int getId() {return id;}
    public void setId(int id) {this.id = id;}

    public Equipe getEquipeCasa() {return equipeCasa;}
    public void setEquipeCasa(Equipe equipeCasa) {this.equipeCasa = equipeCasa;}

    public Equipe getEquipeFora() {return equipeFora;}
    public void setEquipeFora(Equipe equipeFora) {this.equipeFora = equipeFora;}

    public int getGolsCasa() {return golsCasa;}
    public void setGolsCasa(int golsCasa) {this.golsCasa = golsCasa;}

    public int getGolsFora() {return golsFora;}
    public void setGolsFora(int golsFora) {this.golsFora = golsFora;}

    public LocalDateTime getData() {return data;}
    public void setData(LocalDateTime data) {this.data = data;}
    
    public List<Substituicao> getSubstituicoes() {return substituicoes
    public void setSubstituicoes(List<Substituicao> substituicoes) {this.substituicoes = substituicoes;}

    public List<Cartao> getCartoes() {return cartoes;}
    public void setCartoes(List<Cartao> cartoes) {this.cartoes = cartoes;}

    public Map<Equipe, EstatisticasEquipe> getEstatisticasEquipe() {return estatisticasEquipe;}
    public void setEstatisticasEquipe(Map<Equipe, EstatisticasEquipe> estatisticasEquipe) {this.estatisticasEquipe = estatisticasEquipe;}
    public Map<Jogador, EstatisticasIndividuais> getEstatisticasIndividuais() {return estatisticasIndividuais;}
    public void setEstatisticasIndividuais(Map<Jogador, EstatisticasIndividuais> estatisticasIndividuais) {this.estatisticasIndividuais = estatisticasIndividuais;}}
    
    //Metodos Especiais
    public void adicionarGols(int golsCasa, int golsFora) {
        this.golsCasa += golsCasa;
        this.golsFora += golsFora;
    }
    
    public void adicionarSubstituicao(Substituicao substituicao) {
        this.substituicoes.add(substituicao);
    }
    
    public void adicionarCartao(Cartao cartao) {
        this.cartoes.add(cartao);
    }
    
    public void atualizarEstatisticasEquipe(Equipe equipe, EstatisticasEquipe estatisticas) {
        this.estatisticasEquipe.put(equipe, estatisticas);
    }
    
    public void atualizarEstatisticasIndividuais(Jogador jogador, EstatisticasIndividuais estatisticas) {
        this.estatisticasIndividuais.put(jogador, estatisticas);
    }

}