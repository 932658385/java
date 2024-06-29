package entidade;
import java.util.List;

public class Jogo {
    private int id;
    private int calendarioId;
    private int equipe1Id;
    private int equipe2Id;
    private int golsEquipe1;
    private int golsEquipe2;
    private String fase;
    private List<Selecao> equipes;
    private List<Gol> gols;
    private List<Cartao> cartoes;
    private List<EstatisticasEquipe> estatisticasEquipe;
    private List<EstatisticasJogador> estatisticasJogadores; 
    private List<Substituicao> substituicoes;

    public Jogo(int id, int calendarioId, int equipe1Id, int equipe2Id, int golsEquipe1, int golsEquipe2, String fase,
                List<Selecao> equipes, List<Gol> gols, List<Cartao> cartoes, List<EstatisticasEquipe> estatisticasEquipe,
                List<EstatisticasJogador> estatisticasJogadores, List<Substituicao> substituicoes) {
        this.id = id;
        this.calendarioId = calendarioId;
        this.equipe1Id = equipe1Id;
        this.equipe2Id = equipe2Id;
        this.golsEquipe1 = golsEquipe1;
        this.golsEquipe2 = golsEquipe2;
        this.fase = fase;
        this.equipes = equipes;
        this.gols = gols;
        this.cartoes = cartoes;
        this.estatisticasEquipe = estatisticasEquipe;
        this.estatisticasJogadores = estatisticasJogadores;
        this.substituicoes = substituicoes;
    }

    public int getId() {return id;}
    public int getCalendarioId() {return calendarioId;}
    public int getEquipe1Id() {return equipe1Id;}
    public int getEquipe2Id() {return equipe2Id;}
    public int getGolsEquipe1() {return golsEquipe1;}
    public int getGolsEquipe2() {return golsEquipe2;}
    public String getFase() {return fase;}
    public List<Selecao> getEquipes() {return equipes;}
    public List<Gol> getGols() {return gols;}
    public List<Cartao> getCartoes() {return cartoes;}
    public List<EstatisticasEquipe> getEstatisticasEquipe() {return estatisticasEquipe;}
    public List<EstatisticasJogador> getEstatisticasJogadores() {return estatisticasJogadores;}
    public List<Substituicao> getSubstituicoes() {return substituicoes;}
    public void setId(int id) {this.id=id;}

    @Override
    public String toString() {
        return "Jogo{" +
                "id=" + id +
                ", calendarioId=" + calendarioId +
                ", equipe1Id=" + equipe1Id +
                ", equipe2Id=" + equipe2Id +
                ", golsEquipe1=" + golsEquipe1 +
                ", golsEquipe2=" + golsEquipe2 +
                ", fase='" + fase + '\'' +
                ", equipes=" + equipes +
                ", gols=" + gols +
                ", cartoes=" + cartoes +
                ", estatisticasEquipe=" + estatisticasEquipe +
                ", estatisticasJogadores=" + estatisticasJogadores +
                ", substituicoes=" + substituicoes +
                '}';
    }
}