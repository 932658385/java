/**
 * Classe base que representa um gênio.
 * Esta classe contém métodos que devem ser implementados nas subclasses.
 */

public class Genio {
   
    public boolean grantWish(int desejos) { return false; }
    public int getGrantedWishes() { return 0; }
    public int getRemainingWishes() { return 0; }
    public boolean canGrantWish() { return false; }
    public String toString() { return ""; }
}