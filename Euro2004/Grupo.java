import java.util.*;
import java.util.stream.Collectors;

public class Grupo {
    private List<Equipe> equipes;
    private List<Partida> jogos;
    private Map<Equipe, Integer> classificacao;
    private Map<Partida, String> resultados;
    private String calendario;

    public Grupo(List<Equipe> equipes, List<Partida> jogos, Map<Equipe, Integer> classificacao, Map<Partida, String> resultados, String calendario) {
        this.equipes = equipes;
        this.jogos = jogos;
        this.classificacao = classificacao;
        this.resultados = resultados;
        this.calendario = calendario;
        atualizarClassificacao();
    }

    public List<Equipe> getEquipes() {return equipes;}
    public void setEquipes(List<Equipe> equipes) {this.equipes = equipes;}

    public List<Partida> getJogos() {return jogos;}
    public void setJogos(List<Partida> jogos) {this.jogos = jogos;}

    public Map<Equipe, Integer> getClassificacao() {return classificacao;}
    public void setClassificacao(Map<Equipe, Integer> classificacao) {this.classificacao = classificacao;}

    public Map<Partida, String> getResultados() {return resultados;}
    public void setResultados(Map<Partida, String> resultados) {this.resultados = resultados;}

    public String getCalendario() {return calendario;}
    public void setCalendario(String calendario) {this.calendario = calendario;}

    public void atualizarClassificacao() {
        classificacao.clear();
        for (Partida partida : jogos) {
            int pontosCasa = partida.getGolsCasa() > partida.getGolsFora() ? 3 : (partida.getGolsCasa() == partida.getGolsFora() ? 1 : 0);
            int pontosFora = partida.getGolsFora() > partida.getGolsCasa() ? 3 : (partida.getGolsFora() == partida.getGolsCasa() ? 1 : 0);

            classificacao.put(partida.getEquipeCasa(), classificacao.getOrDefault(partida.getEquipeCasa(), 0) + pontosCasa);
            classificacao.put(partida.getEquipeFora(), classificacao.getOrDefault(partida.getEquipeFora(), 0) + pontosFora);
        }
    }

    public List<Map.Entry<Equipe, Integer>> getClassificacaoOrdenada() {
        return classificacao.entrySet()
                .stream()
                .sorted(Map.Entry.<Equipe, Integer>comparingByValue().reversed())
                .collect(Collectors.toList());
    }

    private List<Partida> gerarJogos() {
        List<Partida> jogos = new ArrayList<>();

        // Gerar todas as combinações de partidas entre as equipes
        for (int i = 0; i < equipes.size(); i++) {
            for (int j = i + 1; j < equipes.size(); j++) {
                Partida partida = new Partida(equipes.get(i), equipes.get(j));
                jogos.add(partida);
            }
        }

        // Embaralhar a ordem das partidas
        Collections.shuffle(jogos);

        return jogos;
    }

    public void jogar() {
        Random random = new Random();

        for (Partida partida : jogos) {
            // Simular a partida de forma aleatória
            int golsCasa = random.nextInt(5); // Número aleatório de gols da equipe da casa (0 a 4)
            int golsFora = random.nextInt(5); // Número aleatório de gols da equipe visitante (0 a 4)

            partida.setGolsCasa(golsCasa);
            partida.setGolsFora(golsFora);

            String resultado = golsCasa + " - " + golsFora;
            resultados.put(partida, resultado);
        }
        atualizarClassificacao();
    }

    public void atualizarClassificacao() {
        classificacao.clear();
        for (Partida partida : jogos) {
            int pontosCasa = partida.getGolsCasa() > partida.getGolsFora() ? 3 : (partida.getGolsCasa() == partida.getGolsFora() ? 1 : 0);
            int pontosFora = partida.getGolsFora() > partida.getGolsCasa() ? 3 : (partida.getGolsFora() == partida.getGolsCasa() ? 1 : 0);

            classificacao.put(partida.getEquipeCasa(), classificacao.getOrDefault(partida.getEquipeCasa(), 0) + pontosCasa);
            classificacao.put(partida.getEquipeFora(), classificacao.getOrDefault(partida.getEquipeFora(), 0) + pontosFora);
        }
    }

    public List<Map.Entry<Equipe, Integer>> getClassificacaoOrdenada() {
        return classificacao.entrySet()
                .stream()
                .sorted(Map.Entry.<Equipe, Integer>comparingByValue().reversed())
                .collect(Collectors.toList());
    }
}