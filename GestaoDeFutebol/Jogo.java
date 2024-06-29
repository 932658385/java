import java.time.LocalDate;
import java.util.List;
import java.util.ArrayList;
import java.util.Random;
import java.util.Comparator;
import java.util.stream.Collectors;
import java.util.HashSet;
import java.util.Set;

/**
 * Classe que representa um jogo entre duas equipes em um campeonato.
 */

public class Jogo {
    private Equipa mandante;
    private Equipa visitante;
    private LocalDate dataDoJogo;
    private String estadio;
    private String cidade;
    private int placarMandante;
    private int placarVisitante;

    /**
     * Construtor da classe Jogo.
     * @param mandante Equipe mandante do jogo.
     * @param visitante Equipe visitante do jogo.
     * @param dataDoJogo Data do jogo.
     * @param estadio Estádio onde o jogo será realizado.
     * @param cidade Cidade onde o jogo será realizado.
     * @param placarMandante Placar da equipe mandante.
     * @param placarVisitante Placar da equipe visitante.
     */
    public Jogo(Equipa mandante, Equipa visitante, LocalDate dataDoJogo, String estadio, String cidade, int placarMandante, int placarVisitante) {
        this.mandante = mandante;
        this.visitante = visitante;
        this.dataDoJogo = dataDoJogo;
        this.estadio = estadio;
        this.cidade = cidade;
        this.placarMandante = placarMandante;
        this.placarVisitante = placarVisitante;
    }


    public Equipa getMandante() {
        return this.mandante;
    }

    public void setMandante(Equipa mandante) {
        this.mandante = mandante;
    }

    public Equipa getVisitante() {
        return this.visitante;
    }

    public void setVisitante(Equipa visitante) {
        this.visitante = visitante;
    }

    public LocalDate getDataDoJogo() {
        return this.dataDoJogo;
    }

    public void setDataDoJogo(LocalDate dataDoJogo) {
        this.dataDoJogo = dataDoJogo;
    }

    public String getEstadio() {
        return this.estadio;
    }

    public void setEstadio(String estadio) {
        this.estadio = estadio;
    }

    public String getCidade() {
        return this.cidade;
    }

    public void setCidade(String cidade) {
        this.cidade = cidade;
    }

    public int getPlacarMandante() {
        return this.placarMandante;
    }

    public void setPlacarMandante(int placarMandante) {
        this.placarMandante = placarMandante;
    }

    public int getPlacarVisitante() {
        return this.placarVisitante;
    }

    public void setPlacarVisitante(int placarVisitante) {
        this.placarVisitante = placarVisitante;
    }
    
    /**
     * Gera o resultado do jogo com base na qualidade das equipes.
    */
    public void gerarResultado() {
        System.out.println("************************************************************");
        System.out.println("");
        
        int qualidadeTotalMandante = mandante.getPlantel().stream()
                .mapToInt(Jogador::getQualidade)
                .sum();
        
        int qualidadeTotalVisitante = visitante.getPlantel().stream()
                .mapToInt(Jogador::getQualidade)
                .sum();
        
        Random rand = new Random();
        int resultado = rand.nextInt(100); // Valor entre 0 e 99
    
        if (resultado < 50) {
            // 50% de chance de vitória para a equipe com maior qualidade
            if (qualidadeTotalMandante > qualidadeTotalVisitante) {
                placarMandante = 2 + rand.nextInt(3); // Mandante vence
                placarVisitante = rand.nextInt(2); // Visitante perde
            } else {
                placarMandante = rand.nextInt(2); // Mandante perde
                placarVisitante = 2 + rand.nextInt(3); // Visitante vence
            }
        } else if (resultado < 80) {
            // 30% de chance de vitória para a equipe com menor qualidade
            if (qualidadeTotalMandante < qualidadeTotalVisitante) {
                placarMandante = 2 + rand.nextInt(3); // Mandante vence
                placarVisitante = rand.nextInt(2); // Visitante perde
            } else {
                placarMandante = rand.nextInt(2); // Mandante perde
                placarVisitante = 2 + rand.nextInt(3); // Visitante vence
            }
        } else {
            // 20% de chance de empate
            placarMandante = rand.nextInt(2) + 1; // Mandante empata
            placarVisitante = rand.nextInt(2) + 1; // Visitante empata
        }
    }    
    
