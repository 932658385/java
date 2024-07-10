package conexao;
 
import java.sql.Connection;
import java.sql.DriverManager;
import java.lang.Exception;
//import java.io.FilterOutputStream;

public class Conexao {
	 String driver = "org.postgresql.Driver";
     String url = "jdbc:postgresql://localhost:5432/EuroAlemanha2024";
     String user = "postgres";
	private String password = "atac";
	
	// Modulo de conexao
	public Connection getConexao() {
		Connection con = null;  
		try {
			Class.forName(driver);
			con = DriverManager.getConnection(url, user, password);

			return con;

		} catch (Exception e) {
			// TODO: handle exception
			//System.out.println(e);
			return null;
		}

	}

	public void testeConexao() {
		try {
			Connection con = getConexao();
			//System.out.println(con);
			con.close();

		} catch (Exception e) {
			// TODO: handle exception
			//System.out.println(e);

		}
	}
}