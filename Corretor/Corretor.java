import java.util.Date;

/**
 * Representa um corretor em uma firma de investimentos.
 */
public class Corretor {
    private int numero; // Número do corretor
    private String nome; // Nome do corretor
    private Date dataAdmissao; // Data de admissão do corretor
    private Date dataRescisao; // Data de rescisão do corretor
    private String telefone; // Número de telefone do corretor
    private double salarioBase; // Salário base do corretor

    /**
     * Construtor para a classe Corretor.
     * 
     * @param numero        O número do corretor.
     * @param nome          O nome do corretor.
     * @param dataAdmissao  A data de admissão do corretor.
     * @param dataRescisao  A data de rescisão do corretor.
     * @param telefone      O número de telefone do corretor.
     * @param salarioBase   O salário base do corretor.
     */
    public Corretor(int numero, String nome, Date dataAdmissao, Date dataRescisao, String telefone, double salarioBase) {
        this.numero = numero;
        this.nome = nome;
        this.dataAdmissao = dataAdmissao;
        this.dataRescisao = dataRescisao;
        this.telefone = telefone;
        this.salarioBase = salarioBase;
    }

    // Getters e setters para os atributos

    /**
     * Retorna o número do corretor.
     * 
     * @return O número do corretor.
     */
    public int getNumero() {
        return this.numero;
    }

    /**
     * Define o número do corretor.
     * 
     * @param numero O número do corretor.
     */
    public void setNumero(int numero) {
        this.numero = numero;
    }

    /**
     * Retorna o nome do corretor.
     * 
     * @return O nome do corretor.
     */
    public String getNome() {
        return this.nome;
    }

    /**
     * Define o nome do corretor.
     * 
     * @param nome O nome do corretor.
     */
    public void setNome(String nome) {
        this.nome = nome;
    }

    /**
     * Retorna a data de admissão do corretor.
     * 
     * @return A data de admissão do corretor.
     */
    public Date getDataAdmissao() {
        return this.dataAdmissao;
    }

    /**
     * Define a data de admissão do corretor.
     * 
     * @param dataAdmissao A data de admissão do corretor.
     */
    public void setDataAdmissao(Date dataAdmissao) {
        this.dataAdmissao = dataAdmissao;
    }

    /**
     * Retorna a data de rescisão do corretor.
     * 
     * @return A data de rescisão do corretor.
     */
    public Date getDataRescisao() {
        return this.dataRescisao;
    }

    /**
     * Define a data de rescisão do corretor.
     * 
     * @param dataRescisao A data de rescisão do corretor.
     */
    public void setDataRescisao(Date dataRescisao) {
        this.dataRescisao = dataRescisao;
    }

    /**
     * Retorna o número de telefone do corretor.
     * 
     * @return O número de telefone do corretor.
     */
    public String getTelefone() {
        return this.telefone;
    }

    /**
     * Define o número de telefone do corretor.
     * 
     * @param telefone O número de telefone do corretor.
     */
    public void setTelefone(String telefone) {
        this.telefone = telefone;
    }

    /**
     * Retorna o salário base do corretor.
     * 
     * @return O salário base do corretor.
     */
    public double getSalarioBase() {
        return this.salarioBase;
    }

    /**
     * Define o salário base do corretor.
     * 
     * @param salarioBase O salário base do corretor.
     */
    public void setSalarioBase(double salarioBase) {
        this.salarioBase = salarioBase;
    }

    /**
     * Calcula a comissão mensal do corretor.
     * 
     * @return A comissão mensal do corretor.
     */
    public double calcularComissao() {
        return 0.0; // Implementação a ser feita
    }
}