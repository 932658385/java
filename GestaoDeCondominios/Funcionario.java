/**
 * Classe abstrata que representa um funcionário de uma empresa.
 * 
 * Esta classe define atributos e métodos comuns a todos os funcionários.
 * Funcionários específicos devem ser implementados por meio de subclasses.
 */
public abstract class Funcionario {
    private String nome; // Nome do funcionário
    private String cargo; // Cargo do funcionário

    /**
     * Construtor da classe Funcionario.
     * 
     * @param nome  O nome do funcionário.
     * @param cargo O cargo do funcionário.
     */
    public Funcionario(String nome, String cargo) {
        this.nome = nome;
        this.cargo = cargo;
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
     * Obtém o cargo do funcionário.
     * 
     * @return O cargo do funcionário.
     */
    public String getCargo() {
        return this.cargo;
    }

    /**
     * Define o cargo do funcionário.
     * 
     * @param cargo O cargo do funcionário.
     */
    public void setCargo(String cargo) {
        this.cargo = cargo;
    }

    /**
     * Método abstrato para realizar uma tarefa específica do funcionário.
     * 
     * Esta classe abstrata não implementa este método, pois a implementação
     * específica varia dependendo do tipo de funcionário.
     */
    public abstract void realizarTarefa();
}
