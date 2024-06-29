import java.util.List;

public class FaseQualificacao {
    private List<Grupo> grupos;

    public FaseQualificacao(List<Grupo> grupos) {this.grupos = grupos;}
    
    public List<Grupo> getGrupos() {return grupos;}
    public void setGrupos(List<Grupo> grupos) {this.grupos = grupos;}
}