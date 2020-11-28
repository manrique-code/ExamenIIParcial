package backend.lib.modules.datos;

import backend.lib.modules.querys.Querys;
import org.json.JSONObject;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DUsuario {
    PreparedStatement ps;
    ResultSet rs;

    public JSONObject loginValidation(JSONObject datosCliente, Connection conn){
        Querys.init_querys();

        JSONObject loginData = new JSONObject();
        JSONObject usuarioData = new JSONObject();

        try {
            String user = datosCliente.getJSONObject("payload").getString("usuario");
            String contra = datosCliente.getJSONObject("payload").getString("contraseña");

            ps = conn.prepareStatement(Querys.querys.getString("login"));
            ps.setString(1, user);
            ps.setString(2, contra);

            rs = ps.executeQuery();

            if(rs.next()){
                loginData.put("status", "Correcto");

                usuarioData.put("mensaje", "Iniciando sesión");
                usuarioData.put("IdCuenta", rs.getString("IdCuenta"));
            } else {
                loginData.put("status", "Incorrecto");
                usuarioData.put("mensaje", "Usuario o contraseña incorrectos");
            }

            loginData.put("usuarioData", usuarioData);

        } catch(SQLException e){
            e.printStackTrace();
        }

        return loginData;
    }

    public JSONObject obtenerInfoCuenta(JSONObject datosCliente, Connection conn){
        Querys.init_querys();
        JSONObject cuentaData = new JSONObject();
        JSONObject respuestaServidor = new JSONObject();

        try{
            int IdCuenta = datosCliente.getJSONObject("payload").getInt("IdCuenta");

            ps = conn.prepareStatement(Querys.querys.getString("informacioGeneralCuenta"));
            ps.setInt(1, IdCuenta);

            rs = ps.executeQuery();

            if(rs.next()){
                respuestaServidor.put("status", "Correcto");

                cuentaData.put("NombrePersona", rs.getString("NombrePersona"));
                cuentaData.put("ApellidoPersona", rs.getString("ApellidoPersona"));
                cuentaData.put("FechaNacimiento", rs.getString("FechaNacimiento"));
                cuentaData.put("Sexo", rs.getString("NombreSexo"));
                cuentaData.put("NombreCuenta", rs.getString("NombreCuenta"));
                cuentaData.put("FechaCreacionCuenta", rs.getString("FechaCreacionCuenta"));
            }

        }catch(SQLException e){
            e.printStackTrace();
        }
        return respuestaServidor.put("cuentaData", cuentaData);
    }
}
