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

    public JSONObject verMensajes(JSONObject datosCliente, Connection conn){
        Querys.init_querys();

        JSONObject respuestaServidor = new JSONObject();
        JSONObject datosMensaje = new JSONObject();
        JSONObject mensajes = new JSONObject();

        try{
            int IdCuenta = datosCliente.getJSONObject("payload").getInt("IdCuenta");
            int i = 0;

            ps = conn.prepareStatement(Querys.querys.getString("verTodoMensajes"));
            ps.setInt(1, IdCuenta);
            rs = ps.executeQuery();

            while(rs.next()){
                datosMensaje.put(String.format("ContenidoMensaje%d", i), rs.getString("ContenidoMensaje"));
                datosMensaje.put(String.format("FechaMensaje%d", i), rs.getString("Fecha"));
                datosMensaje.put(String.format("HoraMensaje%d", i), rs.getString("Hora"));
                datosMensaje.put(String.format("TipoMensaje%d", i),rs.getString("NombreTipoMensaje"));
                datosMensaje.put(String.format("UserName%d", i), rs.getString("NombreCuenta"));
                datosMensaje.put(String.format("Nombre%d", i), rs.getString("NombrePersona"));
                datosMensaje.put(String.format("Apellido%d", i), rs.getString("ApellidoPersona"));
                i++;
            }
            mensajes.put("CantidadMensajes", i);
            mensajes.put("Mensajes", datosMensaje);

            respuestaServidor.put("datosMensajes", mensajes);
        }catch(SQLException e){
            e.printStackTrace();
        }

        return respuestaServidor;
    }

    public JSONObject verTipoMensaje(Connection conn){
        Querys.init_querys();

        JSONObject respuestaServidor = new JSONObject();
        JSONObject datosTipoMensaje = new JSONObject();

        try{
            int cant = 0;

            ps = conn.prepareStatement(Querys.querys.getString("verTipoMensaje"));
            rs = ps.executeQuery();

            while(rs.next()){
                datosTipoMensaje.put(String.format("CodigoTipoMensaje%d", cant), rs.getString("CodTipoMensaje"));
                datosTipoMensaje.put(String.format("NombreTipoMensaje%d", cant), rs.getString("NombreTipoMensaje"));
                cant++;
            }
            respuestaServidor.put("CantTipoMensaje", cant);
            respuestaServidor.put("payload",datosTipoMensaje);

        } catch(Exception e){
            e.printStackTrace();
        }

        return respuestaServidor;
    }
}
