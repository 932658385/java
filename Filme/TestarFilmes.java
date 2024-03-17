public class TestarFilmes{
    public static void main(String[] args){
        Filme filme1 = new Filme("Titanic", 194);
        Filme filme2 = new Filme("Titanic2", 299);
        filme1.exibirDuracaoEmHoras();
        System.out.println("");

        filme1.setTitulo("Os Vingadores");
        filme1.setDuracaoEmMinutos(142);
        filme1.exibirDuracaoEmHoras();
        System.out.println("");

        System.out.println("----------------------------------");
        filme2.exibirDuracaoEmHoras();
        System.out.println("");

        filme2.setTitulo("Hotel Transilvânia");
        filme2.setDuracaoEmMinutos(93);
        filme2.exibirDuracaoEmHoras();
        System.out.println("");

        System.out.println("Os filmes em Cartaz são " +filme1.getTitulo()+ " e " + filme2.getTitulo());
    }
}