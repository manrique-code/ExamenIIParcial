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

        //querys de reacciones

    }
}
