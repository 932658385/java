import java.util.*;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;

public class Main {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        List<Equipa> equipas = new ArrayList<>();

        while (true) {
            // Menu
            System.out.println("Menu:");
            System.out.println("1. Cadastrar Equipa");
            System.out.println("2. Listar Equipas");
            System.out.println("3. Relacionar Jogadores");
            System.out.println("4. Realizar Jogo");
            System.out.println("5. Ações com Jogador");
            System.out.println("6. Carregar Equipa");
            System.out.println("7. Sair");
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
                        carregarEquipa(scanner, equipas);
                        break;

                    case 7:
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
            System.out.print("Data de fundação (AAAA-MM-DD): ");
            LocalDate fundacao = LocalDate.parse(scanner.nextLine());
    
            Equipa equipa = new Equipa(nome, apelido, fundacao);
    
            List<Jogador> jogadores = new ArrayList<>();
            for (int i = 0; i < 23; i++) {
                System.out.println("Cadastro do jogador " + (i + 1));
                System.out.print("Nome do jogador: ");
                String nomeJogador = scanner.nextLine();
                System.out.print("Apelido do jogador: ");
                String apelidoJogador = scanner.nextLine();
                System.out.print("Data de nascimento do jogador (AAAA-MM-DD): ");
                LocalDate dataNascimento = LocalDate.parse(scanner.nextLine());
                System.out.print("Número do jogador: ");
                int numero = Integer.parseInt(scanner.nextLine());
                System.out.print("Posição do jogador: ");
                String posicao = scanner.nextLine();
                System.out.print("Qualidade do jogador: ");
                int qualidade = Integer.parseInt(scanner.nextLine());
    
                Jogador jogador = new Jogador(i + 1, nomeJogador, apelidoJogador, dataNascimento, numero, posicao, qualidade);
                jogadores.add(jogador);
            }
            
            equipa.cadastrarJogadores(jogadores);
            equipa.salvarEquipa();
            equipas.add(equipa);
            System.out.println("Equipa cadastrada e salva com sucesso!");
        } catch (DateTimeParseException | NumberFormatException e) {
            System.out.println("Formato de data ou número inválido. Por favor, insira os dados corretamente.");
        }
    }    

    private static void listarEquipas(List<Equipa> equipas) {
        if (equipas.isEmpty()) {
            System.out.println("Nenhuma equipa cadastrada.");
        } else {
            for (Equipa equipa : equipas) {
                System.out.println(equipa.equipaToString());
            }
        }
    }

    private static void relacionarJogadores(Scanner scanner, List<Equipa> equipas) {
        try {
            System.out.print("Nome da equipa para relacionar jogadores: ");
            String nomeEquipa = scanner.nextLine();
            Optional<Equipa> equipaParaRelacionar = equipas.stream()
                    .filter(e -> e.getNome().equalsIgnoreCase(nomeEquipa))
                    .findFirst();
    
            if (equipaParaRelacionar.isPresent()) {
                System.out.println("Relacionando jogadores...");
                // Exemplo de predicate para relacionar jogadores aptos
                JogadorPredicate predicate = Jogador::estaAptoParaJogar;
                equipaParaRelacionar.get().relacionarJogadores(predicate);
                equipaParaRelacionar.get().salvarJogadoresRelacionados(); // Correção aqui
                System.out.println("Jogadores relacionados e salvos com sucesso!");
            } else {
                System.out.println("Equipa não encontrada.");
            }
        } catch (Exception e) {
            System.out.println("Ocorreu um erro ao relacionar jogadores: " + e.getMessage());
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
                Jogo jogo = new Jogo(mandante.get(), visitante.get(), LocalDate.now(), "Estádio Municipal", "Cidade XYZ");
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

    private static void carregarEquipa(Scanner scanner, List<Equipa> equipas) {
        System.out.print("Nome do arquivo da equipa a ser carregada (sem extensão): ");
        String nomeArquivo = scanner.nextLine() + "_dados.txt";
        Equipa equipaCarregada = Equipa.carregarEquipa(nomeArquivo);
        if (equipaCarregada != null) {
            equipas.add(equipaCarregada);
            System.out.println("Equipa carregada com sucesso!");
        }
    }
}