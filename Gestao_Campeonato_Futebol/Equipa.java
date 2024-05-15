import java.io.*;
import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.io.FileReader;
import java.io.BufferedReader;



public class Equipa implements Serializable {
    private String nome;
    private String apelido;
    private LocalDate fundacao;
    private List<Jogador> plantel;
    private List<Jogador> relacionados;

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

    public void imprimirEscalacoes() {
        System.out.println("Escalação da equipa " + nome + ":");

        System.out.println("Titulares:");
        for (int i = 0; i < 11; i++) {
            Jogador jogador = relacionados.get(i);
            String condicao = jogador.estaAptoParaJogar() ? "Apto" : "Suspenso";
            System.out.println(jogador + " - Condição: " + condicao);
        }

        System.out.println("Reservas:");
        for (int i = 11; i < 18; i++) {
            Jogador jogador = relacionados.get(i);
            String condicao = jogador.estaAptoParaJogar() ? "Apto" : "Suspenso";
            System.out.println(jogador + " - Condição: " + condicao);
        }
    }

    public List<Jogador> relacionarJogadores() {
        List<Jogador> relacionados = new ArrayList<>();
        List<Jogador> titulares = plantel.stream()
                .sorted(Comparator.comparingInt(Jogador::getQualidade).reversed())
                .collect(Collectors.toList());

        titulares.stream().collect(Collectors.groupingBy(Jogador::getPosicao))
                .forEach((posicao, jogadores) -> {
                    relacionados.add(jogadores.get(0));
                });

        List<Jogador> reservas = plantel.stream()
                .filter(j -> !relacionados.contains(j))
                .sorted(Comparator.comparingInt(Jogador::getQualidade).reversed())
                .collect(Collectors.toList());

        relacionados.addAll(reservas.subList(0, Math.min(7, reservas.size())));

        return relacionados;
    }

    public String equipaToString() {
        StringBuilder sb = new StringBuilder();
        sb.append("Nome: ").append(nome).append("\n")
          .append("Apelido: ").append(apelido).append("\n")
          .append("Fundação: ").append(fundacao).append("\n")
          .append("Plantel:\n");
        for (Jogador jogador : plantel) {
            sb.append(jogador.jogadorToString()).append("\n");
        }
        return sb.toString();
    }

    public void salvarEquipa() {
        String nomeArquivo = this.nome + "_dados.txt";
        try (PrintWriter writer = new PrintWriter(new FileWriter(nomeArquivo))) {
            writer.println("Nome: " + this.nome);
            writer.println("Apelido: " + this.apelido);
            writer.println("Fundação: " + this.fundacao);
            writer.println("Plantel:");
            for (Jogador jogador : this.plantel) {
                writer.println(jogador.jogadorToString());
            }
            System.out.println("Equipa salva em " + nomeArquivo);
        } catch (IOException e) {
            System.out.println("Erro ao salvar equipa: " + e.getMessage());
        }
    }

    public static Equipa carregarEquipa(String nomeArquivo) {
        try (BufferedReader reader = new BufferedReader(new FileReader(nomeArquivo))) {
            String nome = null;
            String apelido = null;
            LocalDate fundacao = null;
            List<Jogador> plantel = new ArrayList<>();

            String linha;
            while ((linha = reader.readLine()) != null) {
                if (linha.startsWith("Nome: ")) {
                    nome = linha.substring("Nome: ".length());
                } else if (linha.startsWith("Apelido: ")) {
                    apelido = linha.substring("Apelido: ".length());
                } else if (linha.startsWith("Fundação: ")) {
                    fundacao = LocalDate.parse(linha.substring("Fundação: ".length()));
                } else if (linha.equals("Plantel:")) {
                    while ((linha = reader.readLine()) != null) {
                        // Assumindo que a linha contém dados do jogador no formato correto
                        Jogador jogador = criarJogadorAPartirDeString(linha); // Você precisa implementar este método
                        plantel.add(jogador);
                    }
                }
            }

            Equipa equipa = new Equipa(nome, apelido, fundacao);
            equipa.setPlantel(plantel);
            System.out.println("Equipa carregada de " + nomeArquivo);
            return equipa;
        } catch (IOException e) {
            System.out.println("Erro ao carregar equipa: " + e.getMessage());
            return null;
        }
    }

    public void salvarJogadoresRelacionados() {
        String nomeArquivo = this.nome + "_com_jogadores_relacionados.txt";
        try (PrintWriter writer = new PrintWriter(new FileWriter(nomeArquivo))) {
            writer.println("Nome: " + this.nome);
            writer.println("Apelido: " + this.apelido);
            writer.println("Fundação: " + this.fundacao);
            writer.println("Plantel:");
            for (Jogador jogador : this.plantel) {
                String condicao = jogador.estaAptoParaJogar() ? "Apto" : "Suspenso";
                writer.println(jogador.jogadorToString() + " - Condição: " + condicao);
            }
            writer.println("Titulares:");
            for (int i = 0; i < 11; i++) {
                Jogador jogador = relacionados.get(i);
                String condicao = jogador.estaAptoParaJogar() ? "Apto" : "Suspenso";
                writer.println(jogador.jogadorToString() + " - Condição: " + condicao);
            }
            writer.println("Reservas:");
            for (int i = 11; i < 18; i++) {
                Jogador jogador = relacionados.get(i);
                String condicao = jogador.estaAptoParaJogar() ? "Apto" : "Suspenso";
                writer.println(jogador.jogadorToString() + " - Condição: " + condicao);
            }
            System.out.println("Jogadores relacionados salvos em " + nomeArquivo);
        } catch (IOException e) {
            System.out.println("Erro ao salvar jogadores relacionados: " + e.getMessage());
        }
    }  

    public static Jogador criarJogadorAPartirDeString(String linha) {
        String[] partes = linha.split("| "); // Supondo que os dados do jogador estejam separados por "| "
        int id = Integer.parseInt(partes[0]); // O primeiro elemento é o ID
        String nome = partes[1]; // O segundo elemento é o nome
        String apelido = partes[2]; // O terceiro elemento é o apelido
        LocalDate dataNascimento = LocalDate.parse(partes[3]); // O quarto elemento é a data de nascimento (no formato ISO)
        int numero = Integer.parseInt(partes[4]); // O quinto elemento é o número do jogador
        String posicao = partes[5]; // O sexto elemento é a posição
        int qualidade = Integer.parseInt(partes[6]); // O sétimo elemento é a qualidade

        return new Jogador(id, nome, apelido, dataNascimento, numero, posicao, qualidade);
    }
}