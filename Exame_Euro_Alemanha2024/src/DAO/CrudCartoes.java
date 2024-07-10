package DAO;

import conexao.Conexao;
import entidade.Cartao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class CrudCartoes {
    public void adicionarCartoes(List<Cartao> cartoes) {
        String sqlInsert = "INSERT INTO cartoes(jogo_id, jogador_id, minuto, tipo) VALUES(?, ?, ?, ?)";
        Conexao conexao = new Conexao();
        try (Connection con = conexao.getConexao();
             PreparedStatement ps = con.prepareStatement(sqlInsert)) {
            for (Cartao cartao : cartoes) {
                ps.setInt(1, cartao.getJogoId());
                ps.setInt(2, cartao.getJogadorId());
                ps.setInt(3, cartao.getMinuto());
                ps.setString(4, cartao.getTipo());
                ps.executeUpdate();
            }
        } catch (SQLException e) { 
            e.printStackTrace();
        }
    }
    
    public void consultarCartoes() {
        Connection con = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            Conexao conexao = new Conexao();
            con = conexao.getConexao();
            String sql = "SELECT * FROM cartoes";
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
            System.out.println("Erro ao consultar cartoes: " + e.getMessage());
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
    
    public void resetarCartoes() {
        Connection con = null;
        PreparedStatement stmt = null;

        try {
            Conexao conexao = new Conexao();
            con = conexao.getConexao();
            String sql = "UPDATE cartoes SET jogo_id = NULL, jogador_id = NULL, minuto = NULL, tipo = ''";
            stmt = con.prepareStatement(sql);

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Cartões resetados com sucesso.");
            } else {
                System.out.println("Erro ao resetar cartões.");
            }
        } catch (SQLException e) {
            System.out.println("Erro ao resetar cartões: " + e.getMessage());
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