    /**
     * Gera lesões em jogadores durante o jogo.
     */
    public void gerarLesoes(Jogo jogo) {
        Random random = new Random();
        int lesõesGeradas = 0;
        for (Jogador jogador : jogo.getMandante().getPlantel()) {
            if (lesõesGeradas < 2 && random.nextDouble() < 0.1) { // Probabilidade de 10% de lesão
                jogador.sofrerLesao();
                System.out.println("Jogador " + jogador.getNome() + " sofreu uma lesão.");
                lesõesGeradas++;
            }
        }
        for (Jogador jogador : jogo.getVisitante().getPlantel()) {
            if (lesõesGeradas < 2 && random.nextDouble() < 0.1) { // Probabilidade de 10% de lesão
                jogador.sofrerLesao();
                System.out.println("Jogador " + jogador.getNome() + " sofreu uma lesão.");
                lesõesGeradas++;
            }
        }
        System.out.println("*****************************************************");
        System.out.println("");
    }
    

    /**
     * Gera cartões para os jogadores durante o jogo.
    */
    public void gerarCartoes(Jogo jogo) {
        Random random = new Random();
        int cartoesGerados = 0;
        for (Jogador jogador : jogo.getMandante().getPlantel()) {
            if (cartoesGerados < 10 && random.nextDouble() < 0.2) { // Probabilidade de 20% de receber um cartão
                jogador.aplicarCartao("amarelo", 1);
                System.out.println("Jogador " + jogador.getNome() + " recebeu um cartão.");
                cartoesGerados++;
            }
        }
        for (Jogador jogador : jogo.getVisitante().getPlantel()) {
            if (cartoesGerados < 10 && random.nextDouble() < 0.2) { // Probabilidade de 20% de receber um cartão
                jogador.aplicarCartao("amarelo", 1);
                System.out.println("Jogador " + jogador.getNome() + " recebeu um cartão.");
                cartoesGerados++;
            } 
        } 
    }
      

    /**
     * Recalcula a probabilidade de vitória de cada equipe após um jogador ser expulso.
     */
    private void recalcularProbabilidadeDeVitoria() {
        int qualidadeMandante = mandante.getPlantel().stream().mapToInt(Jogador::getQualidade).sum();
        int qualidadeVisitante = visitante.getPlantel().stream().mapToInt(Jogador::getQualidade).sum();
    
        double probabilidadeMandante = (double) qualidadeMandante / (qualidadeMandante + qualidadeVisitante);
        double probabilidadeVisitante = (double) qualidadeVisitante / (qualidadeMandante + qualidadeVisitante);
    
        System.out.printf("Nova probabilidade de vitória - Mandante: %.2f%%, Visitante: %.2f%%%n",
                probabilidadeMandante * 100, probabilidadeVisitante * 100);
    }
    
    /**
     * Permite que os jogadores treinem após um jogo.
    */
    public void permitirTreinamento() {
        List<Jogador> mandanteSemExpulsos = new ArrayList<>(mandante.getPlantel());
        List<Jogador> visitanteSemExpulsos = new ArrayList<>(visitante.getPlantel());
    
        for (Jogador jogador : mandanteSemExpulsos) {
            jogador.setTreinou(false);
        }
        for (Jogador jogador : visitanteSemExpulsos) {
            jogador.setTreinou(false);
        }
    }

    /**
     * Imprime o plantel apto de cada equipe.
    */
    public void imprimirPlantelApto() {
        System.out.println("");
        System.out.println("*****************************************************");
        System.out.println("Plantel do Mandante:");
        for (Jogador jogador : mandante.getPlantel()) {
            String condicao = jogador.isSuspenso() ? "suspenso" : "ta pra jogo";
            System.out.printf("%s %d- %s (%s) - %s - Condição: %s%n",
                    jogador.getPosicao(), jogador.getNumero(), jogador.getNome(),
                    jogador.getApelido(), jogador.getDataNascimento(), condicao);
        }
        System.out.println("");
        System.out.println("*****************************************************");
        System.out.println("Plantel do Visitante:");
        for (Jogador jogador : visitante.getPlantel()) {
            String condicao = jogador.isSuspenso() ? "suspenso" : "ta pra jogo";
            System.out.printf("%s %d- %s (%s) - %s - Condição: %s%n",
                    jogador.getPosicao(), jogador.getNumero(), jogador.getNome(),
                    jogador.getApelido(), jogador.getDataNascimento(), condicao);
        }
    }
    
}