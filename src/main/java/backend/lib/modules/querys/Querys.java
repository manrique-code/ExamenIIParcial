package backend.lib.modules.querys;

import org.json.JSONObject;

public class Querys {
    public static JSONObject querys;

    public static void init_querys(){
        querys = new JSONObject();

        // querys de cuentas
        querys.put("login", "CALL `sp_login`(?, ?);");
        querys.put("informacioGeneralCuenta", "CALL `sp_verCuentaPorID`(?);");

        // querys de mensajes
        querys.put("publicarMensaje", "CALL `sp_insertarMensaje`(?, ?, ?);");
        querys.put("verTodoMensajes", "CALL `sp_verTodosMensajesPorCuenta`(?);");

        //querys de tipo de mensajes
        querys.put("verTipoMensaje", "CALL `sp_verTipoMensajes`();");

        // querys de hora del servidor
        querys.put("obtenerHoraServidor", "SELECT TIME(NOW());");
    }
}
