/**
 * A subclass of the Genio class representing a humorous genie.
 * This genie has the ability to grant an unlimited number of wishes with a good sense of humor.
 */
public class GenioBemHumorado extends Genio {
    
    /** 
     * The number of wishes granted by the humorous genie.
     */
    private int desejosConcedidos;

    /**
     * Constructs a GenioBemHumorado object with the number of granted wishes initialized to 0.
     */
    public GenioBemHumorado() {
        this.desejosConcedidos = 0;
    }

    /**
     * Grants a wish if the genie can do so.
     * @param desejos The number of wishes to grant.
     * @return true if the wish(es) can be granted, false otherwise.
     */
    @Override
    public boolean grantWish(int desejos) {
        if (canGrantWish()) {
            this.desejosConcedidos++;
            return true;
        }
        return false;
    }

    /**
     * Gets the total number of wishes granted by the genie.
     * @return The total number of wishes granted.
     */
    @Override
    public int getGrantedWishes() {
        return this.desejosConcedidos;
    }

    /**
     * Gets the remaining number of wishes that can be granted by the genie.
     * @return The remaining number of wishes that can be granted.
     */
    @Override
    public int getRemainingWishes() {
        return Integer.MAX_VALUE - this.desejosConcedidos;
    }

    /**
     * Checks if the genie can grant any more wishes.
     * @return true if the genie can grant more wishes, false otherwise.
     */
    @Override
    public boolean canGrantWish() {
        return this.desejosConcedidos < Integer.MAX_VALUE;
    }

    /**
     * Returns a string representation of the GenioBemHumorado object.
     * @return A string representation including the number of wishes granted.
     */
    @Override
    public String toString() {
        return "Génio bem-humorado concedeu " + this.desejosConcedidos + " desejos.";
    }
}