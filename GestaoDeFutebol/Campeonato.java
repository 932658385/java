import java.io.*;
import java.time.LocalDate;
import java.util.*;

/**
 * Representa um campeonato de futebol.
 */
public class Campeonato {
    private List<Equipa> equipes;
    private List<Jogo> jogos;
    private static final String ARQUIVO_EQUIPES = "equipes.txt";

    /**
     * Construtor padrão que inicializa as listas de equipes e jogos e carrega as equipes do arquivo.
     */
    public Campeonato() {
        this.equipes = new ArrayList<>();
        this.jogos = new ArrayList<>();
        carregarEquipes();
    }

    /**
     * Construtor que permite inicializar o campeonato com uma lista de equipes.
     * @param equipes Lista de equipes.
     */
    public Campeonato(List<Equipa> equipes) {
        this.equipes = equipes;
    }

    /**
     * Permite cadastrar equipes manualmente.
     */
    public void cadastrarEquipes() {
        Scanner scanner = new Scanner(System.in);
        for (int i = 1; i <= 2; i++) {
            System.out.println("");
            System.out.println("");
            System.out.print("Digite o nome da Equipe " + i + ": ");
            String nome = scanner.nextLine();
            System.out.print("Digite o apelido da Equipe " + i + ": ");
            String apelido = scanner.nextLine();
            System.out.print("Digite a data de fundação da Equipe " + i + " (AAAA-MM-DD): ");
            LocalDate fundacao = LocalDate.parse(scanner.nextLine());
            List<Jogador> plantel = new ArrayList<>();
            for (int j = 1; j <= 23; j++) {
                System.out.println("");
                System.out.print("Digite o nome do Jogador " + j + ": ");
                String nomeJogador = scanner.nextLine();
                System.out.print("Digite o apelido do Jogador " + j + ": ");
                String apelidoJogador = scanner.nextLine();
                System.out.print("Digite a data de nascimento do Jogador " + j + " (AAAA-MM-DD): ");
                LocalDate dataNascimento = LocalDate.parse(scanner.nextLine());
                System.out.print("Digite o número do Jogador " + j + ": ");
                int numero = scanner.nextInt();
                scanner.nextLine(); // Consumir nova linha
                System.out.print("Digite a posição do Jogador " + j + ": ");
                String posicao = scanner.nextLine();
                System.out.print("Digite a qualidade do Jogador " + j + " (0-100): ");
                int qualidade = scanner.nextInt();
                scanner.nextLine(); // Consumir nova linha
                Jogador jogador = new Jogador(j, nomeJogador, apelidoJogador, dataNascimento, numero, posicao, qualidade, 0, false, false);
                plantel.add(jogador);
            }
            Equipa equipe = new Equipa(nome, apelido, fundacao, plantel, new ArrayList<>());
            equipes.add(equipe);
        }
        salvarEquipes();
    }

    /**
     * Cria um novo jogo, permitindo que o usuário selecione as equipes mandante e visitante.
     * @param scanner Scanner para entrada de dados.
     */
    public void criarJogos(Scanner scanner) {
        if (equipes.size() < 2) {
            System.out.println("Número insuficiente de equipes para criar jogos.");
            return;
        }
        System.out.println("Selecione a equipe mandante:");
        listarEquipes();
        int indiceMandante = scanner.nextInt();
        scanner.nextLine(); // Consumir a nova linha
        System.out.println("Selecione a equipe visitante:");
        listarEquipes();
        int indiceVisitante = scanner.nextInt();
        scanner.nextLine(); // Consumir a nova linha
        if (indiceMandante < 0 || indiceMandante >= equipes.size() || indiceVisitante < 0 || indiceVisitante >= equipes.size() || indiceMandante == indiceVisitante) {
            System.out.println("Seleção de equipes inválida.");
            return;
        }
        Equipa mandante = equipes.get(indiceMandante);
        Equipa visitante = equipes.get(indiceVisitante);
        Jogo jogo = new Jogo(mandante, visitante, LocalDate.now(), "Estadio", "Cidade", 0, 0);
        jogos.add(jogo);
        salvarEquipes();
        System.out.println("Jogo criado com sucesso!");
    }

