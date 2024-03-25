/**
 * Classe que representa um funcionário do escritório em uma empresa.
 * Estende a classe Funcionario para herdar atributos e comportamentos gerais de um funcionário.
 */
public class FuncionarioEscritorio extends Funcionario {

    /**
     * Construtor da classe FuncionarioEscritorio.
     * 
     * @param nome O nome do funcionário do escritório.
     */
    public FuncionarioEscritorio(String nome) {
        super(nome, "Escritório");
    }

    /**
     * Método para realizar uma tarefa específica para funcionários do escritório.
     * 
     * Este método deve ser implementado conforme necessário para funcionários do escritório.
     */
    @Override
    public void realizarTarefa() {
        // Implementação específica para funcionários do escritório
    }
}