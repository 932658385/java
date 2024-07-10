package DAO;

import conexao.Conexao;
import entidade.Selecao;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CrudSelecao {

    
    public void adicionarSelecao(Selecao selecao) {
        String sqlInsert = "INSERT INTO selecoes(nome, pais_id) VALUES(?, ?)";
        String sqlCheckPais = "SELECT id FROM paises WHERE id = ?";
        PreparedStatement ps = null;
        Connection con = null;
 
        try {
            
            Conexao conexao = new Conexao();
            con = conexao.getConexao();

            if (con != null) {
                // Verificar se o pais_id existe na tabela paises
                try (PreparedStatement psCheckPais = con.prepareStatement(sqlCheckPais)) {
                    psCheckPais.setInt(1, selecao.getPaisId());
                    ResultSet rs = psCheckPais.executeQuery();

                    if (rs.next()) {
                        // Se o pais_id existir, insira o registro na tabela selecoes
                        ps = con.prepareStatement(sqlInsert);
                        ps.setString(1, selecao.getNome());
                        ps.setInt(2, selecao.getPaisId());
                        int rowsAffected = ps.executeUpdate();

                        if (rowsAffected > 0) {
                            System.out.println("Seleção adicionada com sucesso!");
                        } else {
                            System.out.println("Falha ao adicionar a seleção.");
                        }
                    } else {
                        System.out.println("Erro: pais_id " + selecao.getPaisId() + " não existe na tabela paises.");
                    }
                }
            } else {
                System.out.println("Falha na conexão com o banco de dados.");
            }
        } catch(SQLException e) {
            e.printStackTrace();
        } finally {
            // Fechamento seguro do PreparedStatement e da Connection
            try {
                if (ps != null) {
                    ps.close();
                }
                if (con != null) {
                    con.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public void consultarPorNome(String nomeSelecao) {
        String sqlSelect = "SELECT s.id, s.nome, s.pais_id, c.grupo_id " +
                           "FROM selecoes s " +
                           "JOIN classificacoes c ON s.id = c.selecao_id " +
                           "WHERE s.nome LIKE ?";
        
        PreparedStatement ps = null;
        Connection con = null;

        try {
            Conexao conexao = new Conexao();
            con = conexao.getConexao();

            if (con != null) {
                ps = con.prepareStatement(sqlSelect);
                ps.setString(1, "%" + nomeSelecao + "%");

                ResultSet rs = ps.executeQuery();

                while (rs.next()) {
                    int id = rs.getInt("id");
                    String nome = rs.getString("nome");
                    int paisId = rs.getInt("pais_id");
                    int grupoId = rs.getInt("grupo_id");

                    Selecao selecao = new Selecao(id, nome, paisId, grupoId); // Inclui o grupoId na criação da Selecao
                    System.out.println(selecao.toString()); // Ou outro processamento desejado
                }

            } else {
                System.out.println("Falha na conexão com o banco de dados.");
            }
        } catch(SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) {
                    ps.close();
                }
                if (con != null) {
                    con.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public void deletarSelecao(int idSelecao) {
        String sqlDelete = "DELETE FROM selecoes WHERE id = ?";
        PreparedStatement ps = null;
        Connection con = null;

        try {
            // Cria uma instância de Conexao e obtém a conexão
            Conexao conexao = new Conexao();
            con = conexao.getConexao();

            if (con != null) {
                // Prepara o PreparedStatement para execução do delete
                ps = con.prepareStatement(sqlDelete);
                ps.setInt(1, idSelecao);

                // Executa o comando de delete
                int rowsAffected = ps.executeUpdate();

                if (rowsAffected > 0) {
                    System.out.println("Seleção deletada com sucesso!");
                } else {
                    System.out.println("Não foi possível encontrar a seleção com o ID fornecido.");
                }

            } else {
                System.out.println("Falha na conexão com o banco de dados.");
            }
        } catch(SQLException e) {
            e.printStackTrace();
        } finally {
            // Fechamento seguro do PreparedStatement e da Connection
            try {
                if (ps != null) {
                    ps.close();
                }
                if (con != null) {
                    con.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public void atualizarSelecao(Selecao selecao) {
        String sqlUpdate = "UPDATE selecoes SET nome = ?, pais_id = ? WHERE id = ?";
        PreparedStatement ps = null;
        Connection con = null;

        try {
            // Cria uma instância de Conexao e obtém a conexão
            Conexao conexao = new Conexao();
            con = conexao.getConexao();

            if (con != null) {
                // Prepara o PreparedStatement para execução do update
                ps = con.prepareStatement(sqlUpdate);
                ps.setString(1, selecao.getNome());
                ps.setInt(2, selecao.getPaisId());
                ps.setInt(3, selecao.getId());

                // Executa o comando de update
                int rowsAffected = ps.executeUpdate();

                if (rowsAffected > 0) {
                    System.out.println("Seleção atualizada com sucesso!");
                } else {
                    System.out.println("Não foi possível encontrar a seleção com o ID fornecido.");
                }

            } else {
                System.out.println("Falha na conexão com o banco de dados.");
            }
        } catch(SQLException e) {
            e.printStackTrace();
        } finally {
            // Fechamento seguro do PreparedStatement e da Connection
            try {
                if (ps != null) {
                    ps.close();
                }
                if (con != null) {
                    con.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    public List<Selecao> consultarPorGrupo(int grupoId) {
        List<Selecao> selecoes = new ArrayList<>();
        String sql = "SELECT s.id, s.nome, s.pais_id " +
                     "FROM selecoes s " +
                     "INNER JOIN grupos g ON s.id = g.selecao_id " +
                     "WHERE g.id = ?";
        Conexao conexao = new Conexao();
        try (Connection con = conexao.getConexao();
             PreparedStatement stmt = con.prepareStatement(sql)) {

            stmt.setInt(1, grupoId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Selecao selecao = new Selecao();
                selecao.setId(rs.getInt("id"));
                selecao.setNome(rs.getString("nome"));
                selecao.setPaisId(rs.getInt("pais_id"));
                selecoes.add(selecao);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return selecoes;
    }
}