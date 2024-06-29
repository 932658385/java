package DAO;

import conexao.Conexao;
import entidade.Estadio;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class CrudEstadio {

    public void adicionarEstadio(Estadio estadio) {
        String sqlInsert = "INSERT INTO estadios(nome, cidade_id, capacidade) VALUES(?, ?, ?)";
        PreparedStatement ps = null;
        Connection con = null; 

        try {
            Conexao conexao = new Conexao();
            con = conexao.getConexao();

            if (con != null) {
                ps = con.prepareStatement(sqlInsert);
                ps.setString(1, estadio.getNome());
                ps.setInt(2, estadio.getCidadeId());
                ps.setInt(3, estadio.getCapacidade());

                int rowsAffected = ps.executeUpdate();

                if (rowsAffected > 0) {
                    System.out.println("Estadio adicionado com sucesso!");
                } else {
                    System.out.println("Falha ao adicionar a cidade.");
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
    
    public void consultarPorNome(String nomeEstadio) {
        String sqlSelect = "SELECT id, nome, cidade_id, capacidade FROM estadios WHERE nome LIKE ?";
        PreparedStatement ps = null;
        Connection con = null;

        try {
            Conexao conexao = new Conexao();
            con = conexao.getConexao();

            if (con != null) {
                ps = con.prepareStatement(sqlSelect);
                ps.setString(1, "%" + nomeEstadio + "%");

                ResultSet rs = ps.executeQuery();

                while (rs.next()) {
                    int id = rs.getInt("id");
                    String nome = rs.getString("nome");
                    int cidade_id = rs.getInt("cidade_id");
                    int capacidade = rs.getInt("capacidade");
                    

                    Estadio estadio = new Estadio(id, nome, cidade_id, capacidade);
                    System.out.println(estadio.toString());
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
    
    public void atualizarEstadio(Estadio estadio) {
        String sqlUpdate = "UPDATE estadios SET nome = ?, cidade_id = ?, capacidade = ? WHERE id = ?";
        PreparedStatement ps = null;
        Connection con = null;

        try {
            Conexao conexao = new Conexao();
            con = conexao.getConexao();

            if (con != null) {
                ps = con.prepareStatement(sqlUpdate);
                ps.setString(1, estadio.getNome());
                ps.setInt(2, estadio.getCidadeId());
                ps.setInt(3, estadio.getCapacidade());
                ps.setInt(4, estadio.getId());

                int rowsAffected = ps.executeUpdate();

                if (rowsAffected > 0) {
                    System.out.println("Estadio atualizado com sucesso!");
                } else {
                    System.out.println("Falha ao atualizar a Estadio. Nenhum registro encontrado com o ID: " + estadio.getId());
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
    
    public void deletarEstadio(int idEstadio) {
        String sqlDelete = "DELETE FROM estadios WHERE id = ?";
        PreparedStatement ps = null;
        Connection con = null;

        try {
            Conexao conexao = new Conexao();
            con = conexao.getConexao();

            if (con != null) {
                ps = con.prepareStatement(sqlDelete);
                ps.setInt(1, idEstadio);

                int rowsAffected = ps.executeUpdate();

                if (rowsAffected > 0) {
                    System.out.println("Estadio com ID " + idEstadio + " deletado com sucesso!");
                } else {
                    System.out.println("Falha ao deletar o Estadio. Nenhum estadio encontrado com o ID: " + idEstadio);
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

}