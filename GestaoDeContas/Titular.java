/**
 * Representa um titular de uma conta bancária.
 */
public class Titular {
    private String nome;
    private int numeroCliente;

    /**
     * Cria um novo titular com o nome e número de cliente especificados.
     *
     * @param nome o nome do titular
     * @param numeroCliente o número de cliente do titular
     */
    public Titular(String nome, int numeroCliente) {
        this.nome = nome;
        this.numeroCliente = numeroCliente;
    }

    /**
     * Obtém o nome do titular.
     *
     * @return o nome do titular
     */
    public String getNome() {
        return nome;
    }

    /**
     * Define o nome do titular.
     *
     * @param nome o novo nome do titular
     */
    public void setNome(String nome) {
        this.nome = nome;
    }

    /**
     * Obtém o número de cliente do titular.
     *
     * @return o número de cliente do titular
     */
    public int getNumeroCliente() {
        return numeroCliente;
    }

    /**
     * Define o número de cliente do titular.
     *
     * @param numeroCliente o novo número de cliente do titular
     */
    public void setNumeroCliente(int numeroCliente) {
        this.numeroCliente = numeroCliente;
    }

    /**
     * Verifica se este titular é igual a outro titular com base no número de cliente.
     *
     * @param outro o outro titular a ser comparado
     * @return true se os titulares tiverem o mesmo número de cliente, false caso contrário
     */
    public boolean equals(Titular outro) {
        return this.numeroCliente == outro.getNumeroCliente();
    }
}