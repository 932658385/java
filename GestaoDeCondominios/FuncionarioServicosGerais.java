/**
 * Classe que representa um funcionário de serviços gerais em uma empresa.
 * Estende a classe Funcionario para herdar atributos e comportamentos gerais de um funcionário.
 */
public class FuncionarioServicosGerais extends Funcionario {

    /**
     * Construtor da classe FuncionarioServicosGerais.
     * 
     * @param nome O nome do funcionário de serviços gerais.
     */
    public FuncionarioServicosGerais(String nome) {
        super(nome, "Serviços Gerais");
    }

    /**
     * Método para realizar uma tarefa específica para funcionários de serviços gerais.
     * 
     * Este método deve ser implementado conforme necessário para funcionários de serviços gerais.
     */
    @Override
    public void realizarTarefa() {
        // Implementação específica para funcionários de serviços gerais
    }
}