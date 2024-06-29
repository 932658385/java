import java.time.LocalDate;
import java.util.List;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.stream.Collectors;

/**
 * Classe que representa uma equipe em um campeonato.
 */
public class Equipa {
    private String nome;
    private String apelido;
    private LocalDate fundacao;
    private List<Jogador> plantel;
    private List<Jogador> relacionados;

    /**
     * Construtor da classe Equipa.
     * @param nome Nome da equipe.
     * @param apelido Apelido ou sigla da equipe.
     * @param fundacao Data de fundação da equipe.
     * @param plantel Lista de jogadores no plantel da equipe.
     * @param relacionados Lista de jogadores relacionados para uma partida.
     */
    public Equipa(String nome, String apelido, LocalDate fundacao, List<Jogador> plantel, List<Jogador> relacionados) {
        this.nome = nome;
        this.apelido = apelido;
        this.fundacao = fundacao;
        this.plantel = plantel;
        this.relacionados = relacionados;
    }

    /**
     * Obtém o nome da equipe.
     * @return Nome da equipe.
     */
    public String getNome() {
        return this.nome;
    }

    /**
     * Define o nome da equipe.
     * @param nome Nome da equipe.
     */
    public void setNome(String nome) {
        this.nome = nome;
    }

    /**
     * Obtém o apelido da equipe.
     * @return Apelido da equipe.
     */
    public String getApelido() {
        return this.apelido;
    }

    /**
     * Define o apelido da equipe.
     * @param apelido Apelido da equipe.
     */
    public void setApelido(String apelido) {
        this.apelido = apelido;
    }

    /**
     * Obtém a data de fundação da equipe.
     * @return Data de fundação da equipe.
     */
    public LocalDate getFundacao() {
        return this.fundacao;
    }

    /**
     * Define a data de fundação da equipe.
     * @param fundacao Data de fundação da equipe.
     */
    public void setFundacao(LocalDate fundacao) {
        this.fundacao = fundacao;
    }

    /**
     * Obtém o plantel da equipe.
     * @return Lista de jogadores no plantel da equipe.
     */
    public List<Jogador> getPlantel() {
        return this.plantel;
    }

    /**
     * Define o plantel da equipe.
     * @param plantel Lista de jogadores no plantel da equipe.
     */
    public void setPlantel(List<Jogador> plantel) {
        this.plantel = plantel;
    }

    /**
     * Obtém os jogadores relacionados para uma partida.
     * @return Lista de jogadores relacionados para uma partida.
     */
    public List<Jogador> getRelacionados() {
        return this.relacionados;
    }

    /**
     * Define os jogadores relacionados para uma partida.
     * @param relacionados Lista de jogadores relacionados para uma partida.
     */
    public void setRelacionados(List<Jogador> relacionados) {
        this.relacionados = relacionados;
    }
    
    /**
     * Relaciona os jogadores da equipe para uma partida, selecionando titulares e reservas.
     * @return Lista de jogadores relacionados para uma partida.
     */
    public List<Jogador> relacionarJogadores() {
        List<Jogador> titulares = plantel.stream()
                .sorted(Comparator.comparingInt(Jogador::getQualidade).reversed())
                .limit(11)
                .collect(Collectors.toList());
        List<Jogador> reservas = plantel.stream()
                .sorted(Comparator.comparingInt(Jogador::getQualidade).reversed())
                .skip(11)
                .limit(7)
                .collect(Collectors.toList());
        this.relacionados = new ArrayList<>();
        this.relacionados.addAll(titulares);
        this.relacionados.addAll(reservas);
        return relacionados;
    }
    
    /**
     * Imprime a escalação da equipe para uma partida.
     */
    public void imprimirEscalacao() {
        System.out.println("");
        System.out.println("*****************************************************");
        System.out.println("Titulares:");
        for (int i = 0; i < 11; i++) {
            Jogador jogador = relacionados.get(i);
            System.out.printf("%s %d- %s (%s) - %s%n",
                    jogador.getPosicao(), jogador.getNumero(), jogador.getNome(),
                    jogador.getApelido(), jogador.getDataNascimento());
        }
        System.out.println("");
        System.out.println("*****************************************************");
        System.out.println("Reservas:");
        for (int i = 11; i < relacionados.size(); i++) {
            Jogador jogador = relacionados.get(i);
            System.out.printf("%s %d- %s (%s) - %s%n",
                    jogador.getPosicao(), jogador.getNumero(), jogador.getNome(),
                    jogador.getApelido(), jogador.getDataNascimento());
        }
    }  
}