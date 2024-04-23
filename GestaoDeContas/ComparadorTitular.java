import java.util.Comparator;


/**
 * O comparador ComparadorTitular é usado para comparar dois titulares com base no número do cliente.
 * Ele implementa a interface Comparator para permitir a comparação de objetos do tipo Titular.
 */
class ComparadorTitular implements Comparator<Titular> {
    /**
     * Compara dois titulares com base no número do cliente.
     * 
     * @param t1 O primeiro titular a ser comparado
     * @param t2 O segundo titular a ser comparado
     * @return Um valor negativo, zero ou positivo se o primeiro titular for menor, igual ou maior que o segundo titular
     */
    @Override
    public int compare(Titular t1, Titular t2) {
        return t1.getNumeroCliente() - t2.getNumeroCliente();
    }
}