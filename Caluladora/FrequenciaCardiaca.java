import java.util.Calendar;

/**
 * Classe que representa uma pessoa e suas informações relacionadas à frequência cardíaca.
 */

public class FrequenciaCardiaca {
    private String primeiroNome;
    private String sobrenome;
    private int ano;
    private int mes;
    private int dia;

    /**
     * Construtor da classe FrequenciaCardiaca.
     * @param primeiroNome O primeiro nome da pessoa.
     * @param sobrenome O sobrenome da pessoa.
     * @param ano O ano de nascimento da pessoa.
     * @param mes O mês de nascimento da pessoa.
     * @param dia O dia de nascimento da pessoa.
    */

    public FrequenciaCardiaca(String primeiroNome, String sobrenome, int ano, int mes, int dia) {
        this.primeiroNome = primeiroNome;
        this.sobrenome = sobrenome;
        this.ano = ano;
        this.mes = mes;
        this.dia = dia;
    }

    // Métodos getters e setters
    public String getPrimeiroNome() {
        return primeiroNome;
    }

    public void setPrimeiroNome(String primeiroNome) {
        this.primeiroNome = primeiroNome;
    }

    public String getSobrenome() {
        return sobrenome;
    }

    public void setSobrenome(String sobrenome) {
        this.sobrenome = sobrenome;
    }

    public int getAno() {
        return ano;
    }

    public void setAno(int ano) {
        this.ano = ano;
    }

    public int getMes() {
        return mes;
    }

    public void setMes(int mes) {
        this.mes = mes;
    }

    public int getDia() {
        return dia;
    }

    public void setDia(int dia) {
        this.dia = dia;
    }

    /**
     * Método para calcular a idade da pessoa.
     * @return A idade da pessoa em anos.
    */

    public int calcularIdade() {
        Calendar hoje = Calendar.getInstance();
        int anoAtual = hoje.get(Calendar.YEAR);
        int mesAtual = hoje.get(Calendar.MONTH) + 1; // Janeiro é 0
        int diaAtual = hoje.get(Calendar.DAY_OF_MONTH);

        int idade = anoAtual - ano;
        if (mesAtual < mes || (mesAtual == mes && diaAtual < dia)) {
            idade--;
        }
        return idade;
    }

    /**
     * Método para calcular a frequencia Cardiaca Maxima da pessoa.
     * @return A frequencia Cardiaca Maxima da pessoa.
    */
    public int frequenciaCardiacaMaxima() {
        int idade = calcularIdade();
        return 220 - idade;
    }

    /**
     * Método para calcular a frequencia Cardiaca Alvo da pessoa.
     * @return A frequencia Cardiaca Alvo da pessoa, no formato "limiteInferior e limiteSuperior".
    */

    public String frequenciaCardiacaAlvo() {
        int frequenciaMaxima = frequenciaCardiacaMaxima();
        int limiteInferior = (int) (frequenciaMaxima * 0.5); // 50% da frequência cardíaca máxima
        int limiteSuperior = (int) (frequenciaMaxima * 0.85); // 85% da frequência cardíaca máxima
        return limiteInferior + "-" + limiteSuperior;
    }

    /**
     * Método principal para execução do programa.
     * @param args Os argumentos de linha de comando (não utilizados neste programa).
    */

    public static void main(String[] args) {
        FrequenciaCardiaca pessoa = new FrequenciaCardiaca("Alexandre", "Cauchy", 2001, 5, 10);

        System.out.println("Nome: " + pessoa.getPrimeiroNome() + " " + pessoa.getSobrenome());
        System.out.println("Data de Nascimento: " + pessoa.getDia() + "/" + pessoa.getMes() + "/" + pessoa.getAno());
        System.out.println("Idade: " + pessoa.calcularIdade() + " anos");
        System.out.println("Frequência Cardíaca Máxima: " + pessoa.frequenciaCardiacaMaxima() + " bpm");
        System.out.println("Frequência Cardíaca Alvo: " + pessoa.frequenciaCardiacaAlvo() + " bpm");
    }
}