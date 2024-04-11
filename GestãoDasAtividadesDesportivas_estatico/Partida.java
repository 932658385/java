import java.util.List;

public class Partida {
    private int numeroPartida;
    private List<Equipe> equipesParticipantes;
    private List<Integer> posicaoEquipes;
    private List<Integer> pontosEquipes;

    // Getters e Setters
    public int getNumeroPartida() {
        return numeroPartida;
    }

    public void setNumeroPartida(int numeroPartida) {
        this.numeroPartida = numeroPartida;
    }

    public List<Equipe> getEquipesParticipantes() {
        return equipesParticipantes;
    }

    public void setEquipesParticipantes(List<Equipe> equipesParticipantes) {
        this.equipesParticipantes = equipesParticipantes;
    }

    public List<Integer> getPosicaoEquipes() {
        return posicaoEquipes;
    }

    public void setPosicaoEquipes(List<Integer> posicaoEquipes) {
        this.posicaoEquipes = posicaoEquipes;
    }

    public List<Integer> getPontosEquipes() {
        return pontosEquipes;
    }

    public void setPontosEquipes(List<Integer> pontosEquipes) {
        this.pontosEquipes = pontosEquipes;
    }
}
