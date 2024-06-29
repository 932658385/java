public class EstatisticasIndividuais {
    private int passes;
    private int assistencias;
    private int remates;
    private int minutosJogados;

    public EstatisticasIndividuais(int passes, int assistencias, int remates, int minutosJogados) {
        this.passes = passes;
        this.assistencias = assistencias;
        this.remates = remates;
        this.minutosJogados = minutosJogados;
    }

    public int getPasses() {return passes;}
    public void setPasses(int passes) {this.passes = passes;}

    public int getAssistencias() {return assistencias;}
    public void setAssistencias(int assistencias) {this.assistencias = assistencias;}

    public int getRemates() {return remates;}
    public void setRemates(int remates) {this.remates = remates;}

    public int getMinutosJogados() {return minutosJogados;}
    public void setMinutosJogados(int minutosJogados) {this.minutosJogados = minutosJogados;}
}