package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.ArrayList;
import conexao.Conexao;
import entidade.*;
 
public class CrudJogo {
     
    // Método para adicionar um jogo
	public int adicionarJogoERetornarId(Jogo jogo) {
        String sqlInsert = "INSERT INTO jogos(calendario_id, equipe1_id, equipe2_id, gols_equipe1, gols_equipe2, fase) VALUES(?, ?, ?, ?, ?, ?)";
        Conexao conexao = new Conexao();
        try (Connection con = conexao.getConexao();
             PreparedStatement ps = con.prepareStatement(sqlInsert, PreparedStatement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, jogo.getCalendarioId());
            ps.setInt(2, jogo.getEquipe1Id());
            ps.setInt(3, jogo.getEquipe2Id());
            ps.setInt(4, jogo.getGolsEquipe1());
            ps.setInt(5, jogo.getGolsEquipe2()); 
            ps.setString(6, jogo.getFase());
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1); // Retorna o jogo_id gerado
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1; // Retorna -1 em caso de falha
    }
    // Método para obter o último ID inserido
    public int obterUltimoIdInserido() {
        String sqlSelect = "SELECT MAX(id) AS max_id FROM jogos";
        Conexao conexao = new Conexao();
        try (Connection con = conexao.getConexao();
             PreparedStatement ps = con.prepareStatement(sqlSelect)) {
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("max_id");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return -1; // Retorna -1 se não encontrar nenhum ID
    }
    
    public Jogo consultarPorId(int idJogo) {
        String sqlSelect = "SELECT * FROM jogos WHERE id = ?";
        Conexao conexao = new Conexao();
        try (Connection con = conexao.getConexao();
             PreparedStatement ps = con.prepareStatement(sqlSelect)) {
            
            ps.setInt(1, idJogo);
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int calendarioId = rs.getInt("calendario_id");
                int equipe1Id = rs.getInt("equipe1_id");
                int equipe2Id = rs.getInt("equipe2_id");
                int golsEquipe1 = rs.getInt("gols_equipe1");
                int golsEquipe2 = rs.getInt("gols_equipe2");
                String fase = rs.getString("fase");
                
                List<Selecao> equipes = obterEquipesDoJogo(idJogo);
                List<Gol> gols = obterGolsDoJogo(idJogo);
                List<Cartao> cartoes = obterCartoesDoJogo(idJogo);
                List<EstatisticasEquipe> estatisticasEquipe = obterEstatisticasEquipeDoJogo(idJogo);
                List<EstatisticasJogador> estatisticasJogadores = obterEstatisticasJogadorDoJogo(idJogo);
                List<Substituicao> substituicoes = obterSubstituicoesDoJogo(idJogo);
                
                return new Jogo(idJogo, calendarioId, equipe1Id, equipe2Id, golsEquipe1, golsEquipe2, fase,
                                equipes, gols, cartoes, estatisticasEquipe, estatisticasJogadores, substituicoes);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null; // Retorna null se não encontrar o jogo
    }
    
    public List<Selecao> obterEquipesDoJogo(int jogoId) {
        List<Selecao> equipes = new ArrayList<>();
        String sqlSelect = "SELECT s.*, c.grupo_id " +
                           "FROM selecoes s " +
                           "INNER JOIN jogos j ON s.id = j.equipe1_id OR s.id = j.equipe2_id " +
                           "LEFT JOIN classificacoes c ON s.id = c.selecao_id AND j.id = c.jogo_id " +
                           "WHERE j.id = ?";
        Conexao conexao = new Conexao();
        try (Connection con = conexao.getConexao();
             PreparedStatement ps = con.prepareStatement(sqlSelect)) {
            
            ps.setInt(1, jogoId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                int id = rs.getInt("id");
                String nome = rs.getString("nome");
                int paisId = rs.getInt("pais_id");
                int grupoId = rs.getInt("grupo_id");
                
                Selecao selecao = new Selecao(id, nome, paisId, grupoId); // Inclui o grupoId na criação da Selecao
                equipes.add(selecao);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return equipes;
    }

    
    public List<Gol> obterGolsDoJogo(int jogoId) {
        List<Gol> gols = new ArrayList<>();
        String sqlSelect = "SELECT * FROM gols WHERE jogo_id = ?";
        Conexao conexao = new Conexao();
        try (Connection con = conexao.getConexao();
             PreparedStatement ps = con.prepareStatement(sqlSelect)) {
            
            ps.setInt(1, jogoId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                int id = rs.getInt("id");
                int jogadorId = rs.getInt("jogador_id");
                int minuto = rs.getInt("minuto");
                String tipo = rs.getString("tipo");
                
                Gol gol = new Gol(id, jogoId, jogadorId, minuto, tipo);
                gols.add(gol);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return gols;
    }
    
    public List<Cartao> obterCartoesDoJogo(int jogoId) {
        List<Cartao> cartoes = new ArrayList<>();
        String sqlSelect = "SELECT * FROM cartoes WHERE jogo_id = ?";
        Conexao conexao = new Conexao();
        try (Connection con = conexao.getConexao();
             PreparedStatement ps = con.prepareStatement(sqlSelect)) {
            
            ps.setInt(1, jogoId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                int id = rs.getInt("id");
                int jogadorId = rs.getInt("jogador_id");
                int minuto = rs.getInt("minuto");
                String tipo = rs.getString("tipo");
                
                Cartao cartao = new Cartao(id, jogoId, jogadorId, minuto, tipo);
                cartoes.add(cartao);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return cartoes;
    }
    
    public List<EstatisticasEquipe> obterEstatisticasEquipeDoJogo(int jogoId) {
        List<EstatisticasEquipe> estatisticasEquipe = new ArrayList<>();
        String sqlSelect = "SELECT * FROM estatisticas_equipe WHERE jogo_id = ?";
        Conexao conexao = new Conexao();
        try (Connection con = conexao.getConexao();
             PreparedStatement ps = con.prepareStatement(sqlSelect)) {
            
            ps.setInt(1, jogoId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                int id = rs.getInt("id");
                int selecaoId = rs.getInt("selecao_id");
                int remates = rs.getInt("remates");
                int livres = rs.getInt("livres");
                int forasDeJogo = rs.getInt("foras_de_jogo");
                
                EstatisticasEquipe estatistica = new EstatisticasEquipe(id, jogoId, selecaoId, remates, livres, forasDeJogo);
                estatisticasEquipe.add(estatistica);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return estatisticasEquipe;
    }
    
    public List<Substituicao> obterSubstituicoesDoJogo(int jogoId) {
        List<Substituicao> substituicoes = new ArrayList<>();
        String sqlSelect = "SELECT * FROM substituicoes WHERE jogo_id = ?";
        Conexao conexao = new Conexao();
        try (Connection con = conexao.getConexao();
             PreparedStatement ps = con.prepareStatement(sqlSelect)) {
            
            ps.setInt(1, jogoId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                int id = rs.getInt("id");
                int jogadorSaiuId = rs.getInt("jogador_saiu_id");
                int jogadorEntrouId = rs.getInt("jogador_entrou_id");
                int minuto = rs.getInt("minuto");
                
                Substituicao substituicao = new Substituicao(id, jogoId, jogadorSaiuId, jogadorEntrouId, minuto);
                substituicoes.add(substituicao);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
         }
         
         return substituicoes;
     }
    
    public List<EstatisticasJogador> obterEstatisticasJogadorDoJogo(int jogoId) {
        List<EstatisticasJogador> estatisticasJogadores = new ArrayList<>();
        String sqlSelect = "SELECT * FROM estatisticas_jogador WHERE jogo_id = ?";
        Conexao conexao = new Conexao();
        try (Connection con = conexao.getConexao();
             PreparedStatement ps = con.prepareStatement(sqlSelect)) {
            
            ps.setInt(1, jogoId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                int id = rs.getInt("id");
                int jogadorId = rs.getInt("jogador_id");
                int passes = rs.getInt("passes");
                int assistencias = rs.getInt("assistencias");
                int remates = rs.getInt("remates");
                int minutosJogados = rs.getInt("minutos_jogados");
                
                EstatisticasJogador estatistica = new EstatisticasJogador(id, jogoId, jogadorId, passes, assistencias, remates, minutosJogados);
                estatisticasJogadores.add(estatistica);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return estatisticasJogadores;
    }
    
    public void consultarJogos() {
        String sqlSelect = "SELECT * FROM jogos";
        Conexao conexao = new Conexao();
        try (Connection con = conexao.getConexao();
             PreparedStatement ps = con.prepareStatement(sqlSelect);
             ResultSet rs = ps.executeQuery()) {

            System.out.println("ID | CalendarioID | Equipe1ID | Equipe2ID | GolsEquipe1 | GolsEquipe2 | Fase");
            while (rs.next()) {
                int id = rs.getInt("id");
                int calendarioId = rs.getInt("calendario_id");
                int equipe1Id = rs.getInt("equipe1_id");
                int equipe2Id = rs.getInt("equipe2_id");
                int golsEquipe1 = rs.getInt("gols_equipe1");
                int golsEquipe2 = rs.getInt("gols_equipe2");
                String fase = rs.getString("fase");

                System.out.println(id + " | " + calendarioId + " | " + equipe1Id + " | " + equipe2Id + " | "
                        + golsEquipe1 + " | " + golsEquipe2 + " | " + fase);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    // Método para resetar os campos equipe1_id, equipe2_id, gols_equipe1 e gols_equipe2 na tabela jogos
    public void resetarJogo() {
        String sqlUpdate = "UPDATE jogos SET equipe1_id = NULL, equipe2_id = NULL, gols_equipe1 = 0, gols_equipe2 = 0";
        Conexao conexao = new Conexao();
        try (Connection con = conexao.getConexao();
             PreparedStatement ps = con.prepareStatement(sqlUpdate)) {

            ps.executeUpdate();
            System.out.println("Todos os campos especificados na tabela jogos foram resetados.");

        } catch (SQLException e) {
            System.out.println("Erro ao resetar campos na tabela jogos: " + e.getMessage());
        }
    }

}