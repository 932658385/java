import java.util.List;
import java.util.ArrayList;

/**
 * Classe abstrata que representa um edifício.
 * Define atributos e métodos comuns a todos os tipos de edifícios.
 */
public abstract class Edificio {
    private String endereco; // Endereço do edifício
    private List<Conta> contas; // Lista de contas relacionadas ao edifício

    /**
     * Construtor da classe Edificio.
     * 
     * @param endereco O endereço do edifício.
     */
    public Edificio(String endereco) {
        this.endereco = endereco;
        this.contas = new ArrayList<>();
    }

    /**
     * Obtém o endereço do edifício.
     * 
     * @return O endereço do edifício.
     */
    public String getEndereco() {
        return this.endereco;
    }

    /**
     * Define o endereço do edifício.
     * 
     * @param endereco O endereço do edifício.
     */
    public void setEndereco(String endereco) {
        this.endereco = endereco;
    }

    /**
     * Obtém a lista de contas relacionadas ao edifício.
     * 
     * @return A lista de contas relacionadas ao edifício.
     */
    public List<Conta> getContas() {
        return this.contas;
    }

    /**
     * Define a lista de contas relacionadas ao edifício.
     * 
     * @param contas A lista de contas relacionadas ao edifício.
     */
    public void setContas(List<Conta> contas) {
        this.contas = contas;
    }

    /**
     * Método abstrato para gerar um relatório do edifício.
     * 
     * Este método deve ser implementado por cada subclasse para gerar o relatório específico do edifício.
     */
    public abstract void gerarRelatorio();

    /**
     * Método abstrato para gerar um orçamento para o edifício.
     * 
     * Este método deve ser implementado por cada subclasse para gerar o orçamento específico do edifício.
     */
    public abstract void gerarOrcamento();
}