    /**
     * Imprime o plantel apto de cada equipe para os jogos.
     */
    public void imprimirPlantelApto() {
        if (jogos == null) {
            System.out.println("Nenhum jogo criado.");
            return;
        }
        for (Jogo jogo : jogos) {
            System.out.println("");
            System.out.println("***************************************************");
            System.out.println("Plantel do Mandante:");
            for (Jogador jogador : jogo.getMandante().getPlantel()) {
                String condicao = jogador.isSuspenso() ? "suspenso" : "ta pra jogo";
                System.out.printf("%s %d- %s (%s) - %s - Condição: %s%n",
                        jogador.getPosicao(), jogador.getNumero(), jogador.getNome(),
                        jogador.getApelido(), jogador.getDataNascimento(), condicao);
            }
            System.out.println("");
            System.out.println("**************************************************");
            System.out.println("Plantel do Visitante:");
            for (Jogador jogador : jogo.getVisitante().getPlantel()) {
                String condicao = jogador.isSuspenso() ? "suspenso" : "ta pra jogo";
                System.out.printf("%s %d- %s (%s) - %s - Condição: %s%n",
                        jogador.getPosicao(), jogador.getNumero(), jogador.getNome(),
                        jogador.getApelido(), jogador.getDataNascimento(), condicao);
            }
        }
    }
    
    /**
     * Lista as equipes disponíveis para seleção.
     */
    private void listarEquipes() {
        for (int i = 0; i < equipes.size(); i++) {
            System.out.println(i + ". " + equipes.get(i).getNome());
        }
    }
    
    /**
     * Executa o campeonato, gerando resultados para cada jogo.
     */
    public void executarCampeonato() {
        if (jogos.isEmpty()) {
            System.out.println("Nenhum jogo foi criado. Por favor, crie jogos antes de executar o campeonato.");
            return;
        }
        for (Jogo jogo : jogos) {
            System.out.println("Jogo entre: " + jogo.getMandante().getNome() + " vs " + jogo.getVisitante().getNome());
            jogo.gerarResultado();
            jogo.gerarLesoes(jogo);
            jogo.gerarCartoes(jogo);
            jogo.permitirTreinamento();
            System.out.println("");
            System.out.println("Placar: " + jogo.getMandante().getNome() + " " + jogo.getPlacarMandante() + " - " + jogo.getVisitante().getNome() + " " + jogo.getPlacarVisitante());
            System.out.println("");
        }
        salvarEquipes();
    }
    
    /**
     * Imprime as escalacoes de todas as equipes.
     */
    public void imprimirEscalacoes() {
        for (Equipa equipe : equipes) {
            System.out.println("");
            System.out.println("************************************************************");
            System.out.println("Escalação da " + equipe.getNome() + ":");
            equipe.relacionarJogadores();
            equipe.imprimirEscalacao();
            System.out.println("************************************************************");
            System.out.println();
        }
        salvarEquipes();
    }

    /**
     * Aplica um cartão a um jogador de uma equipe.
     * @param scanner Scanner para entrada de dados.
     */
    public void aplicarCartao(Scanner scanner) {
        System.out.println("");
        System.out.print("Digite o nome da equipe: ");
        String nomeEquipe = scanner.nextLine();
        System.out.print("Digite o número do jogador: ");
        int numeroJogador = scanner.nextInt();
        scanner.nextLine();  // Consumir nova linha
        Equipa equipe = encontrarEquipePorNome(nomeEquipe);
        if (equipe == null) {
            System.out.println("Equipe não encontrada.");
            return;
        }
        Jogador jogador = encontrarJogadorPorNumero(equipe, numeroJogador);
        if (jogador == null) {
            System.out.println("Jogador não encontrado.");
            return;
        }
        System.out.println("");
        System.out.print("Digite o tipo de cartão (amarelo/vermelho): ");
        String tipoCartao = scanner.nextLine();
        System.out.print("Digite a quantidade de cartões: ");
        int quantidadeCartoes = scanner.nextInt();
        scanner.nextLine();  // Consumir nova linha
        if (tipoCartao.equalsIgnoreCase("amarelo") || tipoCartao.equalsIgnoreCase("vermelho")) {
            jogador.aplicarCartao(tipoCartao, quantidadeCartoes);
            System.out.println("Cartão(s) aplicado(s) com sucesso para o jogador " + jogador.getNome());
        } else {
            System.out.println("Tipo de cartão inválido.");
        }
        System.out.println("");
        salvarEquipes();
    }

