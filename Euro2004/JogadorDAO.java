import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class JogadorDAO {
    private Connection connection;

    public JogadorDAO() {
        this.connection = JDBCConnection.getConnection();
    }

    public Optional<Jogador> getJogadorById(int id) {
        try {
            String query = "SELECT * FROM jogadores WHERE id = ?";
            PreparedStatement stmt = connection.prepareStatement(query);
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Jogador jogador = new Jogador();
                jogador.setId(rs.getInt("id"));
                jogador.setNome(rs.getString("nome"));
                jogador.setPosicao(rs.getString("posicao"));
                jogador.setGols(rs.getInt("gols"));
                return Optional.of(jogador);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }

    public List<Jogador> getAllJogadores() {
        List<Jogador> jogadores = new ArrayList<>();
        try {
            String query = "SELECT * FROM jogadores";
            Statement stmt = connection.createStatement();
            ResultSet rs = stmt.executeQuery(query);
            while (rs.next()) {
                Jogador jogador = new Jogador();
                jogador.setId(rs.getInt("id"));
                jogador.setNome(rs.getString("nome"));
                jogador.setPosicao(rs.getString("posicao"));
                jogador.setGols(rs.getInt("gols"));
                jogadores.add(jogador);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return jogadores;
    }
}