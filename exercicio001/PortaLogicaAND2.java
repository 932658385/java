/*Nome: Augusto Cambamba
  Id: 28867
  Eng Informática  
 */

/**
 * Este projeto implementa classes para portas lógicas AND de 2 e 3 entradas.
 */
 
// Classe para a porta lógica AND de 2 entradas
public class PortaLogicaAND2 
{
    private boolean in1;
    private boolean in2;

    /**
     * Construtor para inicializar as entradas da porta lógica AND de 2 entradas.
     * @param in1 O valor da primeira entrada.
     * @param in2 O valor da segunda entrada.
     */
    public PortaLogicaAND2(boolean in1, boolean in2) 
    {
        this.in1 = in1;
        this.in2 = in2;
    }

    /**
     * Método para obter as entradas da porta lógica AND de 2 entradas.
     * @return Uma string contendo os valores das entradas.
     */
    public String obterEntradas() 
    {
        return "Entrada 1: " + in1 + ", Entrada 2: " + in2;
    }

    /**
     * Método para obter a saída da porta lógica AND de 2 entradas.
     * @return O valor da saída da porta lógica AND.
     */
    public boolean obterSaida() 
    {
        return in1 && in2;
    }
}

// Classe para a porta lógica AND de 3 entradas
public class PortaLogicaAND3 
{
    /**
     * Método para obter a saída da porta lógica AND de 3 entradas.
     * @param in1 O valor da primeira entrada.
     * @param in2 O valor da segunda entrada.
     * @param in3 O valor da terceira entrada.
     * @return O valor da saída da porta lógica AND.
     */
    public static boolean obterSaida(boolean in1, boolean in2, boolean in3) 
    {
        // Calculando a saída da porta lógica AND de 3 entradas
        PortaLogicaAND2 porta1 = new PortaLogicaAND2(in1, in2);
        boolean saida1 = porta1.obterSaida();
        
        // Calculando a porta AND entre a saída anterior e a terceira entrada
        PortaLogicaAND2 porta2 = new PortaLogicaAND2(saida1, entrada3);
        return porta2.obterSaida();
    }
}

// Classe para testar as portas lógicas AND
public class TestePortaLogicaAND 
{
    public static void main(String[] args) 
    {
        // Testando a porta AND de duas entradas
        PortaLogicaAND2 porta2 = new PortaLogicaAND2(true, false);
        System.out.println("Entradas: " + porta2.obterEntradas());
        System.out.println("Saída: " + porta2.obterSaida());

        // Testando a porta AND de três entradas
        boolean in1 = true;
        boolean in2 = false;
        boolean in3 = true;
        boolean saida = PortaLogicaAND3.obterSaida(in1, in2, in3);
        System.out.println("\nEntradas: " + in1 + ", " + in2 + ", " + in3);
        System.out.println("Saída: " + saida);
    }
}