    /**
     * Cumpre a suspensão de um jogador de uma equipe.
     * @param scanner Scanner para entrada de dados.
     */
    public void cumprirSuspensao(Scanner scanner) {
        System.out.println("");
        System.out.print("Digite o nome da equipe: ");
        String nomeEquipe = scanner.nextLine();
        System.out.print("Digite o número do jogador: ");
        int numeroJogador = scanner.nextInt();
        scanner.nextLine();  // Consumir nova linha
        Equipa equipe = encontrarEquipePorNome(nomeEquipe);
        if (equipe == null) {
            System.out.println("Equipe não encontrada.");
            return;
        }
        Jogador jogador = encontrarJogadorPorNumero(equipe, numeroJogador);
        if (jogador == null) {
            System.out.println("Jogador não encontrado.");
            return;
        }
        jogador.cumprirSuspensao();
        System.out.println("Suspensão cumprida com sucesso para o jogador " + jogador.getNome());
        salvarEquipes();
    }

    /**
     * Simula uma lesão em um jogador de uma equipe.
     * @param scanner Scanner para entrada de dados.
     */
    public void sofrerLesao(Scanner scanner) {
        System.out.println("");
        System.out.print("Digite o nome da equipe: ");
        String nomeEquipe = scanner.nextLine();
        System.out.print("Digite o número do jogador: ");
        int numeroJogador = scanner.nextInt();
        scanner.nextLine();  // Consumir nova linha
        Equipa equipe = encontrarEquipePorNome(nomeEquipe);
        if (equipe == null) {
            System.out.println("Equipe não encontrada.");
            return;
        }
        Jogador jogador = encontrarJogadorPorNumero(equipe, numeroJogador);
        if (jogador == null) {
            System.out.println("Jogador não encontrado.");
            return;
        }
        jogador.sofrerLesao();
        System.out.println("Lesão sofrida com sucesso para o jogador " + jogador.getNome());
        System.out.println("");
        salvarEquipes();
    }

    /**
     * Executa o treinamento para um jogador de uma equipe.
     * @param scanner Scanner para entrada de dados.
     */
    public void executarTreinamento(Scanner scanner) {
        System.out.println("");
        System.out.print("Digite o nome da equipe: ");
        String nomeEquipe = scanner.nextLine();
        System.out.print("Digite o número do jogador: ");
        int numeroJogador = scanner.nextInt();
        scanner.nextLine();  // Consumir nova linha
        Equipa equipe = encontrarEquipePorNome(nomeEquipe);
        if (equipe == null) {
            System.out.println("Equipe não encontrada.");
            return;
        }
        Jogador jogador = encontrarJogadorPorNumero(equipe, numeroJogador);
        if (jogador == null) {
            System.out.println("Jogador não encontrado.");
            return;
        }
        jogador.executarTreinamento();
        System.out.println("Treinamento executado com sucesso para o jogador " + jogador.getNome());
        salvarEquipes();
    }

    /**
     * Encontra uma equipe pelo nome.
     * @param nome Nome da equipe.
     * @return Equipe encontrada ou null se não encontrada.
     */
    private Equipa encontrarEquipePorNome(String nome) {
        for (Equipa equipe : equipes) {
            if (equipe.getNome().equalsIgnoreCase(nome)) {
                return equipe;
            }
        }
        return null;
    }

    /**
     * Encontra um jogador pelo número em uma equipe.
     * @param equipe Equipe onde buscar o jogador.
     * @param numero Número do jogador.
     * @return Jogador encontrado ou null se não encontrado.
     */
    private Jogador encontrarJogadorPorNumero(Equipa equipe, int numero) {
        for (Jogador jogador : equipe.getPlantel()) {
            if (jogador.getNumero() == numero) {
                return jogador;
            }
        }
        return null;
    }

    /**
     * Reseta o treinamento de todos os jogadores de todas as equipes.
     */
    public void resetarTreinamento() {
        for (Equipa equipe : equipes) {
            for (Jogador jogador : equipe.getPlantel()) {
                jogador.resetarTreinamento();
            }
        }
        salvarEquipes();
    }

