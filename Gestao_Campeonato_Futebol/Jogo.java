import java.util.Date;
import java.util.List;
import java.util.Random;

public class Jogo {
    private Equipa mandante;
    private Equipa visitante;
    private Date dataDoJogo;
    private String estadio;
    private String cidade;
    private int placarMandante;
    private int placarVisitante;

    // Construtores
    public Jogo() {
    }

    public Jogo(Equipa mandante, Equipa visitante, Date dataDoJogo, String estadio, String cidade) {
        this.mandante = mandante;
        this.visitante = visitante;
        this.dataDoJogo = dataDoJogo;
        this.estadio = estadio;
        this.cidade = cidade;
    }

    // Getters e Setters
    public Equipa getMandante() {
        return mandante;
    }

    public void setMandante(Equipa mandante) {
        this.mandante = mandante;
    }

    public Equipa getVisitante() {
        return visitante;
    }

    public void setVisitante(Equipa visitante) {
        this.visitante = visitante;
    }

    public Date getDataDoJogo() {
        return dataDoJogo;
    }

    public void setDataDoJogo(Date dataDoJogo) {
        this.dataDoJogo = dataDoJogo;
    }

    public String getEstadio() {
        return estadio;
    }

    public void setEstadio(String estadio) {
        this.estadio = estadio;
    }

    public String getCidade() {
        return cidade;
    }

    public void setCidade(String cidade) {
        this.cidade = cidade;
    }

    public int getPlacarMandante() {
        return placarMandante;
    }

    public void setPlacarMandante(int placarMandante) {
        this.placarMandante = placarMandante;
    }

    public int getPlacarVisitante() {
        return placarVisitante;
    }

    public void setPlacarVisitante(int placarVisitante) {
        this.placarVisitante = placarVisitante;
    }

    // Métodos adicionais
    public void gerarResultado() {
        int qualidadeMandante = mandante.getRelacionados().stream().mapToInt(Jogador::getQualidade).sum();
        int qualidadeVisitante = visitante.getRelacionados().stream().mapToInt(Jogador::getQualidade).sum();

        Random random = new Random();
        int totalQualidade = qualidadeMandante + qualidadeVisitante;
        int resultado = random.nextInt(totalQualidade);

        if (resultado < qualidadeMandante * 0.5) {
            placarMandante = random.nextInt(5);
            placarVisitante = random.nextInt(3);
        } else if (resultado < qualidadeMandante * 0.8) {
            placarMandante = random.nextInt(3);
            placarVisitante = random.nextInt(5);
        } else {
            placarMandante = random.nextInt(3);
            placarVisitante = random.nextInt(3);
        }

        System.out.println("Resultado: " + placarMandante + " x " + placarVisitante);
    }

    private void executarAcaoJogador(JogoAction acao) {
        Random random = new Random();
        boolean equipeMandante = random.nextBoolean();
        Equipa equipe = equipeMandante ? mandante : visitante;
        List<Jogador> relacionados = equipe.getRelacionados();
        if (!relacionados.isEmpty()) {
            Jogador jogador = relacionados.get(random.nextInt(relacionados.size()));
            acao.executar(jogador, equipe);
        }
    }

    public void gerarLesoes() {
        Random random = new Random();
        int numLesoes = random.nextInt(3);
        for (int i = 0; i < numLesoes; i++) {
            executarAcaoJogador((jogador, equipe) -> {
                jogador.sofrerLesao();
                System.out.println("Jogador lesionado: " + jogador.getNome() + " (" + equipe.getNome() + ")");
            });
        }
    }

    public void gerarCartoes() {
        Random random = new Random();
        int numCartoes = random.nextInt(11);
        for (int i = 0; i < numCartoes; i++) {
            executarAcaoJogador((jogador, equipe) -> {
                jogador.aplicarCartao(1);
                System.out.println("Cartão aplicado ao jogador: " + jogador.getNome() + " (" + equipe.getNome() + ")");
            });
        }
    }

    public void permitirTreinamento() {
        mandante.getPlantel().forEach(Jogador::resetarTreinamento);
        visitante.getPlantel().forEach(Jogador::resetarTreinamento);
    }
}