import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class JogadorDAO {
    private Connection connection;

    public JogadorDAO() {
        this.connection = DatabaseConnection.getConnection();
    }

    public void adicionarJogador(Jogador jogador) throws SQLException {
        String sql = "INSERT INTO jogador (id, nome, idade, pais_id, posicao) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, jogador.getId());
            stmt.setString(2, jogador.getNome());
            stmt.setInt(3, jogador.getIdade());
            stmt.setInt(4, jogador.getPais().getId());
            stmt.setString(5, jogador.getPosicao());
            stmt.executeUpdate();
        }
    }

    public Optional<Jogador> obterJogadorPorId(int id) throws SQLException {
        String sql = "SELECT j.*, p.nome as pais_nome, p.codigo as pais_codigo " +
                     "FROM jogador j " +
                     "JOIN pais p ON j.pais_id = p.id " +
                     "WHERE j.id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Pais pais = new Pais(
                        rs.getInt("pais_id"),
                        rs.getString("pais_nome"),
                        rs.getString("pais_codigo")
                    );
                    Jogador jogador = new Jogador(
                        rs.getInt("id"),
                        rs.getString("nome"),
                        rs.getInt("idade"),
                        pais,
                        rs.getString("posicao")
                    );
                    return Optional.of(jogador);
                }
            }
        }
        return Optional.empty();
    }

    public List<Jogador> obterJogadoresPorPais(int paisId) throws SQLException {
        String sql = "SELECT j.*, p.nome as pais_nome, p.codigo as pais_codigo " +
                     "FROM jogador j " +
                     "JOIN pais p ON j.pais_id = p.id " +
                     "WHERE j.pais_id = ?";
        List<Jogador> jogadores = new ArrayList<>();
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, paisId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Pais pais = new Pais(
                        rs.getInt("pais_id"),
                        rs.getString("pais_nome"),
                        rs.getString("pais_codigo")
                    );
                    Jogador jogador = new Jogador(
                        rs.getInt("id"),
                        rs.getString("nome"),
                        rs.getInt("idade"),
                        pais,
                        rs.getString("posicao")
                    );
                    jogadores.add(jogador);
                }
            }
        }
        return jogadores;
    }

    public List<Jogador> obterMelhoresMarcadores() throws SQLException {
        String sql = "SELECT j.*, p.nome as pais_nome, p.codigo as pais_codigo, SUM(e.gols) as total_gols " +
                     "FROM jogador j " +
                     "JOIN estatisticas_individuais e ON j.id = e.jogador_id " +
                     "JOIN pais p ON j.pais_id = p.id " +
                     "GROUP BY j.id, p.nome, p.codigo " +
                     "ORDER BY total_gols DESC " +
                     "LIMIT 10";
        List<Jogador> marcadores = new ArrayList<>();
        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Pais pais = new Pais(
                    rs.getInt("pais_id"),
                    rs.getString("pais_nome"),
                    rs.getString("pais_codigo")
                );
                Jogador jogador = new Jogador(
                    rs.getInt("id"),
                    rs.getString("nome"),
                    rs.getInt("idade"),
                    pais,
                    rs.getString("posicao")
                );
                marcadores.add(jogador);
            }
        }
        return marcadores;
    }
}