    /**
     * Reseta as lesões de todos os jogadores de todas as equipes.
     */
    public void resetarLesao() {
        for (Equipa equipe : equipes) {
            for (Jogador jogador : equipe.getPlantel()) {
                jogador.resetarLesao();
            }
        }
        salvarEquipes();
    }

    // Métodos para criar, salvar e carregar equipes em arquivos

    /**
     * Cria um arquivo de equipes e salva as equipes no arquivo.
     */
    public void criarArquivoEquipes() {
        try {
            FileWriter writer = new FileWriter(ARQUIVO_EQUIPES);
            BufferedWriter bufferedWriter = new BufferedWriter(writer);
            for (Equipa equipe : equipes) {
                bufferedWriter.write(equipe.getNome() + "," + equipe.getApelido() + "," + equipe.getFundacao() + "\n");
                for (Jogador jogador : equipe.getPlantel()) {
                    bufferedWriter.write(jogador.getId() + "," + jogador.getNome() + "," + jogador.getApelido() + "," +
                            jogador.getDataNascimento() + "," + jogador.getNumero() + "," +
                            jogador.getPosicao() + "," + jogador.getQualidade() + "," +
                            jogador.getCartoes() + "," + jogador.getSuspenso() + "," + jogador.getTreinou() + "\n");
                }
                bufferedWriter.write("\n"); // Adicionar uma linha em branco entre equipes
            }
            bufferedWriter.close();
            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * Salva as equipes no arquivo.
     */
    public void salvarEquipes() {
        try (FileWriter writer = new FileWriter(ARQUIVO_EQUIPES)) {
            for (Equipa equipe : equipes) {
                writer.write(equipe.getNome() + "," + equipe.getApelido() + "," + equipe.getFundacao() + "\n");
                for (Jogador jogador : equipe.getPlantel()) {
                    writer.write(jogador.getId() + "," + jogador.getNome() + "," + jogador.getApelido() + "," +
                            jogador.getDataNascimento() + "," + jogador.getNumero() + "," +
                            jogador.getPosicao() + "," +                             jogador.getQualidade() + "," +
                            jogador.getCartoes() + "," + jogador.getSuspenso() + "," + jogador.getTreinou() + "\n");
                }
                writer.write("\n"); // Adicionar uma linha em branco entre equipes
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * Carrega as equipes a partir do arquivo.
     */
    public void carregarEquipes() {
        File arquivo = new File(ARQUIVO_EQUIPES);
        if (!arquivo.exists()) {
            System.out.println("O arquivo 'equipes.txt' não foi encontrado. Criando um novo arquivo");
            criarArquivoEquipes();
            return;
        }

        System.out.println("Caminho absoluto do arquivo: " + arquivo.getAbsolutePath());
        System.out.println("");
        System.out.println("************************************************************");
        System.out.println("");
        try (Scanner scanner = new Scanner(arquivo)) {
            while (scanner.hasNextLine()) {
                String[] equipeDados = scanner.nextLine().split(",");
                Equipa equipe = new Equipa(equipeDados[0], equipeDados[1], LocalDate.parse(equipeDados[2]), new ArrayList<>(), new ArrayList<>());
                while (scanner.hasNextLine()) {
                    String linha = scanner.nextLine();
                    if (linha.isEmpty()) {
                        break;
                    }
                    String[] jogadorDados = linha.split(",");
                    Jogador jogador = new Jogador(Integer.parseInt(jogadorDados[0]), jogadorDados[1], jogadorDados[2],
                            LocalDate.parse(jogadorDados[3]), Integer.parseInt(jogadorDados[4]), jogadorDados[5],
                            Integer.parseInt(jogadorDados[6]), Integer.parseInt(jogadorDados[7]),
                            Boolean.parseBoolean(jogadorDados[8]), Boolean.parseBoolean(jogadorDados[9]));
                    equipe.getPlantel().add(jogador);
                }
                equipes.add(equipe);
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
    }

    /**
     * Obtém a lista de equipes.
     * @return Lista de equipes.
     */
    public List<Equipa> getEquipes() {
        return equipes;
    }

    /**
     * Obtém a lista de jogos.
     * @return Lista de jogos.
     */
    public List<Jogo> getJogos() {
        return jogos;
    }
}