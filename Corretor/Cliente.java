/**
 * Classe para representar um cliente da firma de investimentos.
 */
public class Cliente {
    private int id;
    private String nome;
    private String telefone;

    /**
     * Construtor para a classe Cliente.
     * 
     * @param id O identificador único do cliente.
     * @param nome O nome do cliente.
     * @param telefone O número de telefone do cliente.
     */
    public Cliente(int id, String nome, String telefone) {
        this.id = id;
        this.nome = nome;
        this.telefone = telefone;
    }

    /**
     * Obtém o ID do cliente.
     * 
     * @return O ID do cliente.
     */
    public int getId() {
        return id;
    }

    /**
     * Define o ID do cliente.
     * 
     * @param id O ID do cliente.
     */
    public void setId(int id) {
        this.id = id;
    }

    /**
     * Obtém o nome do cliente.
     * 
     * @return O nome do cliente.
     */
    public String getNome() {
        return nome;
    }

    /**
     * Define o nome do cliente.
     * 
     * @param nome O nome do cliente.
     */
    public void setNome(String nome) {
        this.nome = nome;
    }

    /**
     * Obtém o número de telefone do cliente.
     * 
     * @return O número de telefone do cliente.
     */
    public String getTelefone() {
        return telefone;
    }

    /**
     * Define o número de telefone do cliente.
     * 
     * @param telefone O número de telefone do cliente.
     */
    public void setTelefone(String telefone) {
        this.telefone = telefone;
    }
}
