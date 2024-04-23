import java.util.Scanner;

/**
 * Classe principal que representa a interface de linha de comando para interagir com o sistema bancário.
 */
public class Main {

    /**
     * Método principal que inicia o programa e apresenta o menu de opções ao usuário.
     *
     * @param args argumentos da linha de comando (não são utilizados neste programa)
     */
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        ContaOrdem contaOrdem = new ContaOrdem(1001, 1000, "01/01/2024");
        ContaBancaria contaBancaria = new ContaBancaria(1, contaOrdem);

        boolean sair = false;
        while (!sair) {
            System.out.println("\n### Sistema Bancário ###");
            System.out.println("1. Depositar");
            System.out.println("2. Levantar");
            System.out.println("3. Consultar Saldo Corrente");
            System.out.println("4. Consultar Saldo Total");
            System.out.println("5. Listar Titulares");
            System.out.println("6. Adicionar Titular");
            System.out.println("7. Listar Contas Poupança");
            System.out.println("8. Adicionar Conta Poupança");
            System.out.println("9. Atualizar Saldo");
            System.out.println("10. Verificar se Conta Pode Ser Removida");
            System.out.println("0. Sair");
            System.out.print("Escolha uma opção: ");
            int opcao = scanner.nextInt();
            scanner.nextLine(); // Limpar o buffer do scanner

            switch (opcao) {
                case 1:
                    System.out.print("Digite o valor a depositar: ");
                    double valorDeposito = scanner.nextDouble();
                    try {
                        contaBancaria.depositar(valorDeposito);
                        System.out.println("Depósito realizado com sucesso!");
                    } catch (InvalidDepositException e) {
                        System.out.println("Erro ao depositar: " + e.getMessage());
                    }
                    break;
                case 2:
                    System.out.print("Digite o valor a levantar: ");
                    double valorLevantamento = scanner.nextDouble();
                    try {
                        contaBancaria.levantar(valorLevantamento);
                        System.out.println("Levantamento realizado com sucesso!");
                    } catch (InvalidWithdrawalException e) {
                        System.out.println("Erro ao levantar: " + e.getMessage());
                    }
                    break;
                case 3:
                    System.out.println("Saldo corrente: " + contaBancaria.consultarSaldoCorrente());
                    break;
                case 4:
                    System.out.println("Saldo total: " + contaBancaria.consultarSaldoTotal());
                    break;
                case 5:
                    System.out.println("Titulares:");
                    for (Titular titular : contaBancaria.listarTitulares()) {
                        System.out.println("Nome: " + titular.getNome() + ", Número Cliente: " + titular.getNumeroCliente());
                    }
                    break;
                case 6:
                    System.out.print("Digite o nome do titular: ");
                    String nomeTitular = scanner.nextLine();
                    System.out.print("Digite o número do cliente: ");
                    int numeroCliente = scanner.nextInt();
                    contaBancaria.listarTitulares().add(new Titular(nomeTitular, numeroCliente));
                    break;
                case 7:
                    System.out.println("Contas Poupança:");
                    for (ContaPoupanca poupanca : contaBancaria.listarContasPoupanca()) {
                        System.out.println("Número da Conta: " + poupanca.getNumeroConta() + ", Saldo: " + poupanca.consultarSaldo());
                    }
                    break;
                case 8:
                    System.out.print("Digite o número da conta poupança: ");
                    int numeroContaPoupanca = scanner.nextInt();
                    System.out.print("Digite o saldo inicial: ");
                    double saldoInicialPoupanca = scanner.nextDouble();
                    System.out.print("Digite a taxa de juros: ");
                    double taxaJurosPoupanca = scanner.nextDouble();
                    System.out.print("Digite a data de início (DD/MM/AAAA): ");
                    String dataInicioPoupanca = scanner.next();
                    System.out.print("Digite a duração em dias: ");
                    int duracaoDias = scanner.nextInt();
                    contaBancaria.adicionarContaPoupanca(new ContaPoupanca(numeroContaPoupanca, saldoInicialPoupanca, taxaJurosPoupanca, dataInicioPoupanca, duracaoDias));
                    break;
                case 9:
                    contaBancaria.atualizarSaldo();
                    System.out.println("Saldo atualizado com sucesso!");
                    break;
                case 10:
                    if (contaBancaria.podeSerRemovida()) {
                        System.out.println("A conta pode ser removida do banco.");
                    } else {
                        System.out.println("A conta não pode ser removida do banco.");
                    }
                    break;
                case 0:
                    sair = true;
                    System.out.println("Encerrando o programa.");
                    break;
                default:
                    System.out.println("Opção inválida. Por favor, escolha uma opção válida.");
            }
        }

        scanner.close();
    }
}