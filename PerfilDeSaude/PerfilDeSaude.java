import java.util.Scanner;

/**
 * Classe que representa o perfil de saúde de uma pessoa, contendo informações como nome, data de nascimento,
 * gênero, altura, peso, entre outros.
 */
public class PerfilDeSaude {
    private String nome;
    private String sobrenome;
    private String genero;
    private int anoNascimento;
    private int mesNascimento;
    private int diaNascimento;
    private double altura; // em metros
    private double peso; // em quilogramas

    /**
     * Construtor da classe PerfilDeSaude.
     * @param nome O primeiro nome da pessoa.
     * @param sobrenome O sobrenome da pessoa.
     * @param genero O gênero da pessoa.
     * @param anoNascimento O ano de nascimento da pessoa.
     * @param mesNascimento O mês de nascimento da pessoa.
     * @param diaNascimento O dia de nascimento da pessoa.
     * @param altura A altura da pessoa em metros.
     * @param peso O peso da pessoa em quilogramas.
     */
    public PerfilDeSaude(String nome, String sobrenome, String genero, int anoNascimento, int mesNascimento, int diaNascimento, double altura, double peso) {
        this.nome = nome;
        this.sobrenome = sobrenome;
        this.genero = genero;
        this.anoNascimento = anoNascimento;
        this.mesNascimento = mesNascimento;
        this.diaNascimento = diaNascimento;
        this.altura = altura;
        this.peso = peso;
    }

    // Métodos getters e setters

    /**
     * Obtém o primeiro nome da pessoa.
     * @return O primeiro nome da pessoa.
     */
    public String getNome() {
        return nome;
    }

    /**
     * Define o primeiro nome da pessoa.
     * @param nome O primeiro nome da pessoa.
     */
    public void setNome(String nome) {
        this.nome = nome;
    }

    /**
     * Obtém o sobrenome da pessoa.
     * @return O sobrenome da pessoa.
     */
    public String getSobrenome() {
        return sobrenome;
    }

    /**
     * Define o sobrenome da pessoa.
     * @param sobrenome O sobrenome da pessoa.
     */
    public void setSobrenome(String sobrenome) {
        this.sobrenome = sobrenome;
    }

    /**
     * Obtém o gênero da pessoa.
     * @return O gênero da pessoa.
     */
    public String getGenero() {
        return genero;
    }

    /**
     * Define o gênero da pessoa.
     * @param genero O gênero da pessoa.
     */
    public void setGenero(String genero) {
        this.genero = genero;
    }

    /**
     * Obtém o ano de nascimento da pessoa.
     * @return O ano de nascimento da pessoa.
     */
    public int getAnoNascimento() {
        return anoNascimento;
    }

    /**
     * Define o ano de nascimento da pessoa.
     * @param anoNascimento O ano de nascimento da pessoa.
     */
    public void setAnoNascimento(int anoNascimento) {
        this.anoNascimento = anoNascimento;
    }

    /**
     * Obtém o mês de nascimento da pessoa.
     * @return O mês de nascimento da pessoa.
     */
    public int getMesNascimento() {
        return mesNascimento;
    }

    /**
     * Define o mês de nascimento da pessoa.
     * @param mesNascimento O mês de nascimento da pessoa.
     */
    public void setMesNascimento(int mesNascimento) {
        this.mesNascimento = mesNascimento;
    }

    /**
     * Obtém o dia de nascimento da pessoa.
     * @return O dia de nascimento da pessoa.
     */
    public int getDiaNascimento() {
        return diaNascimento;
    }

    /**
     * Define o dia de nascimento da pessoa.
     * @param diaNascimento O dia de nascimento da pessoa.
     */
    public void setDiaNascimento(int diaNascimento) {
        this.diaNascimento = diaNascimento;
    }

    /**
     * Obtém a altura da pessoa em metros.
     * @return A altura da pessoa em metros.
     */
    public double getAltura() {
        return altura;
    }

    /**
     * Define a altura da pessoa em metros.
     * @param altura A altura da pessoa em metros.
     */
    public void setAltura(double altura) {
        this.altura = altura;
    }

    /**
     * Obtém o peso da pessoa em quilogramas.
     * @return O peso da pessoa em quilogramas.
     */
    public double getPeso() {
        return peso;
    }

