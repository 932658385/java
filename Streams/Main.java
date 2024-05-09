import java.util.*;

public class Main {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        // Lista dinâmica para armazenar os filmes
        List<Filme> listaFilmes = new ArrayList<>();

        System.out.println("Bem-vindo! Vamos adicionar alguns filmes.");

        // Adicionando filmes
        while (true) {
            System.out.print("Título do filme (ou 'sair' para terminar): ");
            String titulo = scanner.nextLine();

            if (titulo.equalsIgnoreCase("sair")) {
                break;
            }

            System.out.print("Diretor do filme: ");
            String diretor = scanner.nextLine();

            int duracao;
            while (true) {
                try {
                    System.out.print("Duração do filme em minutos: ");
                    duracao = Integer.parseInt(scanner.nextLine());
                    if (duracao <= 0) {
                        throw new IllegalArgumentException("A duração deve ser um número positivo.");
                    }
                    break;
                } catch (NumberFormatException e) {
                    System.out.println("Por favor, insira um número válido para a duração.");
                } catch (IllegalArgumentException e) {
                    System.out.println(e.getMessage());
                }
            }

            int ano;
            while (true) {
                try {
                    System.out.print("Ano de lançamento do filme: ");
                    ano = Integer.parseInt(scanner.nextLine());
                    if (ano <= 0) {
                        throw new IllegalArgumentException("O ano deve ser um número positivo.");
                    }
                    break;
                } catch (NumberFormatException e) {
                    System.out.println("Por favor, insira um número válido para o ano.");
                } catch (IllegalArgumentException e) {
                    System.out.println(e.getMessage());
                }
            }

            // Criar um novo objeto Filme e adicioná-lo à lista de filmes
            Filme filme = new Filme(titulo, diretor, duracao, ano);
            listaFilmes.add(filme);

            // Exibir separador após o cadastro de cada filme
            System.out.println("\n==============================================\n");
        }

        // Criar um objeto Filmes com a lista de filmes inserida
        Filmes filmes = new Filmes(listaFilmes);

        // Exibir informações sobre os filmes
        System.out.println("\n==============================================");
        System.out.println("Total de filmes: " + filmes.contarTotalFilmes());
        System.out.println("===============================================");

        System.out.print("\nDigite o nome do diretor para contar seus filmes: ");
        String nomeDiretor = scanner.nextLine();
        System.out.println("Filmes do diretor " + nomeDiretor + ": " + filmes.contarFilmesPorDiretor(nomeDiretor));
        System.out.println("===============================================");

        int duracaoMaxima;
        while (true) {
            try {
                System.out.print("\nDigite a duração máxima desejada para os filmes: ");
                duracaoMaxima = Integer.parseInt(scanner.nextLine());
                if (duracaoMaxima <= 0) {
                    throw new IllegalArgumentException("A duração máxima deve ser um número positivo.");
                }
                break;
            } catch (NumberFormatException e) {
                System.out.println("Por favor, insira um número válido para a duração máxima.");
            } catch (IllegalArgumentException e) {
                System.out.println(e.getMessage());
            }
        }

        List<Filme> filmesComDuracaoMenorQue = filmes.obterFilmesComDuracaoMenorQue(duracaoMaxima);
        System.out.println("Filmes com duração menor que " + duracaoMaxima + " minutos: ");
        for (Filme filme : filmesComDuracaoMenorQue) {
            System.out.println("- " + filme.getTitulo());
        }
        System.out.println("===============================================");

        System.out.println("\nMapa de diretores para seus filmes: ");
        filmes.mapearDiretorParaFilmes().forEach((diretor, listaFilmesDiretor) -> {
            System.out.println(diretor + ": ");
            listaFilmesDiretor.forEach(filme -> System.out.println("- " + filme.getTitulo()));
        });
        System.out.println("===============================================");

        Filme filmeMaisLongo = filmes.encontrarFilmeMaisLongo();
        System.out.println("\nFilme mais longo: " + filmeMaisLongo.getTitulo());
        System.out.println("==============================================");

        Filme filmeMaisCurto = filmes.encontrarFilmeMaisCurto();
        System.out.println("\nFilme mais curto: " + filmeMaisCurto.getTitulo());
        System.out.println("==============================================");

        List<Filme> filmesOrdenadosPorAno = filmes.ordenarFilmesPorAno();
        System.out.println("\nFilmes ordenados por ano: ");
        for (Filme filme : filmesOrdenadosPorAno) {
            System.out.println("- " + filme.getTitulo() + " (" + filme.getAno() + ")");
        }
        System.out.println("==============================================");
    }
}