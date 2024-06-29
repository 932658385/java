import java.util.List;

public class PaisOrganizador {
    private String nome;
    private List<Estadio> estadios;
    private String calendario;

    public PaisOrganizador(String nome, List<Estadio> estadios, String calendario) {
        this.nome = nome;
        this.estadios = estadios;
        this.calendario = calendario;
    }

    public String getNome() {return nome;}
    public void setNome(String nome) {this.nome = nome;}

    public List<Estadio> getEstadios() {return estadios;}
    public void setEstadios(List<Estadio> estadios) {this.estadios = estadios;}

    public String getCalendario() {return calendario;}
    public void setCalendario(String calendario) {this.calendario = calendario;}
}