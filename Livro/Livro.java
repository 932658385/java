/**
 * Este projeto implementa classe para Livros.
 */

public class Livro{
    private String titulo;
    private int qtdPaginas;
    private int paginasLidas;

    /**
     * Construtor para inicializar o Livro.
     * @param  titulo valor da primeira entrada.
     * @param qtdPaginas O valor da segunda entrada.
     * @param paginasLidas O valor da terceira entrada.
     */

    public Livro(String titulo, int qtdPaginas, int paginasLidas) {
        this.titulo = titulo;
        this.qtdPaginas = qtdPaginas;
        this.paginasLidas = paginasLidas;
    }
    

    public String getTitulo() {
        return this.titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }


    public int getQtdPaginas() {
        return this.qtdPaginas;
    }

    public void setQtdPaginas(int qtdPaginas) {
        this.qtdPaginas = qtdPaginas;
    }

    public int getPaginasLidas() {
        return this.paginasLidas;
    }

    public void setPaginasLidas(int paginasLidas) {
        this.paginasLidas = paginasLidas;
    }


    /**
     * Método para obter a percentagem das paginas lidas do livro.
     * @return O valor da percentagem.
    */
    public void verificarProgresso(){
        double porcentagem = (paginasLidas * 100) / qtdPaginas;
        System.out.println("Você já leu " +porcentagem+" por cento do livro");
    }
}