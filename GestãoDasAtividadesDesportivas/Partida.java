import java.util.List;

/**
 * Classe que representa uma partida em um torneio esportivo.
 */
public class Partida {
    private int numeroPartida;
    private List<Equipe> equipesParticipantes;
    private List<Integer> posicaoEquipes;
    private List<Integer> pontosEquipes;

    /**
     * Obtém o número da partida.
     * @return O número da partida.
     */
    public int getNumeroPartida() {
        return numeroPartida;
    }

    /**
     * Define o número da partida.
     * @param numeroPartida O número da partida.
     */
    public void setNumeroPartida(int numeroPartida) {
        this.numeroPartida = numeroPartida;
    }

    /**
     * Obtém a lista de equipes participantes na partida.
     * @return A lista de equipes participantes.
     */
    public List<Equipe> getEquipesParticipantes() {
        return equipesParticipantes;
    }

    /**
     * Define a lista de equipes participantes na partida.
     * @param equipesParticipantes A lista de equipes participantes.
     */
    public void setEquipesParticipantes(List<Equipe> equipesParticipantes) {
        this.equipesParticipantes = equipesParticipantes;
    }

    /**
     * Obtém a lista de posições das equipes na partida.
     * @return A lista de posições das equipes.
     */
    public List<Integer> getPosicaoEquipes() {
        return posicaoEquipes;
    }

    /**
     * Define a lista de posições das equipes na partida.
     * @param posicaoEquipes A lista de posições das equipes.
     */
    public void setPosicaoEquipes(List<Integer> posicaoEquipes) {
        this.posicaoEquipes = posicaoEquipes;
    }

    /**
     * Obtém a lista de pontos das equipes na partida.
     * @return A lista de pontos das equipes.
     */
    public List<Integer> getPontosEquipes() {
        return pontosEquipes;
    }

    /**
     * Define a lista de pontos das equipes na partida.
     * @param pontosEquipes A lista de pontos das equipes.
     */
    public void setPontosEquipes(List<Integer> pontosEquipes) {
        this.pontosEquipes = pontosEquipes;
    }
}