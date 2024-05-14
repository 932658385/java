import java.io.*;
import java.time.LocalDate;
import java.util.*;

public class Main {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        List<Equipa> equipas = new ArrayList<>();

        while (true) {
            System.out.println("Menu:");
            System.out.println("1. Cadastrar Equipa");
            System.out.println("2. Listar Equipas");
            System.out.println("3. Relacionar Jogadores");
            System.out.println("4. Realizar Jogo");
            System.out.println("5. Ações com Jogador");
            System.out.println("6. Sair");
            System.out.print("Escolha uma opção: ");

            try {
                int opcao = scanner.nextInt();
                scanner.nextLine(); // Consumir nova linha

                switch (opcao) {
                    case 1:
                        cadastrarEquipa(scanner, equipas);
                        break;

                    case 2:
                        listarEquipas(equipas);
                        break;

                    case 3:
                        relacionarJogadores(scanner, equipas);
                        break;

                    case 4:
                        realizarJogo(scanner, equipas);
                        break;

                    case 5:
                        acoesComJogador(scanner, equipas);
                        break;

                    case 6:
                        System.out.println("Saindo...");
                        scanner.close();
                        System.exit(0);
                        break;

                    default:
                        System.out.println("Opção inválida.");
                }
            } catch (InputMismatchException e) {
                System.out.println("Entrada inválida. Por favor, insira um número.");
                scanner.nextLine(); // Consumir entrada inválida
            } catch (Exception e) {
                System.out.println("Ocorreu um erro: " + e.getMessage());
            }
        }
    }

    private static void cadastrarEquipa(Scanner scanner, List<Equipa> equipas) {
        try {
            System.out.print("Nome da equipa: ");
            String nome = scanner.nextLine();
            System.out.print("Apelido da equipa: ");
            String apelido = scanner.nextLine();
            System.out.print("Ano de fundação: ");
            int ano = scanner.nextInt();
            System.out.print("Mês de fundação: ");
            int mes = scanner.nextInt();
            System.out.print("Dia de fundação: ");
            int dia = scanner.nextInt();
            scanner.nextLine(); // Consumir nova linha
    
            Equipa equipa = new Equipa(nome, apelido, LocalDate.of(ano, mes, dia));
    
            for (int i = 0; i < 23; i++) {
                System.out.print("Nome do jogador: ");
                String nomeJogador = scanner.nextLine();
                System.out.print("Apelido do jogador: ");
                String apelidoJogador = scanner.nextLine();
                System.out.print("Ano de nascimento do jogador: ");
                int anoNascimento = scanner.nextInt();
                System.out.print("Mês de nascimento do jogador: ");
                int mesNascimento = scanner.nextInt();
                System.out.print("Dia de nascimento do jogador: ");
                int diaNascimento = scanner.nextInt();
                System.out.print("Número do jogador: ");
                int numero = scanner.nextInt();
                scanner.nextLine(); // Consumir nova linha
                System.out.print("Posição do jogador: ");
                String posicao = scanner.nextLine();
                System.out.print("Qualidade do jogador: ");
                int qualidade = scanner.nextInt();
                scanner.nextLine(); // Consumir nova linha
    
                Jogador jogador = new Jogador(i + 1, nomeJogador, apelidoJogador, LocalDate.of(anoNascimento, mesNascimento, diaNascimento), numero, posicao, qualidade);
                equipa.adicionarJogador(jogador);
            }
    
            equipas.add(equipa);
            salvarEquipaEmTXT(equipa); // Salvar os dados da equipe em um arquivo de texto
            salvarJogadores(equipa); // Salvar os dados dos jogadores em um arquivo de texto
            System.out.println("Equipa cadastrada e salva com sucesso!");
        } catch (InputMismatchException e) {
            System.out.println("Entrada inválida. Por favor, insira os dados corretamente.");
            scanner.nextLine(); // Consumir entrada inválida
        } catch (Exception e) {
            System.out.println("Ocorreu um erro ao cadastrar a equipa: " + e.getMessage());
        }
    }
    
    private static void salvarEquipaEmTXT(Equipa equipa) {
        String nomeArquivo = equipa.getNome() + ".txt";
        try (PrintWriter writer = new PrintWriter(nomeArquivo)) {
            writer.println("Nome: " + equipa.getNome());
            writer.println("Apelido: " + equipa.getApelido());
            writer.println("Ano de Fundação: " + equipa.getDataFundacao().getYear());
            writer.println("Mês de Fundação: " + equipa.getDataFundacao().getMonthValue());
            writer.println("Dia de Fundação: " + equipa.getDataFundacao().getDayOfMonth());
            writer.println("Jogadores:");
            for (Jogador jogador : equipa.getPlantel()) {
                writer.println(jogador.getId() + ". " + jogador.getNome() + " " + jogador.getApelido());
                writer.println("   Nascimento: " + jogador.getDataNascimento());
                writer.println("   Número: " + jogador.getNumero());
                writer.println("   Posição: " + jogador.getPosicao());
                writer.println("   Qualidade: " + jogador.getQualidade());
            }
        } catch (IOException e) {
            System.out.println("Erro ao salvar equipa em arquivo: " + e.getMessage());
        }
    }
    
    private static void salvarJogadores(Equipa equipa) {
        String nomeArquivo = equipa.getNome() + "_jogadores.txt";
        try (PrintWriter writer = new PrintWriter(nomeArquivo)) {
            writer.println("Jogadores da equipa " + equipa.getNome() + ":");
            for (Jogador jogador : equipa.getPlantel()) {
                writer.println(jogador.getId() + ". " + jogador.getNome() + " " + jogador.getApelido());
                writer.println("   Nascimento: " + jogador.getDataNascimento());
                writer.println("   Número: " + jogador.getNumero());
                writer.println("   Posição: " + jogador.getPosicao());
                writer.println("   Qualidade: " + jogador.getQualidade());
            }
        } catch (IOException e) {
            System.out.println("Erro ao salvar jogadores em arquivo: " + e.getMessage());
        }
    }    
    

    private static void listarEquipas(List<Equipa> equipas) {
        System.out.println("Equipas cadastradas:");
        equipas.forEach(e -> System.out.println(e.getNome() + " (" + e.getApelido() + ")"));
    }

    private static void relacionarJogadores(Scanner scanner, List<Equipa> equipas) {
        try {
            System.out.print("Nome da equipa para relacionar jogadores: ");
            String nomeEquipa = scanner.nextLine();
            Optional<Equipa> equipaParaRelacionar = equipas.stream().filter(e -> e.getNome().equals(nomeEquipa)).findFirst();
            if (equipaParaRelacionar.isPresent()) {
                JogadorPredicate predicate = Jogador::estaAptoParaJogar; // Exemplo: relacionar apenas jogadores aptos
                equipaParaRelacionar.get().relacionarJogadores(predicate);
                System.out.println("Jogadores relacionados com sucesso!");
            } else {
                System.out.println("Equipa não encontrada.");
            }
        } catch (Exception e) {
            System.out.println("Erro ao relacionar jogadores: " + e.getMessage());
        }
    }

    private static void realizarJogo(Scanner scanner, List<Equipa> equipas) {
        try {
            System.out.print("Nome da equipa mandante: ");
            String nomeMandante = scanner.nextLine();
            Optional<Equipa> mandante = equipas.stream().filter(e -> e.getNome().equals(nomeMandante)).findFirst();

            System.out.print("Nome da equipa visitante: ");
            String nomeVisitante = scanner.nextLine();
            Optional<Equipa> visitante = equipas.stream().filter(e -> e.getNome().equals(nomeVisitante)).findFirst();

            if (mandante.isPresent() && visitante.isPresent()) {
                Jogo jogo = new Jogo(mandante.get(), visitante.get(), new Date(), "Estádio Municipal", "Cidade XYZ");
                jogo.gerarResultado();
                jogo.gerarLesoes();
                jogo.gerarCartoes();
                jogo.permitirTreinamento();
            } else {
                System.out.println("Uma ou ambas as equipas não foram encontradas.");
            }
        } catch (Exception e) {
            System.out.println("Erro ao realizar jogo: " + e.getMessage());
        }
    }

    private static void acoesComJogador(Scanner scanner, List<Equipa> equipas) {
        try {
            System.out.print("Nome da equipa: ");
            String nomeEquipa = scanner.nextLine();
            Optional<Equipa> equipaOptional = equipas.stream().filter(e -> e.getNome().equals(nomeEquipa)).findFirst();
            if (equipaOptional.isPresent()) {
                Equipa equipa = equipaOptional.get();
                System.out.print("ID do jogador: ");
                int idJogador = scanner.nextInt();
                scanner.nextLine(); // Consumir nova linha
                Optional<Jogador> jogadorOptional = equipa.getPlantel().stream().filter(j -> j.getId() == idJogador).findFirst();

                if (jogadorOptional.isPresent()) {
                    Jogador jogador = jogadorOptional.get();
                    System.out.println("Ações com o jogador:");
                    System.out.println("1. Aplicar Cartão");
                    System.out.println("2. Cumprir Suspensão");
                    System.out.println("3. Sofrer Lesão");
                    System.out.println("4. Executar Treinamento");
                    System.out.println("5. Resetar Treinamento");
                    System.out.print("Escolha uma opção: ");

                    int opcao = scanner.nextInt();
                    scanner.nextLine(); // Consumir nova linha

                    switch (opcao) {
                        case 1:
                            System.out.print("Quantidade de cartões: ");
                            int quantidade = scanner.nextInt();
                            jogador.acaoCartao(quantidade);
                            break;
                        case 2:
                            jogador.cumprirSuspensao();
                            break;
                        case 3:
                            jogador.acaoLesao();
                            break;
                        case 4:
                            jogador.acaoTreinamento();
                            break;
                        case 5:
                            jogador.resetarTreinamento();
                            break;
                        default:
                            System.out.println("Opção inválida.");
                    }
                } else {
                    System.out.println("Jogador não encontrado.");
                }
            } else {
                System.out.println("Equipa não encontrada.");
            }
        } catch (InputMismatchException e) {
            System.out.println("Entrada inválida. Por favor, insira os dados corretamente.");
            scanner.nextLine(); // Consumir entrada inválida
        } catch (Exception e) {
            System.out.println("Ocorreu um erro: " + e.getMessage());
        }
    }
}