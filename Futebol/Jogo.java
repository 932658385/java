/**
 * Classe que representa um jogo de futebol entre duas equipes.
 */
public class Jogo {
    private Equipe equipeCasa;
    private Equipe equipeVisitante;
    private int golsEquipeCasa;
    private int golsEquipeVisitante;

    /**
     * Construtor da classe Jogo.
     * 
     * @param equipeCasa A equipe que joga em casa.
     * @param equipeVisitante A equipe visitante.
     * @param golsEquipeCasa O número de gols marcados pela equipe da casa.
     * @param golsEquipeVisitante O número de gols marcados pela equipe visitante.
     */
    public Jogo(Equipe equipeCasa, Equipe equipeVisitante, int golsEquipeCasa, int golsEquipeVisitante) {
        this.equipeCasa = equipeCasa;
        this.equipeVisitante = equipeVisitante;
        this.golsEquipeCasa = golsEquipeCasa;
        this.golsEquipeVisitante = golsEquipeVisitante;
    }
    
    /**
     * Obtém a equipe que joga em casa.
     * 
     * @return A equipe que joga em casa.
     */
    public Equipe getEquipeCasa() {
        return this.equipeCasa;
    }

    /**
     * Define a equipe que joga em casa.
     * 
     * @param equipeCasa A equipe que joga em casa a ser definida.
     */
    public void setEquipeCasa(Equipe equipeCasa) {
        this.equipeCasa = equipeCasa;
    }

    /**
     * Obtém a equipe visitante.
     * 
     * @return A equipe visitante.
     */
    public Equipe getEquipeVisitante() {
        return this.equipeVisitante;
    }

    /**
     * Define a equipe visitante.
     * 
     * @param equipeVisitante A equipe visitante a ser definida.
     */
    public void setEquipeVisitante(Equipe equipeVisitante) {
        this.equipeVisitante = equipeVisitante;
    }

    /**
     * Obtém o número de gols marcados pela equipe da casa.
     * 
     * @return O número de gols marcados pela equipe da casa.
     */
    public int getGolsEquipeCasa() {
        return this.golsEquipeCasa;
    }

    /**
     * Define o número de gols marcados pela equipe da casa.
     * 
     * @param golsEquipeCasa O número de gols marcados pela equipe da casa a ser definido.
     */
    public void setGolsEquipeCasa(int golsEquipeCasa) {
        this.golsEquipeCasa = golsEquipeCasa;
    }

    /**
     * Obtém o número de gols marcados pela equipe visitante.
     * 
     * @return O número de gols marcados pela equipe visitante.
     */
    public int getGolsEquipeVisitante() {
        return this.golsEquipeVisitante;
    }

    /**
     * Define o número de gols marcados pela equipe visitante.
     * 
     * @param golsEquipeVisitante O número de gols marcados pela equipe visitante a ser definido.
     */
    public void setGolsEquipeVisitante(int golsEquipeVisitante) {
        this.golsEquipeVisitante = golsEquipeVisitante;
    }
}