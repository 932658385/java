import java.util.List;
import java.util.Map;
import java.util.Optional;

public class ConsultaService {
    private JogadorDAO jogadorDAO;
    private EquipeDAO equipeDAO;
    private Estatisticas estatisticas;

    public ConsultaService(JogadorDAO jogadorDAO, EquipeDAO equipeDAO, Estatisticas estatisticas) {
        this.jogadorDAO = jogadorDAO;
        this.equipeDAO = equipeDAO;
        this.estatisticas = estatisticas;
    }

    public Optional<Jogador> getDadosIndividuaisJogador(int id) {return jogadorDAO.getJogadorById(id);}
    public Optional<Equipe> getDadosEquipe(int id) {return equipeDAO.getEquipeById(id);}
    public List<Map.Entry<Jogador, Integer>> getMelhoresMarcadores() {return estatisticas.getMelhoresMarcadores();}
    
    // Método para listar jogadores com mais de X gols
    public List<Jogador> getJogadoresComMaisDeXGols(int gols) {
        return jogadorDAO.getAllJogadores().stream()
                .filter(jogador -> jogador.getGols() > gols)
                .collect(Collectors.toList());
    }
}