    /**
     * Define o peso da pessoa em quilogramas.
     * @param peso O peso da pessoa em quilogramas.
     */
    public void setPeso(double peso) {
        this.peso = peso;
    }

    // Método para calcular a idade

    /**
     * Calcula a idade da pessoa com base no ano de nascimento.
     * @return A idade da pessoa.
     */
    public int calcularIdade() {
        int anoAtual = 2024; 
        int idade = anoAtual - anoNascimento;
        if (mesNascimento > 3 || (mesNascimento == 3 && diaNascimento > 14)) {
            idade--;
        }
        return idade;
    }

    // Método para calcular o Índice de Massa Corporal (IMC)

    /**
     * Calcula o Índice de Massa Corporal (IMC) da pessoa.
     * @return O IMC da pessoa.
     */
    public double calcularIMC() {
        return peso / (altura * altura);
    }

    // Método para calcular a frequência cardíaca máxima

    /**
     * Calcula a frequência cardíaca máxima da pessoa com base na idade.
     * @return A frequência cardíaca máxima da pessoa.
     */
    public int calcularFrequenciaCardiacaMaxima() {
        return 220 - calcularIdade();
    }

    // Método para calcular a frequência cardíaca alvo

    /**
     * Calcula a frequência cardíaca alvo da pessoa com base na frequência cardíaca máxima.
     * @return A frequência cardíaca alvo da pessoa.
     */
    public String calcularFrequenciaCardiacaAlvo() {
        int frequenciaMaxima = calcularFrequenciaCardiacaMaxima();
        double percentualMinimo = 0.5; // 50% da frequência cardíaca máxima
        double percentualMaximo = 0.85; // 85% da frequência cardíaca máxima
        int frequenciaMinima = (int) (frequenciaMaxima * percentualMinimo);
        int frequenciaMaximaAlvo = (int) (frequenciaMaxima * percentualMaximo);
        return frequenciaMinima + " - " + frequenciaMaximaAlvo + " batimentos por minuto";
    }

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        try {
            System.out.println("Informe o nome:");
            String nome = scanner.nextLine();

            System.out.println("Informe o sobrenome:");
            String sobrenome = scanner.nextLine();

            System.out.println("Informe o gênero:");
            String genero = scanner.nextLine();

            System.out.println("Informe o ano de nascimento:");
            int anoNascimento = scanner.nextInt();

            System.out.println("Informe o mês de nascimento:");
            int mesNascimento = scanner.nextInt();

            System.out.println("Informe o dia de nascimento:");
            int diaNascimento = scanner.nextInt();

            System.out.println("Informe a altura (em metros):");
            double altura = scanner.nextDouble();

            System.out.println("Informe o peso (em quilogramas):");
            double peso = scanner.nextDouble();

            // Criando objeto PerfilDeSaude
            PerfilDeSaude perfil = new PerfilDeSaude(nome, sobrenome, genero, anoNascimento, mesNascimento, diaNascimento, altura, peso);

            // Imprimindo informações
            System.out.println("Nome: " + perfil.getNome() + " " + perfil.getSobrenome());
            System.out.println("Idade: " + perfil.calcularIdade() + " anos");
            System.out.println("Gênero: " + perfil.getGenero());
            System.out.println("Altura: " + perfil.getAltura() + " metros");
            System.out.println("Peso: " + perfil.getPeso() + " quilogramas");
            System.out.println("IMC: " + perfil.calcularIMC());
            System.out.println("Frequência Cardíaca Máxima: " + perfil.calcularFrequenciaCardiacaMaxima() + " batimentos por minuto");
            System.out.println("Frequência Cardíaca Alvo: " + perfil.calcularFrequenciaCardiacaAlvo());

            // Exibindo gráfico de valores de IMC
            System.out.println("\nGráfico de Valores de IMC:");
            System.out.println("Abaixo do Peso: Menos de 18.5");
            System.out.println("Normal: Entre 18.5 e 24.9");
            System.out.println("Sobrepeso: Entre 25 e 29.9");
            System.out.println("Obesidade: 30 ou mais");
        } catch (Exception e) {
            System.out.println("Erro: Entrada inválida.");
        } finally {
            scanner.close();
        }
    }
}