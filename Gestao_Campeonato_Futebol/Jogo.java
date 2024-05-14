import java.time.LocalDate;
import java.util.concurrent.ThreadLocalRandom;
import java.util.List;

public class Jogo {
    private Equipa mandante;
    private Equipa visitante;
    private LocalDate dataDoJogo;
    private String estadio;
    private String cidade;
    private int placarMandante;
    private int placarVisitante;

    // Construtores
    public Jogo() {
    }

    public Jogo(Equipa mandante, Equipa visitante, LocalDate dataDoJogo, String estadio, String cidade) {
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

    public LocalDate getDataDoJogo() {
        return dataDoJogo;
    }

    public void setDataDoJogo(LocalDate dataDoJogo) {
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

        int totalQualidade = qualidadeMandante + qualidadeVisitante;
        int resultado = ThreadLocalRandom.current().nextInt(totalQualidade);

        if (resultado < qualidadeMandante * 0.5) {
            placarMandante = ThreadLocalRandom.current().nextInt(5);
            placarVisitante = ThreadLocalRandom.current().nextInt(3);
        } else if (resultado < qualidadeMandante * 0.8) {
            placarMandante = ThreadLocalRandom.current().nextInt(3);
            placarVisitante = ThreadLocalRandom.current().nextInt(5);
        } else {
            placarMandante = ThreadLocalRandom.current().nextInt(3);
            placarVisitante = ThreadLocalRandom.current().nextInt(3);
        }

        System.out.println("Resultado: " + placarMandante + " x " + placarVisitante);
    }

    public void gerarLesoes() {
        List<Jogador> mandanteRelacionados = mandante.getRelacionados();
        List<Jogador> visitanteRelacionados = visitante.getRelacionados();

        int numLesoes = ThreadLocalRandom.current().nextInt(3);
        for (int i = 0; i < numLesoes; i++) {
            Jogador jogador = mandanteRelacionados.get(ThreadLocalRandom.current().nextInt(mandanteRelacionados.size()));
            jogador.sofrerLesao();
            System.out.println("Jogador lesionado: " + jogador.getNome() + " (" + mandante.getNome() + ")");
            
            jogador = visitanteRelacionados.get(ThreadLocalRandom.current().nextInt(visitanteRelacionados.size()));
            jogador.sofrerLesao();
            System.out.println("Jogador lesionado: " + jogador.getNome() + " (" + visitante.getNome() + ")");
        }
    }

    public void gerarCartoes() {
        List<Jogador> mandanteRelacionados = mandante.getRelacionados();
        List<Jogador> visitanteRelacionados = visitante.getRelacionados();

        int numCartoes = ThreadLocalRandom.current().nextInt(11);
        Jogador ultimoCartao = null;

        for (int i = 0; i < numCartoes; i++) {
            Jogador jogador;
            if (ultimoCartao != null && ThreadLocalRandom.current().nextBoolean()) {
                // Se o último jogador receber um cartão, escolha o time adversário
                jogador = visitanteRelacionados.get(ThreadLocalRandom.current().nextInt(visitanteRelacionados.size()));
            } else {
                jogador = mandanteRelacionados.get(ThreadLocalRandom.current().nextInt(mandanteRelacionados.size()));
            }

            ultimoCartao = jogador;

            jogador.aplicarCartao(1);
            System.out.println("Cartão aplicado ao jogador: " + jogador.getNome() + " (" + jogador.getEquipa().getNome() + ")");
        }
    }

    public void permitirTreinamento() {
        mandante.getPlantel().forEach(Jogador::resetarTreinamento);
        visitante.getPlantel().forEach(Jogador::resetarTreinamento);
    }
}