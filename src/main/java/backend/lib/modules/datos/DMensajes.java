package backend.lib.modules.datos;

import backend.lib.modules.querys.Querys;
import org.json.JSONObject;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DMensajes {
    PreparedStatement ps;
    ResultSet rs;

    public JSONObject publicarMensaje(JSONObject datosCliente, Connection conn){
        Querys.init_querys();

        JSONObject respuestaServidor = new JSONObject();

        try{
            String mensaje = datosCliente.getJSONObject("payload").getString("ContenidoMensaje");
            String tipoMensaje = datosCliente.getJSONObject("payload").getString("TipoMensaje");
            int IdCuenta = datosCliente.getJSONObject("payload").getInt("IdCuenta");

            ps = conn.prepareStatement(Querys.querys.getString("publicarMensaje"));
            ps.setString(1, mensaje);
            ps.setString(2, tipoMensaje);
            ps.setInt(3, IdCuenta);
            ps.execute();

            respuestaServidor.put("mensaje", "Mensaje publicado");
            respuestaServidor.put("status", "Correcto");
        } catch(SQLException e){
            e.printStackTrace();
        }

        return respuestaServidor;
    }
}
