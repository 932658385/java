import java.time.LocalDate;
import java.util.List;
import java.util.ArrayList;
import java.util.Random;
import java.util.Comparator;
import java.util.stream.Collectors;

/**
 * Representa um jogador em uma equipe de futebol.
 */
public class Jogador {
    private int id;
    private String nome;
    private String apelido;
    private LocalDate dataNascimento;
    private int numero;
    private String posicao;
    private int qualidade;
    private int cartoes;
    private boolean suspenso;
    private boolean treinou;
    private List<Jogador> plantel; 
    private int cartoesAmarelos;
    private int cartoesVermelhos;
    private boolean lesionado;

    /**
     * Construtor da classe Jogador.
     * @param id Identificador único do jogador.
     * @param nome Nome do jogador.
     * @param apelido Apelido do jogador.
     * @param dataNascimento Data de nascimento do jogador.
     * @param numero Número da camisa do jogador.
     * @param posicao Posição em que o jogador atua.
     * @param qualidade Qualidade técnica do jogador.
     * @param cartoes Número de cartões recebidos pelo jogador.
     * @param suspenso Indica se o jogador está suspenso.
     * @param treinou Indica se o jogador treinou.
     */
    public Jogador(int id, String nome, String apelido, LocalDate dataNascimento, int numero, String posicao, int qualidade, int cartoes, boolean suspenso, boolean treinou) {
        this.id = id;
        this.nome = nome;
        this.apelido = apelido;
        this.dataNascimento = dataNascimento;
        this.numero = numero;
        this.posicao = posicao;
        this.qualidade = qualidade;
        this.cartoes = cartoes;
        this.suspenso = suspenso;
        this.treinou = treinou;
    }

    
    /**
     * Construtor da classe Jogador para inicialização básica.
     * @param nome Nome do jogador.
     * @param numero Número da camisa do jogador.
     */
    public Jogador(String nome, int numero) {
        this.nome = nome;
        this.numero = numero;
        this.cartoesAmarelos = 0;
        this.cartoesVermelhos = 0;
        this.suspenso = false;
        this.lesionado = false;
    }


    public int getId() {
        return this.id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNome() {
        return this.nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getApelido() {
        return this.apelido;
    }

    public void setApelido(String apelido) {
        this.apelido = apelido;
    }

    public LocalDate getDataNascimento() {
        return this.dataNascimento;
    }

    public void setDataNascimento(LocalDate dataNascimento) {
        this.dataNascimento = dataNascimento;
    }

    public int getNumero() {
        return this.numero;
    }

    public void setNumero(int numero) {
        this.numero = numero;
    }

    public String getPosicao() {
        return this.posicao;
    }

    public void setPosicao(String posicao) {
        this.posicao = posicao;
    }

    public int getQualidade() {
        return this.qualidade;
    }

    public void setQualidade(int qualidade) {
        this.qualidade = qualidade;
    }

    public int getCartoes() {
        return this.cartoes;
    }

    public void setCartoes(int cartoes) {
        this.cartoes = cartoes;
    }

    public boolean isSuspenso() {
        return this.suspenso;
    }

    public boolean getSuspenso() {
        return this.suspenso;
    }

    public void setSuspenso(boolean suspenso) {
        this.suspenso = suspenso;
    }    


    public boolean isTreinou() {
        return this.treinou;
    }

    public boolean getTreinou() {
        return this.treinou;
    }

    public void setTreinou(boolean treinou) {
        this.treinou = treinou;
    }

    public void resetarTreinamento() {
        this.treinou = false;
    }

    public void resetarLesao() {
        this.lesionado = false;
    }

    /**
     * Adiciona jogadores ao plantel da equipe.
     * @param jogadores Lista de jogadores a serem adicionados.
     * @throws IllegalArgumentException se o número de jogadores for diferente de 11.
     */
    public void cadastrarJogadores(List<Jogador> jogadores) {
        if (jogadores.size() != 11) {
            throw new IllegalArgumentException("Uma equipe deve ter exatamente 11 jogadores.");
        }
        this.plantel.addAll(jogadores);
    }

    /**
     * Verifica se o jogador está apto para jogar.
     * @return true se o jogador não estiver suspenso, false caso contrário.
     */
    public boolean estaAptoJogar() {
        return !suspenso;
    }

    
    /**
     * Imprime os jogadores do plantel da equipe.
     */
    public void imprimir() {
        for (Jogador jogador : plantel) {
            String condicao = jogador.estaAptoJogar() ? "ta pra jogo" : "suspenso";
            System.out.printf("%s %d- %s (%s) - %s - Condicao: %s%n",
                    jogador.getPosicao(), jogador.getNumero(), jogador.getNome(),
                    jogador.getApelido(), jogador.getDataNascimento(), condicao);
        }
    }
    
    /**
     * Aplica cartão (amarelo ou vermelho) a um jogador.
     * @param tipo Tipo de cartão a ser aplicado ("amarelo" ou "vermelho").
     * @param quantidade Quantidade de cartões a serem aplicados.
     */
    public void aplicarCartao(String tipo, int quantidade) {
        if (tipo.equalsIgnoreCase("amarelo")) {
            this.cartoesAmarelos += quantidade;
            if (this.cartoesAmarelos > 2) {
                this.suspenso = true;
            }
        } else if (tipo.equalsIgnoreCase("vermelho")) {
            this.cartoesVermelhos += quantidade;
            this.suspenso = true;
        }
    }
    
    /**
     * Cumpre a suspensão de um jogador, zerando seus cartões e removendo a suspensão.
     */
    public void cumprirSuspensao() {
        this.cartoes = 0;
        this.cartoesAmarelos = 0;
        this.cartoesVermelhos = 0;
        this.suspenso = false;
    }

    public void sofrerLesao() {
        Random rand = new Random();
        int chance = rand.nextInt(100);
        int decremento = 0;
        if (chance < 5) {
            decremento = (int) (this.qualidade * 0.15);
        } else if (chance < 15) {
            decremento = (int) (this.qualidade * 0.10);
        } else if (chance < 30) {
            decremento = (int) (this.qualidade * 0.05);
        } else if (chance < 60) {
            decremento = 2;
        } else {
            decremento = 1;
        }
        this.qualidade = Math.max(0, this.qualidade - decremento);
    }

    /**
     * Executa o treinamento de um jogador, aumentando sua qualidade técnica.
     */
    public void executarTreinamento() {
        Random rand = new Random();
        int chance = rand.nextInt(100);
        int incremento = 0;
        if (chance < 5) {
            incremento = 5;
        } else if (chance < 15) {
            incremento = 4;
        } else if (chance < 30) {
            incremento = 3;
        } else if (chance < 60) {
            incremento = 2;
        } else {
            incremento = 1;
        }
        this.qualidade = Math.min(100, this.qualidade + incremento);
        this.treinou = true;
    }
}