import java.util.List;

public class Futsal implements AtividadeDesportiva {
    private String nome;
    private String local;
    private Associado responsavel;
    private List<Associado> participantes;
    private List<EspacoAssociacao> espacoAssociacao; // Adicionado o atributo
    private List<String> atividadesDisponiveis;
    private List<EspacoAssociacao> espacosAtividades;
    private List<Associado> responsaveisAtividades;

    @Override
    public String getNome() {
        return nome;
    }
    
    public void setNome(String nome) {
        this.nome = nome;
    }

    @Override
    public String getLocal() {
        return local;
    }

    @Override
    public void setLocal(String local) {
        this.local = local;
    }

    @Override
    public Associado getResponsavel() {
        return responsavel;
    }

    @Override
    public void setResponsavel(Associado responsavel) {
        this.responsavel = responsavel;
    }

    @Override
    public List<Associado> getParticipantes() {
        return participantes;
    }

    @Override
    public void setParticipantes(List<Associado> participantes) {
        this.participantes = participantes;
    }

    public List<EspacoAssociacao> getEspacosAtividades() {
        return espacoAssociacao;
    }

    public void setEspacosAtividades(List<EspacoAssociacao> espacosAtividades) {
        this.espacosAtividades = espacosAtividades;
    }

    @Override
    public void setAtividadesDisponiveis(List<String> atividadesDisponiveis) {
        this.atividadesDisponiveis = atividadesDisponiveis;
    }

    @Override
    public List<String> getAtividadesDisponiveis() {
        return atividadesDisponiveis;
    }

    @Override
    public List<Associado> getResponsaveisAtividades() {
        return responsaveisAtividades;
    }

    @Override
    public void setResponsaveisAtividades(List<Associado> responsaveisAtividades) {
        this.responsaveisAtividades = responsaveisAtividades;
    }
}