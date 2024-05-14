import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.io.Serializable;
import java.util.Comparator;
import java.util.stream.Collectors;

public class Equipa implements Serializable {
    private String nome;
    private String apelido;
    private LocalDate fundacao;
    private List<Jogador> plantel;
    private List<Jogador> relacionados;

    // Construtores
    public Equipa() {
        this.plantel = new ArrayList<>();
        this.relacionados = new ArrayList<>();
    }

    public Equipa(String nome, String apelido, LocalDate fundacao) {
        this.nome = nome;
        this.apelido = apelido;
        this.fundacao = fundacao;
        this.plantel = new ArrayList<>();
        this.relacionados = new ArrayList<>();
    }

    // Getters e Setters
    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getApelido() {
        return apelido;
    }

    public void setApelido(String apelido) {
        this.apelido = apelido;
    }

    public LocalDate getFundacao() {
        return fundacao;
    }

    public void setFundacao(LocalDate fundacao) {
        this.fundacao = fundacao;
    }

    public List<Jogador> getPlantel() {
        return plantel;
    }

    public void setPlantel(List<Jogador> plantel) {
        this.plantel = plantel;
    }

    public List<Jogador> getRelacionados() {
        return relacionados;
    }

    public void setRelacionados(List<Jogador> relacionados) {
        this.relacionados = relacionados;
    }

    // Métodos adicionais
    public void adicionarJogador(Jogador jogador) {
        if (plantel.size() < 23) {
            plantel.add(jogador);
        } else {
            System.out.println("O plantel já possui 23 jogadores.");
        }
    }

    public void cadastrarJogadores(List<Jogador> jogadores) {
        if (jogadores.size() == 11) {
            this.plantel.addAll(jogadores);
        } else {
            System.out.println("A equipa deve ter exatamente 11 jogadores.");
        }
    }

    public List<Jogador> relacionarJogadores(JogadorPredicate predicate) {
        relacionados = plantel.stream()
                .filter(predicate::test)
                .sorted(Comparator.comparingInt(Jogador::getQualidade).reversed())
                .limit(18)
                .collect(Collectors.toList());
        return relacionados;
    }

    public void imprimirPlantel() {
        System.out.println("Plantel da equipa " + nome + ":");
        for (Jogador jogador : plantel) {
            String condicao = jogador.estaAptoParaJogar() ? "Apto" : "Suspenso";
            System.out.println(jogador + " - Condição: " + condicao);
        }
    }
}