import java.util.List;
import java.util.Optional;
import java.util.Scanner;

public class Crud {
    private JogadorService jogadorService = new JogadorService();
    private EquipeService equipeService = new EquipeService();

    public void adicionarJogador(Scanner scanner) {
        System.out.print("Nome do jogador: ");
        String nome = scanner.nextLine();
        System.out.print("Posição do jogador: ");
        String posicao = scanner.nextLine();
        System.out.print("Número de gols: ");
        int gols = Integer.parseInt(scanner.nextLine());

        System.out.println("Equipes disponíveis:");
        List<Equipe> equipes = equipeService.getAllEquipes();
        equipes.forEach(equipe -> System.out.println("ID: " + equipe.getId() + ", Nome: " + equipe.getNome()));

        System.out.print("ID da equipe do jogador: ");
        int equipeId = Integer.parseInt(scanner.nextLine());
        Optional<Equipe> equipeOpt = equipeService.getEquipeById(equipeId);

        if (equipeOpt.isPresent()) {
            Jogador jogador = new Jogador();
            jogador.setNome(nome);
            jogador.setPosicao(posicao);
            jogador.setGols(gols);
            jogador.setEquipe(equipeOpt.get());

            jogadorService.addJogador(jogador);
            System.out.println("Jogador adicionado com sucesso.");
        } else {
            System.out.println("Equipe não encontrada.");
        }
    }

    public void atualizarJogador(Scanner scanner) {
        System.out.print("ID do jogador: ");
        int id = Integer.parseInt(scanner.nextLine());
        Optional<Jogador> jogadorOpt = jogadorService.getJogadorById(id);
        if (jogadorOpt.isPresent()) {
            Jogador jogador = jogadorOpt.get();
            System.out.print("Novo nome do jogador (" + jogador.getNome() + "): ");
            String nome = scanner.nextLine();
            System.out.print("Nova posição do jogador (" + jogador.getPosicao() + "): ");
            String posicao = scanner.nextLine();
            System.out.print("Novo número de gols (" + jogador.getGols() + "): ");
            int gols = Integer.parseInt(scanner.nextLine());

            jogador.setNome(nome);
            jogador.setPosicao(posicao);
            jogador.setGols(gols);

            jogadorService.updateJogador(jogador);
            System.out.println("Jogador atualizado com sucesso.");
        } else {
            System.out.println("Jogador não encontrado.");
        }
    }

    public void removerJogador(Scanner scanner) {
        System.out.print("ID do jogador: ");
        int id = Integer.parseInt(scanner.nextLine());
        jogadorService.deleteJogador(id);
        System.out.println("Jogador removido com sucesso.");
    }

    public void listarJogadores() {
        List<Jogador> jogadores = jogadorService.getAllJogadores();
        jogadores.forEach(jogador -> System.out.println("ID: " + jogador.getId() + ", Nome: " + jogador.getNome() + ", Posição: " + jogador.getPosicao() + ", Gols: " + jogador.getGols() + ", Equipe: " + jogador.getEquipe().getNome()));
    }

    public void buscarJogadorPorId(Scanner scanner) {
        System.out.print("ID do jogador: ");
        int id = Integer.parseInt(scanner.nextLine());
        Optional<Jogador> jogadorOpt = jogadorService.getJogadorById(id);
        if (jogadorOpt.isPresent()) {
            Jogador jogador = jogadorOpt.get();
            System.out.println("ID: " + jogador.getId() + ", Nome: " + jogador.getNome() + ", Posição: " + jogador.getPosicao() + ", Gols: " + jogador.getGols() + ", Equipe: " + jogador.getEquipe().getNome());
        } else {
            System.out.println("Jogador não encontrado.");
        }
    }

    public void listarEquipes() {
        List<Equipe> equipes = equipeService.getAllEquipes();
        equipes.forEach(equipe -> System.out.println("ID: " + equipe.getId() + ", Nome: " + equipe.getNome()));
    }
}