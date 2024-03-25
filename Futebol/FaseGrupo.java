import java.util.List;

/**
 * Classe que representa a fase de grupos de um campeonato.
 */
public class FaseGrupo {
    private List<Grupo> grupos;

    /**
     * Construtor da classe FaseGrupo.
     * 
     * @param grupos A lista de grupos nesta fase.
     */
    public FaseGrupo(List<Grupo> grupos) {
        this.grupos = grupos;
    }

    /**
     * Obtém a lista de grupos nesta fase.
     * 
     * @return A lista de grupos nesta fase.
     */
    public List<Grupo> getGrupos() {
        return this.grupos;
    }

    /**
     * Define a lista de grupos nesta fase.
     * 
     * @param grupos A lista de grupos nesta fase a ser definida.
     */
    public void setGrupos(List<Grupo> grupos) {
        this.grupos = grupos;
    }    
}