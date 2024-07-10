package DAO;

import conexao.Conexao;
import entidade.Grupo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CrudGrupo {

    // Método para listar todos os grupos
    public List<Grupo> listarGrupos() {
        List<Grupo> grupos = new ArrayList<>();
        String sqlSelect = "SELECT id, nome FROM grupos";
        Conexao conexao = new Conexao();
        try (Connection con = conexao.getConexao();
             PreparedStatement ps = con.prepareStatement(sqlSelect);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                int id = rs.getInt("id");
                String nome = rs.getString("nome");
                Grupo grupo = new Grupo(id, nome);
                grupos.add(grupo);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return grupos; 
    }
}