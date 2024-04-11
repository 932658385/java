import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class Main {
    public static void main(String[] args) {
        // Criando alguns associados para testar
        Associado associado1 = new Associado();
        associado1.setNome("João Silva");
        associado1.setNumeroSocio(1001);
        associado1.setNumeroBilheteIdentidade(123456789);
        associado1.setNumeroContribuinte(987654321);
        associado1.setEndereco("Rua A, nº 123");
        associado1.setNumeroTelefone("123456789");
        associado1.setEmail("joao@example.com");
        associado1.setEstatuto("ordinário");
        associado1.setDataInscricao(new Date());
        associado1.setQuotasEmDia(true);

        Associado associado2 = new Associado();
        associado2.setNome("Maria Santos");
        associado2.setNumeroSocio(1002);
        associado2.setNumeroBilheteIdentidade(987654321);
        associado2.setNumeroContribuinte(123456789);
        associado2.setEndereco("Rua B, nº 456");
        associado2.setNumeroTelefone("987654321");
        associado2.setEmail("maria@example.com");
        associado2.setEstatuto("dirigente");
        associado2.setDataInscricao(new Date());
        associado2.setQuotasEmDia(false);
        List<Integer> anosQuotasAtrasadas = new ArrayList<>();
        anosQuotasAtrasadas.add(2023);
        associado2.setAnosQuotasAtrasadas(anosQuotasAtrasadas);

        // Apresentando informações dos associados
        System.out.println("Informações dos Associados:");
        System.out.println("\nAssociado 1:");
        apresentarInformacoesAssociado(associado1);

        System.out.println("\nAssociado 2:");
        apresentarInformacoesAssociado(associado2);

        // Informações sobre as Atividades Desportivas
        System.out.println("\nInformações sobre as Atividades Desportivas:");
        Futsal futsal = new Futsal(); // Instanciando um objeto Futsal
        futsal.setNome("Futsal");
        List<String> atividadesDisponiveis = new ArrayList<>();
        atividadesDisponiveis.add("Futsal");
        atividadesDisponiveis.add("Paintball");
        atividadesDisponiveis.add("Escalada");
        futsal.setAtividadesDisponiveis(atividadesDisponiveis); // Configurando atividades disponíveis
        List<EspacoAssociacao> espacoAssociacao = new ArrayList<>(); // Corrigido o nome da lista para espacoAssociacao
        EspacoAssociacao espaco1 = new EspacoAssociacao();
        espaco1.setIdentificacao("C");
        espacoAssociacao.add(espaco1);
        EspacoAssociacao espaco2 = new EspacoAssociacao();
        espaco2.setIdentificacao("J");
        espacoAssociacao.add(espaco2);
        futsal.setEspacosAtividades(espacoAssociacao); // Configurando espaços de atividades
        List<Associado> responsaveisAtividades = new ArrayList<>();
        responsaveisAtividades.add(associado2); // Maria é dirigente, responsável por atividades
        futsal.setResponsaveisAtividades(responsaveisAtividades); // Configurando responsáveis por atividades
        apresentarInformacoesAtividadeDesportiva(futsal); // Chamando o método com a instância de Futsal

        // Informações sobre os Campeonatos
        System.out.println("\nInformações sobre os Campeonatos:");
        Campeonato campeonato = new Campeonato();
        campeonato.setNomeAtividade("Futsal");
        campeonato.setDataInicio(new Date());
        campeonato.setDataFim(new Date());
        List<Equipe> equipesParticipantes = new ArrayList<>();
        Equipe equipe1 = new Equipe();
        equipe1.setNome("Equipe A");
        equipe1.setMascote("Mascote A");
        equipe1.setTamanho(10);
        equipesParticipantes.add(equipe1);
        campeonato.setEquipesParticipantes(equipesParticipantes);
        // Suponha que a lista de partidas esteja disponível em alguma outra parte do seu código
        List<Partida> partidas = campeonato.getPartidas();
        campeonato.setPartidas(partidas); // Defina as partidas no campeonato
        apresentarInformacoesCampeonato(campeonato);


        // Informações sobre os Campeonatos de Futsal
        System.out.println("\nInformações sobre os Campeonatos de Futsal:");
        CampeonatoFutsal campeonatoFutsal = new CampeonatoFutsal();
        campeonatoFutsal.setNomeAtividade("Futsal");
        campeonatoFutsal.setDataInicio(new Date());
        campeonatoFutsal.setDataFim(new Date());
        campeonatoFutsal.setNecessidadeEquipeArbitragem(true);
        List<Associado> equipeArbitragem = new ArrayList<>();
        equipeArbitragem.add(associado2); // Maria é dirigente e pode arbitrar
        campeonatoFutsal.setEquipeArbitragem(equipeArbitragem);
        apresentarInformacoesCampeonatoFutsal(campeonatoFutsal);
    }

    public static void apresentarInformacoesAssociado(Associado associado) {
        System.out.println("Nome: " + associado.getNome());
        System.out.println("Número de Sócio: " + associado.getNumeroSocio());
        System.out.println("Número de Bilhete de Identidade: " + associado.getNumeroBilheteIdentidade());
        System.out.println("Número de Contribuinte: " + associado.getNumeroContribuinte());
        System.out.println("Morada: " + associado.getEndereco());
        System.out.println("Número de Telefone: " + associado.getNumeroTelefone());
        System.out.println("E-mail: " + associado.getEmail());
        System.out.println("Estatuto: " + associado.getEstatuto());
        System.out.println("Data de Inscrição na Associação: " + associado.getDataInscricao());
        if (associado.getEstatuto().equals("dirigente")) {
            List<Integer> anosMandato = associado.getAnosMandato();
            System.out.println("Mandatos como Dirigente: " + anosMandato);
        }
        System.out.println("Estado das Quotas: " + (associado.isQuotasEmDia() ? "Em dia" : "Por pagar"));
        List<Integer> anosQuotasAtrasadas = associado.getAnosQuotasAtrasadas();
        if (anosQuotasAtrasadas != null && !anosQuotasAtrasadas.isEmpty()) {
            System.out.println("Ano(s) das Quotas em Atraso: " + anosQuotasAtrasadas);
        }
    }
    

    public static void apresentarInformacoesAtividadeDesportiva(AtividadeDesportiva atividadeDesportiva) {
        System.out.println("Nome da Atividade: " + atividadeDesportiva.getNome());
        System.out.println("Atividades Disponíveis: " + atividadeDesportiva.getAtividadesDisponiveis());
        System.out.println("Espaços onde as Atividades ocorrem: ");
    
        List<EspacoAssociacao> espacosAtividades = atividadeDesportiva.getEspacosAtividades();
        if (espacosAtividades != null) {
            for (EspacoAssociacao espaco : espacosAtividades) {
                System.out.println("Identificação: " + espaco.getIdentificacao());
                if (espaco.getResponsavelAtividade() != null) {
                    System.out.println("Responsável: " + espaco.getResponsavelAtividade().getNome());
                } else {
                    System.out.println("Responsável: Não especificado");
                }
            }
        } else {
            System.out.println("Nenhum espaço de atividade especificado.");
        }
    }
    

    public static void apresentarInformacoesCampeonato(Campeonato campeonato) {
        System.out.println("Nome da Atividade: " + campeonato.getNomeAtividade());
        System.out.println("Data de Início: " + campeonato.getDataInicio());
        System.out.println("Data de Fim: " + campeonato.getDataFim());
        System.out.println("Equipas Participantes: ");
        for (Equipe equipe : campeonato.getEquipesParticipantes()) {
            System.out.println("Nome da Equipe: " + equipe.getNome());
            System.out.println("Mascote da Equipe: " + equipe.getMascote());
            System.out.println("Tamanho da Equipe: " + equipe.getTamanho());
        }
    
        List<Partida> partidas = campeonato.getPartidas();
        if (partidas != null) {
            System.out.println("Partidas: ");
            for (Partida partida : partidas) {
                System.out.println("Número da Partida: " + partida.getNumeroPartida());
                System.out.println("Equipas Participantes: ");
                for (Equipe equipe : partida.getEquipesParticipantes()) {
                    System.out.println("Nome da Equipe: " + equipe.getNome());
                }
            }
        } else {
            System.out.println("Nenhuma partida registrada para este campeonato.");
        }
    }
    
    public static void apresentarInformacoesCampeonatoFutsal(CampeonatoFutsal campeonatoFutsal) {
        System.out.println("Nome da Atividade: " + campeonatoFutsal.getNomeAtividade());
        System.out.println("Data de Início: " + campeonatoFutsal.getDataInicio());
        System.out.println("Data de Fim: " + campeonatoFutsal.getDataFim());
        System.out.println("Necessidade de Equipe de Arbitragem: " + campeonatoFutsal.isNecessidadeEquipeArbitragem());
        System.out.println("Equipe de Arbitragem: ");
        for (Associado arbitro : campeonatoFutsal.getEquipeArbitragem()) {
            System.out.println("Nome do Árbitro: " + arbitro.getNome());
        }
    }
}
