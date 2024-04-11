import java.util.List;

public interface AtividadeDesportiva {
    String getNome();
    String getLocal();
    void setLocal(String local);
    Associado getResponsavel();
    void setResponsavel(Associado responsavel);
    List<Associado> getParticipantes();
    void setParticipantes(List<Associado> participantes);
    List<String> getAtividadesDisponiveis(); // Adicionando o método getAtividadesDisponiveis()
    void setAtividadesDisponiveis(List<String> atividadesDisponiveis); // Adicionando o método setAtividadesDisponiveis()
    List<Associado> getResponsaveisAtividades(); // Novo método
    List<EspacoAssociacao> getEspacosAtividades();
    void setResponsaveisAtividades(List<Associado> responsaveisAtividades); // Novo método
}