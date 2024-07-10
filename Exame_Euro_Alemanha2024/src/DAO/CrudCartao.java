package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import conexao.Conexao;
import entidade.Cartao;

public class CrudCartao {
    public void adicionarCartoes(Cartao cartoes) {
        String sqlInsert = "INSERT INTO gols(jogo_id, jogador_id, minuto, tipo) VALUES(?, ?, ?, ?)";
        Conexao conexao = new Conexao();
        try (Connection con = conexao.getConexao();
             PreparedStatement ps = con.prepareStatement(sqlInsert)) {
            ps.setInt(1, cartoes.getJogoId());
            ps.setInt(2, cartoes.getJogadorId());
            ps.setInt(3, cartoes.getMinuto());
            ps.setString(4, cartoes.getTipo());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
  