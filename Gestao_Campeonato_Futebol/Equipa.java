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
        if (plantel.size() < 5) {
            plantel.add(jogador);
        } else {
            System.out.println("O plantel já possui 5 jogadores.");
        }
    }

    public void cadastrarJogadores(List<Jogador> jogadores) {
        if (jogadores.size() == 2) {
            this.plantel.addAll(jogadores);
        } else {
            System.out.println("A equipa deve ter exatamente 2 jogadores.");
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

    public void imprimirEscalações() {
        System.out.println("Escalação da equipa " + nome + ":");

        // Titulares
        System.out.println("Titulares:");
        for (int i = 0; i < 11; i++) {
            Jogador jogador = relacionados.get(i);
            String condicao = jogador.estaAptoParaJogar() ? "Apto" : "Suspenso";
            System.out.println(jogador + " - Condição: " + condicao);
        }

        // Reservas
        System.out.println("Reservas:");
        for (int i = 11; i < 18; i++) {
            Jogador jogador = relacionados.get(i);
            String condicao = jogador.estaAptoParaJogar() ? "Apto" : "Suspenso";
            System.out.println(jogador + " - Condição: " + condicao);
        }
    }

    public List<Jogador> relacionarJogadores() {
        // Lista para armazenar os jogadores relacionados (titulares e reservas)
        List<Jogador> relacionados = new ArrayList<>();

        // Seleciona os titulares
        List<Jogador> titulares = plantel.stream()
                .sorted(Comparator.comparingInt(Jogador::getQualidade).reversed()) // Ordena por qualidade decrescente
                .collect(Collectors.toList());

        // Agrupa os titulares por posição
        titulares.stream().collect(Collectors.groupingBy(Jogador::getPosicao))
                .forEach((posicao, jogadores) -> {
                    // Adiciona apenas o melhor jogador de cada posição aos titulares
                    relacionados.add(jogadores.get(0));
                });

        // Seleciona os reservas (jogadores restantes do plantel)
        List<Jogador> reservas = plantel.stream()
                .filter(j -> !relacionados.contains(j)) // Exclui os jogadores já selecionados como titulares
                .sorted(Comparator.comparingInt(Jogador::getQualidade).reversed()) // Ordena por qualidade decrescente
                .collect(Collectors.toList());

        // Adiciona os reservas (até 7 jogadores)
        relacionados.addAll(reservas.subList(0, Math.min(7, reservas.size())));

        return relacionados;
    }
}