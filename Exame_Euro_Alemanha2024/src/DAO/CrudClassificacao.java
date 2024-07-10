package DAO;
 
import entidade.Selecao;
import java.util.List;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import conexao.Conexao;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;


public class CrudClassificacao {

    public List<Selecao> determinarClassificados(List<Selecao> grupo) {
        // Ordenar as seleções pelo número de pontos e saldo de gols
        Collections.sort(grupo, new Comparator<Selecao>() {
            @Override
            public int compare(Selecao s1, Selecao s2) {
                int comparePontos = Integer.compare(s2.getPontos(), s1.getPontos());
                if (comparePontos == 0) {
                    return Integer.compare(s2.getSaldoGols(), s1.getSaldoGols());
                }
                return comparePontos;
            }
        });

        // Retornar as duas primeiras seleções como classificadas
        return grupo.size() >= 2 ? grupo.subList(0, 2) : new ArrayList<>();
    }
    
    public void atualizarEstatisticas(int grupoId, int selecaoId, int pontos, int golsPro, int golsContra, int saldoGols) {
        Connection con = null;
        PreparedStatement stmt = null;

        try {
        	Conexao conexao = new Conexao();
            con = conexao.getConexao();
            String sql = "UPDATE classificacoes SET pontos = ?, jogos = jogos + 1, vitorias = vitorias + ?, empates = empates + ?, derrotas = derrotas + ?, gols_pro = gols_pro + ?, gols_contra = gols_contra + ?, saldo_gols = saldo_gols + ? WHERE grupo_id = ? AND selecao_id = ?";
            stmt = con.prepareStatement(sql);
            stmt.setInt(1, pontos);
            stmt.setInt(2, 2); // Definir o número de vitórias
            stmt.setInt(3, 0); // Definir o número de empates
            stmt.setInt(4, 1); // Definir o número de derrotas
            stmt.setInt(5, golsPro);
            stmt.setInt(6, golsContra);
            stmt.setInt(7, saldoGols);
            stmt.setInt(8, grupoId);
            stmt.setInt(9, selecaoId);

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
            	//System.out.println("");
                //System.out.println("Estatísticas atualizadas para seleção ID " + selecaoId + " no grupo ID " + grupoId);
            } else {
                System.out.println("Erro ao atualizar estatísticas para seleção ID " + selecaoId + " no grupo ID " + grupoId);
            }
        } catch (SQLException e) {
            System.out.println("Erro ao atualizar estatísticas: " + e.getMessage());
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
    
    public void resetarClassificacoes() {
        Connection con = null;
        PreparedStatement stmt = null;

        try {
            Conexao conexao = new Conexao();
            con = conexao.getConexao();
            String sql = "UPDATE classificacoes SET pontos = 0, jogos = 0, vitorias = 0, empates = 0, derrotas = 0, gols_pro = 0, gols_contra = 0, saldo_gols = 0";
            stmt = con.prepareStatement(sql);

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Classificações resetadas com sucesso.");
            } else {
                System.out.println("Erro ao resetar classificações.");
            }
        } catch (SQLException e) {
            System.out.println("Erro ao resetar classificações: " + e.getMessage());
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
    
    public void consultarClassificacoes() {
        Connection con = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            Conexao conexao = new Conexao();
            con = conexao.getConexao();
            String sql = "SELECT grupo_id, selecao_id, pontos, jogos, vitorias, empates, derrotas, gols_pro, gols_contra, saldo_gols FROM classificacoes";
            stmt = con.prepareStatement(sql);
            rs = stmt.executeQuery();

            System.out.println("Grupo | Selecao | Pontos | Jogos | Vitorias | Empates | Derrotas | Gols Pró | Gols Contra | Saldo de Gols");
            while (rs.next()) {
                int grupoId = rs.getInt("grupo_id");
                int selecaoId = rs.getInt("selecao_id");
                int pontos = rs.getInt("pontos");
                int jogos = rs.getInt("jogos");
                int vitorias = rs.getInt("vitorias");
                int empates = rs.getInt("empates");
                int derrotas = rs.getInt("derrotas");
                int golsPro = rs.getInt("gols_pro");
                int golsContra = rs.getInt("gols_contra");
                int saldoGols = rs.getInt("saldo_gols");

                System.out.println(grupoId + " | " + selecaoId + " | " + pontos + " | " + jogos + " | " + vitorias + " | " + empates + " | " + derrotas + " | " + golsPro + " | " + golsContra + " | " + saldoGols);
            }

        } catch (SQLException e) {
            System.out.println("Erro ao listar classificações: " + e.getMessage());
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
}