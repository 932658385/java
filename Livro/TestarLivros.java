public class TestarLivros{
    public static void main(String[] args){
        Livro livrofavorito = new Livro("Agente Noturno", 30, 7);
        livrofavorito.setTitulo("O Pequeno Príncipe");
        livrofavorito.setQtdPaginas(98);
        
        System.out.println("");
        System.out.println("O livro " + livrofavorito.getTitulo() + " Possui " + livrofavorito.getQtdPaginas() + " paginas ");
        System.out.println("");

        livrofavorito.setPaginasLidas(20);
        livrofavorito.verificarProgresso();
        livrofavorito.setQtdPaginas(50);
        livrofavorito.verificarProgresso();

    }
}