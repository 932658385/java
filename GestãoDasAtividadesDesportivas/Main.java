import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Scanner;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;

public class Main {
    public static void main(String[] args) {
        try {
            Scanner scanner = new Scanner(System.in);

            // Criando alguns associados para testar
            Associado associado1 = criarAssociado(scanner, "Associado 1");
            Associado associado2 = criarAssociado(scanner, "Associado 2");

            // Apresentando informações dos associados
            System.out.println("Informações dos Associados:");

            // Apresentar informações do Associado 1
            System.out.println("\nAssociado 1:");
            apresentarInformacoesAssociado(associado1);

            // Apresentar informações do Associado 2
            System.out.println("\nAssociado 2:");
            apresentarInformacoesAssociado(associado2);

            // Informações sobre as Atividades Desportivas
            System.out.println("\nInformações sobre as Atividades Desportivas:");
            Futsal futsal = criarAtividadeDesportiva(scanner);
            apresentarInformacoesAtividadeDesportiva(futsal);

            // Informações sobre os Campeonatos
            System.out.println("\nInformações sobre os Campeonatos:");
            Campeonato campeonato = criarCampeonato(scanner);
            apresentarInformacoesCampeonato(campeonato);

            // Informações sobre os Campeonatos de Futsal
            System.out.println("\nInformações sobre os Campeonatos de Futsal:");
            CampeonatoFutsal campeonatoFutsal = criarCampeonatoFutsal(scanner);
            apresentarInformacoesCampeonatoFutsal(campeonatoFutsal);

            scanner.close();
        } catch (Exception e) {
            System.out.println("Ocorreu um erro: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public static Associado criarAssociado(Scanner scanner, String mensagem) {
        Associado associado = new Associado();
        try {
            System.out.println("\n" + mensagem + ":");
            System.out.print("Nome: ");
            associado.setNome(scanner.nextLine());
            System.out.print("Número de Sócio: ");
            associado.setNumeroSocio(Integer.parseInt(scanner.nextLine()));
            System.out.print("Número de Bilhete de Identidade: ");
            associado.setNumeroBilheteIdentidade(Integer.parseInt(scanner.nextLine()));
            System.out.print("Número de Contribuinte: ");
            associado.setNumeroContribuinte(Integer.parseInt(scanner.nextLine()));
            System.out.print("Morada: ");
            associado.setEndereco(scanner.nextLine());
            System.out.print("Número de Telefone: ");
            associado.setNumeroTelefone(scanner.nextLine());
            System.out.print("E-mail: ");
            associado.setEmail(scanner.nextLine());
            System.out.print("Estatuto: ");
            associado.setEstatuto(scanner.nextLine());
            System.out.print("Data de Inscrição na Associação (Formato: dd/MM/yyyy): ");
            String dataString = scanner.nextLine();
            Date dataInscricao = DateUtils.parseDate(dataString, "dd/MM/yyyy");
            associado.setDataInscricao(dataInscricao);
            System.out.print("Estado das Quotas (true/false): ");
            associado.setQuotasEmDia(Boolean.parseBoolean(scanner.nextLine()));
            if (associado.getEstatuto().equalsIgnoreCase("dirigente")) {
                System.out.print("Anos de Mandato (separados por vírgula): ");
                String[] anosMandatoStr = scanner.nextLine().split(",");
                List<Integer> anosMandato = new ArrayList<>();
                for (String anoStr : anosMandatoStr) {
                    anosMandato.add(Integer.parseInt(anoStr.trim()));
                }
                ((AssociadoDirigente) associado).setAnosMandato(anosMandato);
            }
            if (!associado.isQuotasEmDia()) {
                System.out.print("Ano(s) das Quotas em Atraso (separados por vírgula): ");
                String[] anosQuotasAtrasadasStr = scanner.nextLine().split(",");
                List<Integer> anosQuotasAtrasadas = new ArrayList<>();
                for (String anoStr : anosQuotasAtrasadasStr) {
                    anosQuotasAtrasadas.add(Integer.parseInt(anoStr.trim()));
                }
                associado.setAnosQuotasAtrasadas(anosQuotasAtrasadas);
            }
        } catch (Exception e) {
            System.out.println("Erro ao criar associado: " + e.getMessage());
            e.printStackTrace();
        }
        return associado;
    }

    public static Futsal criarAtividadeDesportiva(Scanner scanner) {
        Futsal futsal = new Futsal();
        try {
            System.out.print("Nome da Atividade Desportiva: ");
            futsal.setNome(scanner.nextLine());
            List<String> atividadesDisponiveis = new ArrayList<>();
            System.out.println("Adicione as atividades disponíveis (digite 'fim' para terminar):");
            String atividade = scanner.nextLine();
            while (!atividade.equalsIgnoreCase("fim")) {
                atividadesDisponiveis.add(atividade);
                atividade = scanner.nextLine();
            }
            futsal.setAtividadesDisponiveis(atividadesDisponiveis);
        } catch (Exception e) {
            System.out.println("Erro ao criar atividade desportiva: " + e.getMessage());
            e.printStackTrace();
        }
        return futsal;
    }

    public static Campeonato criarCampeonato(Scanner scanner) {
        Campeonato campeonato = new Campeonato();
        try {
            System.out.print("Nome do Campeonato: ");
            campeonato.setNomeAtividade(scanner.nextLine());
            System.out.print("Data de Início do Campeonato (Formato: dd/MM/yyyy): ");
            String dataInicioString = scanner.nextLine();
            Date dataInicio = DateUtils.parseDate(dataInicioString, "dd/MM/yyyy");
            campeonato.setDataInicio(dataInicio);
            System.out.print("Data de Fim do Campeonato (Formato: dd/MM/yyyy): ");
            String dataFimString = scanner.nextLine();
            Date dataFim = DateUtils.parseDate(dataFimString, "dd/MM/yyyy");
            campeonato.setDataFim(dataFim);
            System.out.print("Número de Equipes Participantes: ");
            int numEquipes = Integer.parseInt(scanner.nextLine());
            List<Equipe> equipes = new ArrayList<>();
            for (int i = 1; i <= numEquipes; i++) {
                System.out.println("\nEquipe " + i + ":");
                Equipe equipe = criarEquipe(scanner);
                equipes.add(equipe);
            }
            campeonato.setEquipesParticipantes(equipes);
        } catch (Exception e) {
            System.out.println("Erro ao criar campeonato: " + e.getMessage());
            e.printStackTrace();
        }
        return campeonato;
    }

    public static CampeonatoFutsal criarCampeonatoFutsal(Scanner scanner) {
        CampeonatoFutsal campeonatoFutsal = new CampeonatoFutsal();
        try {
            System.out.print("Nome do Campeonato de Futsal: ");
            campeonatoFutsal.setNomeAtividade(scanner.nextLine());
            System.out.print("Data de Início do Campeonato de Futsal (Formato: dd/MM/yyyy): ");
            String dataInicioString = scanner.nextLine();
            Date dataInicio = DateUtils.parseDate(dataInicioString, "dd/MM/yyyy");
            campeonatoFutsal.setDataInicio(dataInicio);
            System.out.print("Data de Fim do Campeonato de Futsal (Formato: dd/MM/yyyy): ");
            String dataFimString = scanner.nextLine();
            Date dataFim = DateUtils.parseDate(dataFimString, "dd/MM/yyyy");
            campeonatoFutsal.setDataFim(dataFim);
            System.out.print("Necessidade de Equipe de Arbitragem (true/false): ");
            campeonatoFutsal.setNecessidadeEquipeArbitragem(Boolean.parseBoolean(scanner.nextLine()));
            if (campeonatoFutsal.isNecessidadeEquipeArbitragem()) {
                System.out.print("Número de Árbitros: ");
                int numArbitros = Integer.parseInt(scanner.nextLine());
                List<Associado> arbitros = new ArrayList<>();
                for (int i = 1; i <= numArbitros; i++) {
                    System.out.println("\nÁrbitro " + i + ":");
                    Associado arbitro = criarAssociado(scanner, "Árbitro " + i);
                    arbitros.add(arbitro);
                }
                campeonatoFutsal.setEquipeArbitragem(arbitros);
            }
        } catch (Exception e) {
            System.out.println("Erro ao criar campeonato de futsal: " + e.getMessage());
            e.printStackTrace();
        }
        return campeonatoFutsal;
    }

    public static Equipe criarEquipe(Scanner scanner) {
        Equipe equipe = new Equipe();
        try {
            System.out.print("Nome da Equipe: ");
            equipe.setNome(scanner.nextLine());
            System.out.print("Mascote da Equipe: ");
            equipe.setMascote(scanner.nextLine());
            System.out.print("Tamanho da Equipe: ");
            equipe.setTamanho(Integer.parseInt(scanner.nextLine()));
            System.out.print("Número de Membros da Equipe: ");
            int numMembros = Integer.parseInt(scanner.nextLine());
            List<Associado> membros = new ArrayList<>();
            for (int i = 1; i <= numMembros; i++) {
                System.out.println("\nMembro " + i + ":");
                Associado membro = criarAssociado(scanner, "Membro " + i);
                membros.add(membro);
            }
            equipe.setMembros(membros);
        } catch (Exception e) {
            System.out.println("Erro ao criar equipe: " + e.getMessage());
            e.printStackTrace();
        }
        return equipe;
    }

    public static void apresentarInformacoesAssociado(Associado associado) {
        try {
            System.out.println("Nome: " + associado.getNome());
            System.out.println("Número de Sócio: " + associado.getNumeroSocio());
            System.out.println("Número de Bilhete de Identidade: " + associado.getNumeroBilheteIdentidade());
            System.out.println("Número de Contribuinte: " + associado.getNumeroContribuinte());
            System.out.println("Morada: " + associado.getEndereco());
            System.out.println("Número de Telefone: " + associado.getNumeroTelefone());
            System.out.println("E-mail: " + associado.getEmail());
            System.out.println("Estatuto: " + associado.getEstatuto());
            System.out.println("Data de Inscrição na Associação: " + associado.getDataInscricao());
            if (associado.getEstatuto().equalsIgnoreCase("dirigente")) {
                List<Integer> anosMandato = ((AssociadoDirigente) associado).getAnosMandato();
                System.out.println("Mandatos como Dirigente: " + anosMandato);
            }
            System.out.println("Estado das Quotas: " + (associado.isQuotasEmDia() ? "Em dia" : "Por pagar"));
            List<Integer> anosQuotasAtrasadas = associado.getAnosQuotasAtrasadas();
            if (anosQuotasAtrasadas != null && !anosQuotasAtrasadas.isEmpty()) {
                System.out.println("Ano(s) das Quotas em Atraso: " + anosQuotasAtrasadas);
            }
        } catch (Exception e) {
            System.out.println("Erro ao apresentar informações do associado: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public static void apresentarInformacoesAtividadeDesportiva(Futsal futsal) {
        try {
            System.out.println("Nome da Atividade: " + futsal.getNome());
            System.out.println("Atividades Disponíveis: " + futsal.getAtividadesDisponiveis());
            System.out.println("Espaços onde as Atividades ocorrem: " + futsal.getEspacosAtividades());
        } catch (Exception e) {
            System.out.println("Erro ao apresentar informações da atividade desportiva: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public static void apresentarInformacoesCampeonato(Campeonato campeonato) {
        try {
            System.out.println("Nome da Atividade: " + campeonato.getNomeAtividade());
            System.out.println("Data de Início: " + campeonato.getDataInicio());
            System.out.println("Data de Fim: " + campeonato.getDataFim());
            List<Equipe> equipesParticipantes = campeonato.getEquipesParticipantes();
            if (equipesParticipantes != null && !equipesParticipantes.isEmpty()) {
                System.out.println("Equipas Participantes:");
                for (Equipe equipe : equipesParticipantes) {
                    System.out.println("Nome da Equipe: " + equipe.getNome());
                    System.out.println("Mascote da Equipe: " + equipe.getMascote());
                    System.out.println("Tamanho da Equipe: " + equipe.getTamanho());
                }
            } else {
                System.out.println("Nenhuma equipe registrada para este campeonato.");
            }
        } catch (Exception e) {
            System.out.println("Erro ao apresentar informações do campeonato: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public static void apresentarInformacoesCampeonatoFutsal(CampeonatoFutsal campeonatoFutsal) {
        try {
            System.out.println("Nome da Atividade: " + campeonatoFutsal.getNomeAtividade());
            System.out.println("Data de Início: " + campeonatoFutsal.getDataInicio());
            System.out.println("Data de Fim: " + campeonatoFutsal.getDataFim());
            System.out.println("Necessidade de Equipe de Arbitragem: " + campeonatoFutsal.isNecessidadeEquipeArbitragem());
            if (campeonatoFutsal.isNecessidadeEquipeArbitragem()) {
                List<Associado> arbitros = campeonatoFutsal.getEquipeArbitragem();
                if (arbitros != null && !arbitros.isEmpty()) {
                    System.out.println("Equipe de Arbitragem:");
                    for (Associado arbitro : arbitros) {
                        System.out.println("Nome do Árbitro: " + arbitro.getNome());
                    }
                } else {
                    System.out.println("Nenhuma equipe de arbitragem registrada para este campeonato.");
                }
            }
        } catch (Exception e) {
            System.out.println("Erro ao apresentar informações do campeonato de futsal: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public static class DateUtils {
        public static Date parseDate(String dateString, String format) throws ParseException {
            DateFormat dateFormat = new SimpleDateFormat(format);
            return dateFormat.parse(dateString);
        }
    }
}