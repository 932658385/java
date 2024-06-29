import java.util.Scanner;

/**
 * Classe principal que gerencia o menu e as operações do campeonato.
 */
public class Main {
    /**
     * Método principal que inicia o programa.
     * @param args Argumentos da linha de comando (não utilizados).
     */
    public static void main(String[] args) {
        Campeonato campeonato = new Campeonato();
        Scanner scanner = new Scanner(System.in);
        boolean sair = false;

        while (!sair) {
            System.out.println("");
            System.out.println("*****************************************************");
            System.out.println("1. Cadastrar Equipes");
            System.out.println("2. Criar Jogos");
            System.out.println("3. Executar Campeonato");
            System.out.println("4. Imprimir Escalações");
            System.out.println("5. Aplicar Cartão a Jogador");
            System.out.println("6. Cumprir Suspensão de Jogador");
            System.out.println("7. Sofrer Lesão de Jogador");
            System.out.println("8. Executar Treinamento de Jogador");
            System.out.println("9. Menu de Jogadores");
            System.out.println("10. Imprimir Plantel dos Jogadores Aptos");
            System.out.println("0. Sair");
            System.out.print("Escolha uma opção: ");

            int opcao = scanner.nextInt();
            scanner.nextLine(); // Consumir nova linha

            switch (opcao) {
                case 1:
                    campeonato.cadastrarEquipes();
                    break;
                case 2:
                    campeonato.criarJogos(scanner);
                    break;
                case 3:
                    campeonato.executarCampeonato();
                    break;
                case 4:
                    campeonato.imprimirEscalacoes();
                    break;
                case 5:
                    campeonato.aplicarCartao(scanner);
                    break;
                case 6:
                    campeonato.cumprirSuspensao(scanner);
                    break;
                case 7:
                    campeonato.sofrerLesao(scanner);
                    break;
                case 8:
                    campeonato.executarTreinamento(scanner);
                    break;
                case 9:
                    menuJogadores(scanner, campeonato);
                    break;
                case 10:
                    campeonato.imprimirPlantelApto();
                    break;
                
                case 0:
                    sair = true;
                    System.out.println("Salvando Arquivos....");
                    System.out.println("Saindo...");
                    campeonato.salvarEquipes();
                    break;
                default:
                    System.out.println("Opção inválida.");
            }
        }

        scanner.close();
    }

    /**
     * Método que exibe o menu de operações relacionadas aos jogadores.
     * @param scanner Objeto Scanner para entrada de dados do usuário.
     * @param campeonato Objeto Campeonato que contém as operações relacionadas aos jogadores.
     */
    
     private static void menuJogadores(Scanner scanner, Campeonato campeonato) {
        boolean sair = false;
        while (!sair) {
            System.out.println("");
            System.out.println("1. Imprimir Plantel");
            System.out.println("2. Resetar Treinamento");
            System.out.println("3. Resetar Lesão");
            System.out.println("0. Voltar");
            System.out.print("Escolha uma opção: ");

            int opcao = scanner.nextInt();
            scanner.nextLine(); // Consumir nova linha

            switch (opcao) {
                case 1:
                    campeonato.imprimirPlantelApto();
                    break;
                case 2:
                    campeonato.resetarTreinamento();
                    System.out.println("Treinamento dos jogadores foi resetado.");
                    break;
                case 3:
                    campeonato.resetarLesao();
                    System.out.println("Lesões dos jogadores foram resetadas.");
                    break;
                case 0:
                    sair = true;
                    break;
                default:
                    System.out.println("Opção inválida.");
            }
        }
    }
}