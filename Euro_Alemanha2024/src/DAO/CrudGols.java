package DAO;

import conexao.Conexao;
import entidade.Gol;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
 
public class CrudGols {
    public void adicionarGols(List<Gol> gols) {
        String sqlInsert = "INSERT INTO gols(jogo_id, jogador_id, minuto, tipo) VALUES (?, ?, ?, ?)";
        Conexao conexao = new Conexao();
        try (Connection con = conexao.getConexao();
             PreparedStatement ps = con.prepareStatement(sqlInsert)) {
 
            for (Gol gol : gols) {
                // Verifica se o jogo_id existe na tabela Jogos
                if (!existeJogoId(gol.getJogoId(), con)) {
                    System.err.println("Erro: Jogo com ID " + gol.getJogoId() + " não encontrado na tabela Jogos.");
                    continue; // Pula para o próximo gol se o jogo não existir
                }

                ps.setInt(1, gol.getJogoId());
                ps.setInt(2, gol.getJogadorId());
                ps.setInt(3, gol.getMinuto());
                ps.setString(4, gol.getTipo());
                ps.executeUpdate();
            }
        } catch (SQLException e) { 
            e.printStackTrace();
        }
    }

    // Método para verificar se o jogo_id existe na tabela Jogos
    private boolean existeJogoId(int jogoId, Connection con) throws SQLException {
        String sql = "SELECT id FROM jogos WHERE id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, jogoId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); // Retorna true se encontrou o jogo com o ID especificado
            }
        }
    }
    
    // Método para consultar a tabela gols
    public void consultarGols() {
        Connection con = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            Conexao conexao = new Conexao();
            con = conexao.getConexao();
            String sql = "SELECT * FROM gols";
            stmt = con.prepareStatement(sql);
            rs = stmt.executeQuery();

            System.out.println("ID | Jogo ID | Jogador ID | Minuto | Tipo");
            while (rs.next()) {
                int id = rs.getInt("id");
                int jogoId = rs.getInt("jogo_id");
                int jogadorId = rs.getInt("jogador_id");
                int minuto = rs.getInt("minuto");
                String tipo = rs.getString("tipo");

                System.out.println(id + " | " + jogoId + " | " + jogadorId + " | " + minuto + " | " + tipo);
            }

        } catch (SQLException e) {
            System.out.println("Erro ao consultar gols: " + e.getMessage());
        } finally {
            // Fechar recursos
            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
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
    
 // Método para resetar os campos da tabela gols
    public void resetarGols() {
        Connection con = null;
        PreparedStatement stmt = null;

        try {
            Conexao conexao = new Conexao();
            con = conexao.getConexao();
            String sql = "UPDATE gols SET jogo_id = NULL, jogador_id = NULL, minuto = NULL, tipo = ''";
            stmt = con.prepareStatement(sql);

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Gols resetados com sucesso.");
            } else {
                System.out.println("Erro ao resetar gols.");
            }
        } catch (SQLException e) {
            System.out.println("Erro ao resetar gols: " + e.getMessage());
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