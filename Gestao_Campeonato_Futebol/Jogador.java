import java.time.LocalDate;
import java.util.Random;
import java.time.format.DateTimeFormatter;

public class Jogador {
    private int id;
    private String nome;
    private String apelido;
    private LocalDate dataNascimento;
    private int numero;
    private String posicao;
    private int qualidade;
    private int cartoes;
    private boolean suspenso;
    private boolean treinado;
    private Equipa equipa; // Adicionando a propriedade equipa

    // Construtor
    public Jogador(int id, String nome, String apelido, LocalDate dataNascimento, int numero, String posicao, int qualidade) {
        this.id = id;
        this.nome = nome;
        this.apelido = apelido;
        this.dataNascimento = dataNascimento;
        this.numero = numero;
        this.posicao = posicao;
        this.qualidade = qualidade;
        this.cartoes = 0;
        this.suspenso = false;
        this.treinado = false;
    }

    // Getters e Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getApelido() {
        return apelido;
    }

    public void setApelido(String apelido) {
        this.apelido = apelido;
    }

    public LocalDate getDataNascimento() {
        return dataNascimento;
    }

    public void setDataNascimento(LocalDate dataNascimento) {
        this.dataNascimento = dataNascimento;
    }

    public int getNumero() {
        return numero;
    }

    public void setNumero(int numero) {
        this.numero = numero;
    }

    public String getPosicao() {
        return posicao;
    }

    public void setPosicao(String posicao) {
        this.posicao = posicao;
    }

    public int getQualidade() {
        return qualidade;
    }

    public void setQualidade(int qualidade) {
        this.qualidade = qualidade;
    }

    public int getCartoes() {
        return cartoes;
    }

    public void setCartoes(int cartoes) {
        this.cartoes = cartoes;
    }

    public boolean isSuspenso() {
        return suspenso;
    }

    public void setSuspenso(boolean suspenso) {
        this.suspenso = suspenso;
    }

    public boolean isTreinado() {
        return treinado;
    }

    public void setTreinado(boolean treinado) {
        this.treinado = treinado;
    }

    public Equipa getEquipa() { // Adicionando o getter para equipa
        return equipa;
    }

    public void setEquipa(Equipa equipa) { // Adicionando o setter para equipa
        this.equipa = equipa;
    }

    // Métodos adicionais
    public boolean estaAptoParaJogar() {
        return !suspenso;
    }

    public void aplicarCartao(int quantidade) {
        cartoes += quantidade;
        if (cartoes >= 3) {
            suspenso = true;
        }
    }

    public void cumprirSuspensao() {
        cartoes = 0;
        suspenso = false;
    }

    public void sofrerLesao() {
        Random random = new Random();
        int probabilidade = random.nextInt(100) + 1;
        int decremento = 0;

        if (probabilidade <= 5) {
            decremento = (int) (qualidade * 0.15);
        } else if (probabilidade <= 15) {
            decremento = (int) (qualidade * 0.10);
        } else if (probabilidade <= 30) {
            decremento = (int) (qualidade * 0.05);
        } else if (probabilidade <= 60) {
            decremento = 2;
        } else {
            decremento = 1;
        }

        qualidade = Math.max(0, qualidade - decremento);
    }

    public void executarTreinamento() {
        if (!treinado) {
            Random random = new Random();
            int probabilidade = random.nextInt(100) + 1;
            int incremento = 0;

            if (probabilidade <= 5) {
                incremento = 5;
            } else if (probabilidade <= 15) {
                incremento = 4;
            } else if (probabilidade <= 30) {
                incremento = 3;
            } else if (probabilidade <= 60) {
                incremento = 2;
            } else {
                incremento = 1;
            }

            qualidade = Math.min(100, qualidade + incremento);
            treinado = true;
        }
    }

    public void resetarTreinamento() {
        treinado = false;
    }

    private void executarAcao(JogadorAction acao) {
        acao.executar(this);
    }

    public void acaoCartao(int quantidade) {
        executarAcao(jogador -> jogador.aplicarCartao(quantidade));
    }

    public void acaoLesao() {
        executarAcao(Jogador::sofrerLesao);
    }

    public void acaoTreinamento() {
        executarAcao(Jogador::executarTreinamento);
    }

    public void imprimirInformacoes() {
        String condicao = estaAptoParaJogar() ? "apto para jogar" : "suspenso";
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");

        System.out.println(posicao + " " + numero + "- " + nome + " (" + apelido + ") - " +
                dataNascimento.format(formatter) + " - Condição: " + condicao);
    }

    @Override
    public String toString() {
        return String.format("Jogador{id=%d, nome='%s', apelido='%s', dataNascimento=%s, numero=%d, posicao='%s', qualidade=%d, cartoes=%d, suspenso=%b, treinado=%b}",
                id, nome, apelido, dataNascimento, numero, posicao, qualidade, cartoes, suspenso, treinado);
    }

    public String jogadorToString() {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        return "ID: " + id + "\n" +
                "Nome: " + nome + "\n" +
                "Apelido: " + apelido + "\n" +
                "Data de Nascimento: " + dataNascimento.format(formatter) + "\n" +
                "Número: " + numero + "\n" +
                "Posição: " + posicao + "\n" +
                "Qualidade: " + qualidade + "\n" +
                "Cartões: " + cartoes + "\n" +
                "Suspenso: " + suspenso + "\n" +
                "Treinado: " + treinado + "\n" +
                "Equipa: " + (equipa != null ? equipa.getNome() : "Nenhuma");
    }
}