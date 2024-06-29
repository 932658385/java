package DAO;


import conexao.Conexao;
import entidade.Cidade;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class CrudCidade {
	
	public void adicionarCidade(Cidade cidade) {
        String sqlInsert = "INSERT INTO cidades(nome, pais_id) VALUES(?, ?)";
        PreparedStatement ps = null;
        Connection con = null;
 
        try {
            Conexao conexao = new Conexao();
            con = conexao.getConexao();

            if (con != null) {
                ps = con.prepareStatement(sqlInsert);
                ps.setString(1, cidade.getNome());
                ps.setInt(2, cidade.getPaisId());

                int rowsAffected = ps.executeUpdate();

                if (rowsAffected > 0) {
                    System.out.println("Cidade adicionado com sucesso!");
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
	
	 public void consultarPorNome(String nomeCidade) {
	        String sqlSelect = "SELECT id, nome, pais_id FROM cidades WHERE nome LIKE ?";
	        PreparedStatement ps = null;
	        Connection con = null;

	        try {
	            Conexao conexao = new Conexao();
	            con = conexao.getConexao();

	            if (con != null) {
	                ps = con.prepareStatement(sqlSelect);
	                ps.setString(1, "%" + nomeCidade + "%");

	                ResultSet rs = ps.executeQuery();

	                while (rs.next()) {
	                    int id = rs.getInt("id");
	                    String nome = rs.getString("nome");
	                    int pais_id = rs.getInt("pais_id");

	                    Cidade cidade = new Cidade(id, nome, pais_id);
	                    System.out.println(cidade.toString());
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
	    
	    public void atualizarCidade(Cidade cidade) {
	        String sqlUpdate = "UPDATE cidades SET nome = ?, pais_id = ? WHERE id = ?";
	        PreparedStatement ps = null;
	        Connection con = null;

	        try {
	            Conexao conexao = new Conexao();
	            con = conexao.getConexao();

	            if (con != null) {
	                ps = con.prepareStatement(sqlUpdate);
	                ps.setString(1, cidade.getNome());
	                ps.setInt(2, cidade.getPaisId());
	                ps.setInt(3, cidade.getId());

	                int rowsAffected = ps.executeUpdate();

	                if (rowsAffected > 0) {
	                    System.out.println("Cidade atualizado com sucesso!");
	                } else {
	                    System.out.println("Falha ao atualizar a Cidade. Nenhum registro encontrado com o ID: " + cidade.getId());
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
	    
	    public void deletarCidade(int idCidade) {
	        String sqlDelete = "DELETE FROM cidades WHERE id = ?";
	        PreparedStatement ps = null;
	        Connection con = null;

	        try {
	            Conexao conexao = new Conexao();
	            con = conexao.getConexao();

	            if (con != null) {
	                ps = con.prepareStatement(sqlDelete);
	                ps.setInt(1, idCidade);

	                int rowsAffected = ps.executeUpdate();

	                if (rowsAffected > 0) {
	                    System.out.println("Cidade com ID " + idCidade + " deletado com sucesso!");
	                } else {
	                    System.out.println("Falha ao deletar o Cidade. Nenhum estadio encontrado com o ID: " + idCidade);
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
