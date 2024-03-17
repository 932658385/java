
    /**
     * Este projeto implementa classe para Filmes.
    */

    public class Filme{
        private String titulo;
        private int duracaoEmMinutos;
        private int min;
        private int hora;

        /**
         * Construtor para inicializar o Filme.
         * @param  titulo valor da primeira entrada.
         * @param duracaoEmMinutos O valor da segunda entrada.
         * @param min O valor da terceira entrada.
         * @param hora O valor da quarta entrada.
        */

        public Filme(String titulo, int duracaoEmMinutos) {
            this.titulo = titulo;
            this.duracaoEmMinutos = duracaoEmMinutos;
            this.min = min;
            this.hora = hora;
        }
        

        public String getTitulo() {
            return this.titulo;
        }

        public void setTitulo(String titulo) {
            this.titulo = titulo;
        }


        public int getDuracaoEmMinutos() {
            return this.duracaoEmMinutos;
        }

        public void setDuracaoEmMinutos(int duracaoEmMinutos) {
            this.duracaoEmMinutos = duracaoEmMinutos;
        }


        public int getMin() {
            return this.min;
        }

        public void setMin(int min) {
            this.min = min;
        }

        public int getHora() {
            return this.hora;
        }

        public void setHora(int hora) {
            this.hora = hora;
        }


        /**
         * Método para exibir a duração em horas do filme .
         * @return a duracaoo em horas do filme.
        */

        public void exibirDuracaoEmHoras(){

            this.min = getDuracaoEmMinutos() % 60;
            this.hora = getDuracaoEmMinutos() / 60;
            System.out.println("O filme " + getTitulo() + " possui " + getHora() + " horas e " + getMin() + " minutos ");
        }

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