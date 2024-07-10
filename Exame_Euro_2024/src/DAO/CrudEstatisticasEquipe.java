package DAO;

import conexao.Conexao;
import entidade.EstatisticasEquipe;
import java.util.ArrayList;
import java.util.List;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class CrudEstatisticasEquipe {
    
    public void adicionarEstatisticas(List<EstatisticasEquipe> estatisticas) {
        String sqlInsert = "INSERT INTO estatisticas_equipe(jogo_id, selecao_id, remates, livres, foras_de_jogo) VALUES(?, ?, ?, ?, ?)";
        Conexao conexao = new Conexao();
        
        try (Connection con = conexao.getConexao();
             PreparedStatement ps = con.prepareStatement(sqlInsert)) {
            
            for (EstatisticasEquipe estatistica : estatisticas) {
                ps.setInt(1, estatistica.getJogoId());
                ps.setInt(2, estatistica.getSelecaoId());
                ps.setInt(3, estatistica.getRemates());
                ps.setInt(4, estatistica.getLivres());
                ps.setInt(5, estatistica.getForasDeJogo());
                ps.executeUpdate();
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        } 
    }

    public List<EstatisticasEquipe> consultarPorSelecaoId(int selecaoId) {
        String sqlSelect = "SELECT * FROM estatisticas_equipe WHERE selecao_id = ?";
        List<EstatisticasEquipe> estatisticas = new ArrayList<>();
        Conexao conexao = new Conexao();
        
        try (Connection con = conexao.getConexao();
             PreparedStatement ps = con.prepareStatement(sqlSelect)) {
            ps.setInt(1, selecaoId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                EstatisticasEquipe estatistica = new EstatisticasEquipe(
                        rs.getInt("id"),
                        rs.getInt("jogo_id"),
                        rs.getInt("selecao_id"),
                        rs.getInt("remates"),
                        rs.getInt("livres"),
                        rs.getInt("foras_de_jogo")
                );
                estatisticas.add(estatistica);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return estatisticas;
    }
    
    public List<EstatisticasEquipe> consultarEstatisticasEquipe() {
        String sqlSelect = "SELECT * FROM estatisticas_equipe";
        List<EstatisticasEquipe> estatisticas = new ArrayList<>();
        Conexao conexao = new Conexao();
        
        try (Connection con = conexao.getConexao();
             PreparedStatement ps = con.prepareStatement(sqlSelect)) {
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                EstatisticasEquipe estatistica = new EstatisticasEquipe(
                        rs.getInt("id"),
                        rs.getInt("jogo_id"),
                        rs.getInt("selecao_id"),
                        rs.getInt("remates"),
                        rs.getInt("livres"),
                        rs.getInt("foras_de_jogo")
                );
                estatisticas.add(estatistica);
                
                // Exibindo os resultados
                System.out.println("ID: " + estatistica.getId() +
                                   ", Jogo ID: " + estatistica.getJogoId() +
                                   ", Seleção ID: " + estatistica.getSelecaoId() +
                                   ", Remates: " + estatistica.getRemates() +
                                   ", Livres: " + estatistica.getLivres() +
                                   ", Foras de Jogo: " + estatistica.getForasDeJogo());
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return estatisticas;
    }
    
    public void resetarEstatisticasEquipe() {
        String sqlUpdate = "UPDATE estatisticas_equipe SET jogo_id = NULL, selecao_id = NULL, " +
                           "remates = NULL, livres = NULL, foras_de_jogo = NULL";
        Conexao conexao = new Conexao();

        try (Connection con = conexao.getConexao();
             PreparedStatement ps = con.prepareStatement(sqlUpdate)) {

            int rowsUpdated = ps.executeUpdate();
            System.out.println(rowsUpdated + " registros de estatisticas_equipe foram resetados.");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

}
