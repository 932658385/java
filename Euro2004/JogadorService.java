import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

public class JogadorService {
    private JogadorDAO jogadorDAO;

    public JogadorService() {this.jogadorDAO = new JogadorDAO();}
    public Optional<Jogador> getJogadorById(int id) {return jogadorDAO.getJogadorById(id);}

    public List<Jogador> getJogadoresComMaisDeXGols(int gols) {
        return jogadorDAO.getAllJogadores().stream()
                .filter(jogador -> jogador.getGols() > gols)
                .collect(Collectors.toList());
    }
}