import java.util.Date;

/**
 * Representa a conta corrente de um cliente na firma de investimentos.
 */
public class ContaCorrente {
    // Atributos e métodos relacionados com a conta corrente

    /**
     * Calcula os juros devido ao atraso no pagamento com base na data atual e na data de vencimento.
     * 
     * @param valorOriginal O valor original da transação.
     * @param dataVencimento A data de vencimento da transação.
     * @param dataAtual A data atual para calcular os juros de atraso.
     * @param taxaJurosDiaria A taxa de juros diária a ser aplicada em caso de atraso.
     * @return Os juros devidos devido ao atraso no pagamento.
     */
    public double calcularJurosAtraso(double valorOriginal, Date dataVencimento, Date dataAtual, double taxaJurosDiaria) {
        long diffEmMillis = dataAtual.getTime() - dataVencimento.getTime();
        if (diffEmMillis <= 0) {
            // Não há atraso, portanto, nenhum juro é devido
            return 0.0;
        }

        // Converter o intervalo de tempo em dias
        long diffEmDias = diffEmMillis / (1000 * 60 * 60 * 24);

        // Calcular os juros devido ao atraso
        double juros = valorOriginal * (taxaJurosDiaria / 100) * diffEmDias;
        return juros;
    }
}
