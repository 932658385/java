import java.util.*;
import java.util.stream.Collectors;

public class Estatisticas {
    private List<Partida> partidas;

    public Estatisticas(List<Partida> partidas) {this.partidas = partidas;}

    public List<Map.Entry<Jogador, Integer>> getMelhoresMarcadores() {
        Map<Jogador, Integer> marcadores = new HashMap<>();
        for (Partida partida : partidas) {
            for (Jogador jogador : partida.getEquipeCasa().getJogadores()) {
                marcadores.put(jogador, marcadores.getOrDefault(jogador, 0) + jogador.getGols());
            }
            for (Jogador jogador : partida.getEquipeFora().getJogadores()) {
                marcadores.put(jogador, marcadores.getOrDefault(jogador, 0) + jogador.getGols());
            }
        }
        return marcadores.entrySet()
                .stream()
                .sorted(Map.Entry.<Jogador, Integer>comparingByValue().reversed())
                .collect(Collectors.toList());
    }
}