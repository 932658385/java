import java.util.Scanner;

public class Principal {
    private static Crud crud = new Crud();

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        while (true) {
            exibirMenu();
            int opcao = Integer.parseInt(scanner.nextLine());
            switch (opcao) {
                case 1:
                    crud.adicionarJogador(scanner);
                    break;
                case 2:
                    crud.atualizarJogador(scanner);
                    break;
                case 3:
                    crud.removerJogador(scanner);
                    break;
                case 4:
                    crud.listarJogadores();
                    break;
                case 5:
                    crud.buscarJogadorPorId(scanner);
                    break;
                case 6:
                    crud.listarEquipes();
                    break;
                case 0:
                    System.out.println("Saindo...");
                    scanner.close();
                    System.exit(0);
                    break;
                default:
                    System.out.println("Opção inválida.");
            }
        }
    }

    private static void exibirMenu() {
        System.out.println("Menu:");
        System.out.println("1. Adicionar Jogador");
        System.out.println("2. Atualizar Jogador");
        System.out.println("3. Remover Jogador");
        System.out.println("4. Listar Jogadores");
        System.out.println("5. Buscar Jogador por ID");
        System.out.println("6. Listar Equipes");
        System.out.println("0. Sair");
        System.out.print("Escolha uma opção: ");
    }
}