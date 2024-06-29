import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public class Main {
    public static void main(String[] args) {
        // Obtenha a conexão do banco de dados
        Connection connection = DatabaseConnection.getConnection();
        
        // Crie uma instância do CampeonatoService
        CampeonatoService service = new CampeonatoService(connection);

        try {
            // Testar obter dados de um jogador
            Optional<Jogador> jogador = service.obterDadosJogador(1);
            jogador.ifPresent(j -> System.out.println("Nome do Jogador: " + j.getNome()));

            // Testar obter dados de uma equipe (País)
            Optional<Pais> pais = service.obterDadosPais(1);
            pais.ifPresent(p -> System.out.println("Nome do País: " + p.getNome()));

            // Testar listar os melhores marcadores
            List<Jogador> melhoresMarcadores = service.listarMelhoresMarcadores();
            melhoresMarcadores.forEach(j -> System.out.println("Jogador: " + j.getNome() + " - Gols: " + j.getGols()));

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}