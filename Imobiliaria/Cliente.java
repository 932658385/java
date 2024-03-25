/**
 * Classe para representar um cliente da imobiliária.
 */
public class Cliente {
    private String nome;
    private String telefone;
    private String login;
    private String senha;

    /**
     * Construtor para a classe Cliente.
     * 
     * @param nome O nome do cliente.
     * @param telefone O número de telefone do cliente.
     * @param login O login do cliente.
     * @param senha A senha do cliente.
     */
    public Cliente(String nome, String telefone, String login, String senha) {
        this.nome = nome;
        this.telefone = telefone;
        this.login = login;
        this.senha = senha;
    }

    /**
     * Obtém o nome do cliente.
     * 
     * @return O nome do cliente.
     */
    public String getNome() {
        return this.nome;
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
        return this.telefone;
    }

    /**
     * Define o número de telefone do cliente.
     * 
     * @param telefone O número de telefone do cliente.
     */
    public void setTelefone(String telefone) {
        this.telefone = telefone;
    }

    /**
     * Obtém o login do cliente.
     * 
     * @return O login do cliente.
     */
    public String getLogin() {
        return this.login;
    }

    /**
     * Define o login do cliente.
     * 
     * @param login O login do cliente.
     */
    public void setLogin(String login) {
        this.login = login;
    }

    /**
     * Obtém a senha do cliente.
     * 
     * @return A senha do cliente.
     */
    public String getSenha() {
        return this.senha;
    }

    /**
     * Define a senha do cliente.
     * 
     * @param senha A senha do cliente.
     */
    public void setSenha(String senha) {
        this.senha = senha;
    }
}