import java.util.List;

public class Equipa {
    private int id;
    private String name;
    private List<Jogador> jogadores;
    
    public int getId() {return this.id;}
    public void setId(int id) {this.id = id;}

    public String getName() {return this.name;}
    public void setName(String name) {this.name = name;}

    public List<Jogador> getJogadores() {return this.jogadores;}
    public void setJogadores(List<Jogador> jogadores) {this.jogadores = jogadores;}
}