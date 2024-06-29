package entidade;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.Random;
import conexao.Conexao;
import DAO.*;

public class Simulacao {
    private CrudJogo crudJogo;
    private CrudEstatisticasEquipe crudEstatisticasEquipe;
    private CrudEstatisticasJogador crudEstatisticasJogador;
    private CrudSubstituicoes crudSubstituicoes;
    private CrudGols crudGols;
    private CrudCartoes crudCartoes;
    private CrudClassificacao crudClassificacao;

    public Simulacao() {
        crudJogo = new CrudJogo();
        crudEstatisticasEquipe = new CrudEstatisticasEquipe();
        crudEstatisticasJogador = new CrudEstatisticasJogador();
        crudSubstituicoes = new CrudSubstituicoes();
        crudGols = new CrudGols();
        crudCartoes = new CrudCartoes();
        crudClassificacao = new CrudClassificacao();
    }

    public void simularFaseDeGrupos() {
        List<Grupo> grupos = obterGrupos();

        for (Grupo grupo : grupos) {
            List<Selecao> selecoes = obterSelecoesDoGrupo(grupo.getId());
            for (int i = 0; i < selecoes.size(); i++) {
                for (int j = i + 1; j < selecoes.size(); j++) {
                    Jogo jogo = simularERegistrarJogo(selecoes.get(i), selecoes.get(j), "Grupo");
                    System.out.println(String.format("%s %d x %d %s",
                            selecoes.get(i).getNome(), jogo.getGolsEquipe1(),
                            jogo.getGolsEquipe2(), selecoes.get(j).getNome()));
                    atualizarClassificacoes(selecoes.get(i), selecoes.get(j), jogo.getGolsEquipe1(), jogo.getGolsEquipe2());
                }
            }
        }
    }
    
    public void atualizarClassificacoes(Selecao equipe1, Selecao equipe2, int golsEquipe1, int golsEquipe2) {
        int pontosEquipe1 = calcularPontos(golsEquipe1, golsEquipe2);
        int pontosEquipe2 = calcularPontos(golsEquipe2, golsEquipe1);
        int saldoGolsEquipe1 = golsEquipe1 - golsEquipe2;
        int saldoGolsEquipe2 = golsEquipe2 - golsEquipe1;

        crudClassificacao.atualizarEstatisticas(equipe1.getGrupoId(), equipe1.getId(), pontosEquipe1, golsEquipe1, golsEquipe2, saldoGolsEquipe1);
        crudClassificacao.atualizarEstatisticas(equipe2.getGrupoId(), equipe2.getId(), pontosEquipe2, golsEquipe2, golsEquipe1, saldoGolsEquipe2);
    }

    private int calcularPontos(int golsMarcados, int golsSofridos) {
        if (golsMarcados > golsSofridos) {
            return 3; // Vitória
        } else if (golsMarcados == golsSofridos) {
            return 1; // Empate
        } else {
            return 0; // Derrota
        }
    }


