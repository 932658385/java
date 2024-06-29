import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class PaisDAO {
    private Connection connection;

    public PaisDAO() {
        this.connection = DatabaseConnection.getConnection();
    }

    public void adicionarPais(Pais pais) throws SQLException {
        String sql = "INSERT INTO pais (id, nome, codigo) VALUES (?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, pais.getId());
            stmt.setString(2, pais.getNome());
            stmt.setString(3, pais.getCodigo());
            stmt.executeUpdate();
        }
    }

    public Optional<Pais> obterPaisPorId(int id) throws SQLException {
        String sql = "SELECT * FROM pais WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Pais pais = new Pais(
                        rs.getInt("id"),
                        rs.getString("nome"),
                        rs.getString("codigo")
                    );
                    return Optional.of(pais);
                }
            }
        }
        return Optional.empty();
    }

    public void atualizarPais(Pais pais) throws SQLException {
        String sql = "UPDATE pais SET nome = ?, codigo = ? WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, pais.getNome());
            stmt.setString(2, pais.getCodigo());
            stmt.setInt(3, pais.getId());
            stmt.executeUpdate();
        }
    }

    public void deletarPais(int id) throws SQLException {
        String sql = "DELETE FROM pais WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }

    public List<Pais> listarPaises() throws SQLException {
        String sql = "SELECT * FROM pais";
        List<Pais> paises = new ArrayList<>();
        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Pais pais = new Pais(
                    rs.getInt("id"),
                    rs.getString("nome"),
                    rs.getString("codigo")
                );
                paises.add(pais);
            }
        }
        return paises;
    }
}