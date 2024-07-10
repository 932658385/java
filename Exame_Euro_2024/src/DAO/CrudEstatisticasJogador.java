package DAO;

import conexao.Conexao;
import entidade.EstatisticasJogador;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CrudEstatisticasJogador {
    
    public void adicionarEstatisticas(List<EstatisticasJogador> estatisticas) {
        String sqlInsert = "INSERT INTO estatisticas_jogador(jogo_id, jogador_id, passes, assistencias, remates, minutos_jogados) VALUES(?, ?, ?, ?, ?, ?)";
        Conexao conexao = new Conexao();
        
        try (Connection con = conexao.getConexao();
             PreparedStatement ps = con.prepareStatement(sqlInsert)) {
            
            for (EstatisticasJogador estatistica : estatisticas) {
                ps.setInt(1, estatistica.getJogoId());
                ps.setInt(2, estatistica.getJogadorId());
                ps.setInt(3, estatistica.getPasses());
                ps.setInt(4, estatistica.getAssistencias());
                ps.setInt(5, estatistica.getRemates()); 
                ps.setInt(6, estatistica.getMinutosJogados());
                ps.executeUpdate();
            } 
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<EstatisticasJogador> consultarPorJogadorId(int jogadorId) {
        String sqlSelect = "SELECT * FROM estatisticas_jogador WHERE jogador_id = ?";
        List<EstatisticasJogador> estatisticas = new ArrayList<>();
        Conexao conexao = new Conexao();
        
        try (Connection con = conexao.getConexao();
             PreparedStatement ps = con.prepareStatement(sqlSelect)) {
            ps.setInt(1, jogadorId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                EstatisticasJogador estatistica = new EstatisticasJogador(
                        rs.getInt("id"),
                        rs.getInt("jogo_id"),
                        rs.getInt("jogador_id"),
                        rs.getInt("passes"),
                        rs.getInt("assistencias"),
                        rs.getInt("remates"),
                        rs.getInt("minutos_jogados")
                );
                estatisticas.add(estatistica);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return estatisticas;
    }
    
    public void consultarEstatisticasJogador() {
        String sqlSelect = "SELECT * FROM estatisticas_jogador";
        Conexao conexao = new Conexao();
        
        try (Connection con = conexao.getConexao();
             PreparedStatement ps = con.prepareStatement(sqlSelect)) {
            
            ResultSet rs = ps.executeQuery();
            
            // Print header
            System.out.println("ID | JogoID | JogadorID | Passes | Assistências | Remates | Minutos Jogados");
            
            // Print data
            while (rs.next()) {
                int id = rs.getInt("id");
                int jogoId = rs.getInt("jogo_id");
                int jogadorId = rs.getInt("jogador_id");
                int passes = rs.getInt("passes");
                int assistencias = rs.getInt("assistencias");
                int remates = rs.getInt("remates");
                int minutosJogados = rs.getInt("minutos_jogados");
                
                System.out.println(id + " | " + jogoId + " | " + jogadorId + " | " + passes + " | " + assistencias + " | " + remates + " | " + minutosJogados);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public void resetarEstatisticasJogador() {
        Connection con = null;
        PreparedStatement stmt = null;

        try {
            Conexao conexao = new Conexao();
            con = conexao.getConexao();
            String sql = "UPDATE estatisticas_jogador " +
                         "SET jogo_id = NULL, jogador_id = NULL, " +
                         "passes = NULL, assistencias = NULL, " +
                         "remates = NULL, minutos_jogados = NULL";
            stmt = con.prepareStatement(sql);

            int rowsUpdated = stmt.executeUpdate();
            if (rowsUpdated > 0) {
                System.out.println("Registros de estatisticas_jogador foram resetados");
            } else {
                System.out.println("Erro ao resetar estatisticas_jogador: Nenhum registro afetado.");
            }
        } catch (SQLException e) {
            System.out.println("Erro ao resetar estatisticas_jogador: " + e.getMessage());
        } finally {
            // Fechar recursos
            if (stmt != null) {
                try {
                    stmt.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (con != null) {
                try {
                    con.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
