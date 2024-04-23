
import java.util.Comparator;

/**
 * O comparador ComparadorContaBancaria é usado para comparar duas contas bancárias com base no número da conta.
 * Ele implementa a interface Comparator para permitir a comparação de objetos do tipo ContaBancaria.
 */
class ComparadorContaBancaria implements Comparator<ContaBancaria> {
    /**
     * Compara duas contas bancárias com base no número da conta.
     * 
     * @param c1 A primeira conta bancária a ser comparada
     * @param c2 A segunda conta bancária a ser comparada
     * @return Um valor negativo, zero ou positivo se a primeira conta for menor, igual ou maior que a segunda conta
     */
    @Override
    public int compare(ContaBancaria c1, ContaBancaria c2) {
        return c1.getNumeroConta() - c2.getNumeroConta();
    }
}