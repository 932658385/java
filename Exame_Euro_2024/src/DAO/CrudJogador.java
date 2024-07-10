package DAO;
 
import conexao.Conexao;
import entidade.Jogador;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.sql.SQLException;

public class CrudJogador {

    public void adicionarJogador(Jogador jogador) {
        String sqlInsert = "INSERT INTO jogadores(nome, posicao, selecao_id) VALUES(?, ?, ?)";
        PreparedStatement ps = null;
        Connection con = null;

        try {
            Conexao conexao = new Conexao();
            con = conexao.getConexao();

            if (con != null) {
                ps = con.prepareStatement(sqlInsert);
                ps.setString(1, jogador.getNome());
                ps.setString(2, jogador.getPosicao());
                ps.setInt(3, jogador.getSelecaoId());

                int rowsAffected = ps.executeUpdate();

                if (rowsAffected > 0) {
                    System.out.println("Jogador adicionado com sucesso!");
                } else {
                    System.out.println("Falha ao adicionar o jogador.");
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
    
    public void consultarPorNome(String nomeJogador) {
        String sqlSelect = "SELECT id, nome, posicao, selecao_id FROM jogadores WHERE nome LIKE ?";
        PreparedStatement ps = null;
        Connection con = null;

        try {
            Conexao conexao = new Conexao();
            con = conexao.getConexao();

            if (con != null) {
                ps = con.prepareStatement(sqlSelect);
                ps.setString(1, "%" + nomeJogador + "%");

                ResultSet rs = ps.executeQuery();

                while (rs.next()) {
                    int id = rs.getInt("id");
                    String nome = rs.getString("nome");
                    String posicao = rs.getString("posicao");
                    int selecaoId = rs.getInt("selecao_id");

                    Jogador jogador = new Jogador(id, nome, posicao, selecaoId);
                    System.out.println(jogador.toString());
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
    
    public void atualizarJogador(Jogador jogador) {
        String sqlUpdate = "UPDATE jogadores SET nome = ?, posicao = ?, selecao_id = ? WHERE id = ?";
        PreparedStatement ps = null;
        Connection con = null;

        try {
            Conexao conexao = new Conexao();
            con = conexao.getConexao();

            if (con != null) {
                ps = con.prepareStatement(sqlUpdate);
                ps.setString(1, jogador.getNome());
                ps.setString(2, jogador.getPosicao());
                ps.setInt(3, jogador.getSelecaoId());
                ps.setInt(4, jogador.getId());

                int rowsAffected = ps.executeUpdate();

                if (rowsAffected > 0) {
                    System.out.println("Jogador atualizado com sucesso!");
                } else {
                    System.out.println("Falha ao atualizar o jogador. Nenhum registro encontrado com o ID: " + jogador.getId());
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
    
    public void deletarJogador(int idJogador) {
        String sqlDelete = "DELETE FROM jogadores WHERE id = ?";
        PreparedStatement ps = null;
        Connection con = null;

        try {
            Conexao conexao = new Conexao();
            con = conexao.getConexao();

            if (con != null) {
                ps = con.prepareStatement(sqlDelete);
                ps.setInt(1, idJogador);

                int rowsAffected = ps.executeUpdate();

                if (rowsAffected > 0) {
                    System.out.println("Jogador com ID " + idJogador + " deletado com sucesso!");
                } else {
                    System.out.println("Falha ao deletar o jogador. Nenhum jogador encontrado com o ID: " + idJogador);
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

    public List<Jogador> consultarMelhoresMarcadores() {
        String sqlSelect = "SELECT j.id, j.nome, j.posicao, j.selecao_id, COUNT(g.id) as gols " +
                           "FROM jogadores j " +
                           "LEFT JOIN gols g ON j.id = g.jogador_id " +
                           "GROUP BY j.id, j.nome, j.posicao, j.selecao_id " +
                           "ORDER BY gols DESC " +
                           "LIMIT 10"; 
        PreparedStatement ps = null;
        Connection con = null;
        List<Jogador> melhoresMarcadores = new ArrayList<>();

        try {
            Conexao conexao = new Conexao();
            con = conexao.getConexao();

            if (con != null) {
                ps = con.prepareStatement(sqlSelect);
                ResultSet rs = ps.executeQuery();

                while (rs.next()) {
                    int id = rs.getInt("id");
                    String nome = rs.getString("nome");
                    String posicao = rs.getString("posicao");
                    int selecaoId = rs.getInt("selecao_id");
                    int gols = rs.getInt("gols");

                    Jogador jogador = new Jogador(id, nome, posicao, selecaoId);
                    jogador.setGols(gols);
                    melhoresMarcadores.add(jogador);
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

        return melhoresMarcadores;
    }
   }