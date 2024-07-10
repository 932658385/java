package DAO;

import conexao.Conexao;
import entidade.Substituicao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

public class CrudSubstituicoes {
    public void adicionarSubstituicoes(List<Substituicao> substituicoes) {
        String sqlInsert = "INSERT INTO substituicoes(jogo_id, jogador_saiu_id, jogador_entrou_id, minuto) VALUES(?, ?, ?, ?)";
        Conexao conexao = new Conexao();
        try (Connection con = conexao.getConexao();
             PreparedStatement ps = con.prepareStatement(sqlInsert)) {
            for (Substituicao substituicao : substituicoes) {
                ps.setInt(1, substituicao.getJogoId());
                ps.setInt(2, substituicao.getJogadorSaiuId());
                ps.setInt(3, substituicao.getJogadorEntrouId());
                ps.setInt(4, substituicao.getMinuto());
                ps.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}