/**
 * Classe para representar um funcionário da imobiliária.
 */
public class Funcionario {
    private int codigo;
    private String nome;
    private String agencia;
    private double salario;

    /**
     * Construtor para a classe Funcionario.
     * 
     * @param codigo O código do funcionário.
     * @param nome O nome do funcionário.
     * @param agencia A agência em que o funcionário trabalha.
     * @param salario O salário do funcionário.
     */
    public Funcionario(int codigo, String nome, String agencia, double salario) {
        this.codigo = codigo;
        this.nome = nome;
        this.agencia = agencia;
        this.salario = salario;
    }

    /**
     * Obtém o código do funcionário.
     * 
     * @return O código do funcionário.
     */
    public int getCodigo() {
        return this.codigo;
    }

    /**
     * Define o código do funcionário.
     * 
     * @param codigo O código do funcionário.
     */
    public void setCodigo(int codigo) {
        this.codigo = codigo;
    }

    /**
     * Obtém o nome do funcionário.
     * 
     * @return O nome do funcionário.
     */
    public String getNome() {
        return this.nome;
    }

    /**
     * Define o nome do funcionário.
     * 
     * @param nome O nome do funcionário.
     */
    public void setNome(String nome) {
        this.nome = nome;
    }

    /**
     * Obtém a agência em que o funcionário trabalha.
     * 
     * @return A agência do funcionário.
     */
    public String getAgencia() {
        return this.agencia;
    }

    /**
     * Define a agência em que o funcionário trabalha.
     * 
     * @param agencia A agência do funcionário.
     */
    public void setAgencia(String agencia) {
        this.agencia = agencia;
    }

    /**
     * Obtém o salário do funcionário.
     * 
     * @return O salário do funcionário.
     */
    public double getSalario() {
        return this.salario;
    }

    /**
     * Define o salário do funcionário.
     * 
     * @param salario O salário do funcionário.
     */
    public void setSalario(double salario) {
        this.salario = salario;
    }
}