    public List<Grupo> obterGrupos() {
        List<Grupo> grupos = new ArrayList<>();
        String sqlSelect = "SELECT id, nome FROM grupos";
        Conexao conexao = new Conexao();
        try (Connection con = conexao.getConexao();
             PreparedStatement ps = con.prepareStatement(sqlSelect);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                grupos.add(new Grupo(rs.getInt("id"), rs.getString("nome")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return grupos;
    }

    public List<Selecao> obterSelecoesDoGrupo(int grupoId) {
        List<Selecao> selecoes = new ArrayList<>();
        String sqlSelect = "SELECT s.id, s.nome, s.pais_id " +
                           "FROM selecoes s " +
                           "JOIN classificacoes c ON s.id = c.selecao_id " +
                           "WHERE c.grupo_id = ?";
        
        Conexao conexao = new Conexao();
        try (Connection con = conexao.getConexao();
             PreparedStatement ps = con.prepareStatement(sqlSelect)) {
            
            ps.setInt(1, grupoId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int id = rs.getInt("id");
                    String nome = rs.getString("nome");
                    int paisId = rs.getInt("pais_id");
                    
                    Selecao selecao = new Selecao(id, nome, paisId, grupoId); // Adiciona o grupoId aqui
                    selecoes.add(selecao);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return selecoes;
    }
    
    private List<Selecao> obterClassificadosDoGrupo(int grupoId) {
        List<Selecao> classificados = new ArrayList<>();

        String sql = "SELECT s.id, s.nome, s.pais_id, c.pontos, c.saldo_gols, c.grupo_id " +
                     "FROM classificacoes c " +
                     "JOIN selecoes s ON c.selecao_id = s.id " +
                     "WHERE c.grupo_id = ? " +
                     "ORDER BY c.pontos DESC, c.saldo_gols DESC " +
                     "LIMIT 2";  

        Conexao conexao = new Conexao();

        try (Connection con = conexao.getConexao();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, grupoId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Selecao selecao = new Selecao(
                    rs.getInt("id"),
                    rs.getString("nome"),
                    rs.getInt("pais_id"),
                    rs.getInt("pontos"),
                    rs.getInt("saldo_gols"),
                    rs.getInt("grupo_id")
                );
                classificados.add(selecao);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return classificados;
    } 
    
    public List<Selecao> obterSelecoesClassificadasParaQuartas() {
        List<Selecao> todasClassificadas = new ArrayList<>();
        
        for (int grupoId = 5; grupoId <= 8; grupoId++) {
            List<Selecao> classificadosDoGrupo = obterClassificadosDoGrupo(grupoId);
            todasClassificadas.addAll(classificadosDoGrupo);
        }
        
        return todasClassificadas;
    }

    public List<Selecao> simularQuartas(List<Selecao> selecoesClassificadasParaQuartas) {
        List<Selecao> vencedoresQuartas = new ArrayList<>();

        if (selecoesClassificadasParaQuartas.size() < 8) {
            throw new IllegalArgumentException("Número insuficiente de seleções classificadas para as quartas de final");
        }

        // Lógica para simular os jogos das quartas de final
        for (int i = 0; i < selecoesClassificadasParaQuartas.size(); i += 2) {
            Selecao selecao1 = selecoesClassificadasParaQuartas.get(i);
            Selecao selecao2 = selecoesClassificadasParaQuartas.get(i + 1);

          
            Jogo jogo = simularERegistrarJogo(selecao1, selecao2, "Quartas");

            // Determinação do vencedor e adição à lista de vencedores
            if (jogo.getGolsEquipe1() > jogo.getGolsEquipe2()) {
                vencedoresQuartas.add(selecao1);
            } else {
                vencedoresQuartas.add(selecao2);
            }

            System.out.println(String.format("Jogo das Quartas: %s %d x %d %s",
                    selecao1.getNome(), jogo.getGolsEquipe1(),
                    jogo.getGolsEquipe2(), selecao2.getNome()));
        }

        return vencedoresQuartas;
    }

    public List<Selecao> simularSemifinais(List<Selecao> vencedoresQuartas) {
        if (vencedoresQuartas.size() != 4) {
            throw new IllegalArgumentException("Número insuficiente de seleções classificadas para as semifinais");
        }

        List<Selecao> vencedoresSemifinais = new ArrayList<>();

        for (int i = 0; i < vencedoresQuartas.size(); i += 2) {
            Selecao vencedor = simularJogo(vencedoresQuartas.get(i), vencedoresQuartas.get(i + 1));
            vencedoresSemifinais.add(vencedor);
        }

        return vencedoresSemifinais;
    }

    public Selecao simularFinal(List<Selecao> vencedoresSemifinais) {
        if (vencedoresSemifinais.size() != 2) {
            throw new IllegalArgumentException("Número insuficiente de seleções classificadas para a final");
        }

        // Simulando o jogo final (1 jogo)
        return simularJogo(vencedoresSemifinais.get(0), vencedoresSemifinais.get(1));
    }
    
    private Selecao simularJogo(Selecao selecao1, Selecao selecao2) {
        int gols1 = (int) (Math.random() * 3);
        int gols2 = (int) (Math.random() * 3);

        System.out.println("Jogo: " + selecao1.getNome() + " " + gols1 + " x " + gols2 + " " + selecao2.getNome());

        if (gols1 > gols2) {
            return selecao1;
        } else if (gols2 > gols1) {
            return selecao2;
        } else {
           
            if (selecao1.getSaldoGols() > selecao2.getSaldoGols()) {
                return selecao1;
            } else {
                return selecao2;
            }
        }
    }

    public void exibirVencedor(Selecao vencedor) {
    	System.out.println("|***************************************************|");
        System.out.println("|O vencedor do torneio é: " + vencedor.getNome());
        System.out.println("|***************************************************|");
    }

    
    public Jogo simularERegistrarJogo(Selecao equipe1, Selecao equipe2, String fase) {
        Random random = new Random();
        int golsEquipe1 = random.nextInt(5);
        int golsEquipe2 = random.nextInt(5);

        List<Selecao> equipes = new LinkedList<>();
        equipes.add(equipe1);
        equipes.add(equipe2);

        List<Gol> gols = new LinkedList<>();
        List<Cartao> cartoes = new LinkedList<>();
        List<EstatisticasEquipe> estatisticasEquipe = new LinkedList<>();
        List<EstatisticasJogador> estatisticasJogadores = new LinkedList<>();
        List<Substituicao> substituicoes = new LinkedList<>();

        // Obter um calendario_id válido a partir do grupo_id da equipe1
        int grupoId = equipe1.getGrupoId(); 
        int calendarioId = obterCalendarioIdParaGrupo(grupoId);

        Jogo jogo = new Jogo(0, calendarioId, equipe1.getId(), equipe2.getId(), golsEquipe1, golsEquipe2, fase,
                equipes, gols, cartoes, estatisticasEquipe, estatisticasJogadores, substituicoes);

        int jogoId = crudJogo.adicionarJogoERetornarId(jogo);
        jogo.setId(jogoId);

        List<Jogador> jogadoresEquipe1 = obterJogadoresPorSelecao(equipe1.getId());
        List<Jogador> jogadoresEquipe2 = obterJogadoresPorSelecao(equipe2.getId());

        // Registro de gols
        for (int i = 0; i < golsEquipe1; i++) {
            int minuto = random.nextInt(90) + 1; 
            Jogador jogador = jogadoresEquipe1.get(random.nextInt(jogadoresEquipe1.size()));
            Gol gol = new Gol(0, jogoId, jogador.getId(), minuto, "Gol");
            gols.add(gol);
        }

        for (int i = 0; i < golsEquipe2; i++) {
            int minuto = random.nextInt(90) + 1; 
            Jogador jogador = jogadoresEquipe2.get(random.nextInt(jogadoresEquipe2.size()));
            Gol gol = new Gol(0, jogoId, jogador.getId(), minuto, "Gol");
            gols.add(gol);
        }

        // Registro de cartões e estatísticas (simulado)
        for (Selecao equipe : equipes) {
            List<Jogador> jogadoresEquipe = obterJogadoresPorSelecao(equipe.getId());
            for (Jogador jogador : jogadoresEquipe) {
                int cartoesAmarelos = random.nextInt(2);
                int cartoesVermelhos = random.nextInt(1); 
                int passes = random.nextInt(100); 
                int assistencias = random.nextInt(3); 
                int remates = random.nextInt(20); 
                int minutosJogados = random.nextInt(90); 

                for (int j = 0; j < cartoesAmarelos; j++) {
                    int minuto = random.nextInt(90) + 1; 
                    Cartao cartaoAmarelo = new Cartao(0, jogoId, jogador.getId(), minuto, "Amarelo");
                    cartoes.add(cartaoAmarelo);
                }

                for (int j = 0; j < cartoesVermelhos; j++) {
                    int minuto = random.nextInt(90) + 1; 
                    Cartao cartaoVermelho = new Cartao(0, jogoId, jogador.getId(), minuto, "Vermelho");
                    cartoes.add(cartaoVermelho);
                }

                EstatisticasJogador estatisticas = new EstatisticasJogador(0, jogoId, jogador.getId(), passes, assistencias, remates, minutosJogados);
                estatisticasJogadores.add(estatisticas);
            }

            EstatisticasEquipe estatisticasEquipeObj = new EstatisticasEquipe(0, jogoId, equipe.getId(), random.nextInt(20), random.nextInt(10), random.nextInt(5));
            estatisticasEquipe.add(estatisticasEquipeObj);

            // Registro de substituições (simulado)
            List<Jogador> jogadoresEquipeAtual = obterJogadoresPorSelecao(equipe.getId());
            for (int i = 0; i < 3; i++) { // Supondo 3 substituições por equipe
                Jogador jogadorSai = jogadoresEquipeAtual.get(random.nextInt(jogadoresEquipeAtual.size()));
                Jogador jogadorEntra = jogadoresEquipeAtual.get(random.nextInt(jogadoresEquipeAtual.size()));
                Substituicao substituicao = new Substituicao(0, jogoId, jogadorSai.getId(), jogadorEntra.getId(), random.nextInt(90) + 1);
                substituicoes.add(substituicao);
            }
        }

        crudGols.adicionarGols(gols);
        crudCartoes.adicionarCartoes(cartoes);
        crudEstatisticasEquipe.adicionarEstatisticas(estatisticasEquipe);
        crudEstatisticasJogador.adicionarEstatisticas(estatisticasJogadores);
        crudSubstituicoes.adicionarSubstituicoes(substituicoes);

        return jogo;
    }

    
    private int obterCalendarioIdParaGrupo(int grupoId) {
        String sql = "SELECT id FROM calendario WHERE grupo_id = ? LIMIT 1";
        Conexao conexao = new Conexao();
        try (Connection con = conexao.getConexao();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, grupoId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        throw new IllegalStateException("Nenhum calendário encontrado para o grupo " + grupoId);
    }

    private List<Jogador> obterJogadoresPorSelecao(int selecaoId) {
        List<Jogador> jogadores = new LinkedList<>();
        String sqlSelect = "SELECT id, nome, posicao, selecao_id FROM jogadores WHERE selecao_id = ?";
        try (Connection con = new Conexao().getConexao();
             PreparedStatement ps = con.prepareStatement(sqlSelect)) {
            ps.setInt(1, selecaoId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Jogador jogador = new Jogador(
                            rs.getInt("id"),
                            rs.getString("nome"),
                            rs.getString("posicao"),
                            rs.getInt("selecao_id")
                    );
                    jogadores.add(jogador);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return jogadores;
    }
}