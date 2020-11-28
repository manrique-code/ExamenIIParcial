package backend.lib;

import backend.lib.controllers.ReqRes;
import backend.lib.modules.DBManager;
import backend.lib.modules.datos.DMensajes;
import backend.lib.modules.datos.DUsuario;
import com.sun.net.httpserver.HttpContext;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpServer;
import org.json.JSONObject;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.util.concurrent.Executor;

public class Server {
    public static void main(String[] args) {
        try{
            HttpServer server = HttpServer.create(new InetSocketAddress(4000), 0);

            // inicializando la conexión con la base de datos.
            DBManager.inti_db();
            DUsuario dUsuario = new DUsuario();
            DMensajes dMensajes = new DMensajes();

            // inicializando la capa de datos que se conecta con la base de datos


            // response para ver el nombre y la versión de la app
            server.createContext("/", (httpExchange) -> {
                JSONObject jres = new JSONObject();
                jres.put("Nombre", "Idea");
                jres.put("Versión", "1.0.0");

                ReqRes.sendResponse(httpExchange, jres);
            });

            // response para el login
            server.createContext("/login", (httpExchange) -> {
                JSONObject requestCliente = ReqRes.getRequest(httpExchange);
                JSONObject respuestaServidor;

                respuestaServidor = dUsuario.loginValidation(requestCliente, DBManager.conn);

                ReqRes.sendResponse(httpExchange, respuestaServidor);
            });

            // response para la cuenta
            server.createContext("/cuenta", (httpExchange) -> {
               JSONObject requestCliente = ReqRes.getRequest(httpExchange);
               JSONObject respuestaServidor;

               respuestaServidor = dUsuario.obtenerInfoCuenta(requestCliente, DBManager.conn);

               ReqRes.sendResponse(httpExchange, respuestaServidor);
            });

            // response para publicar un mensaje
            server.createContext("/publicar_mensaje", (httpExchange) -> {
               JSONObject requestCliente = ReqRes.getRequest(httpExchange);
               JSONObject respuestaServidor;

                respuestaServidor = dMensajes.publicarMensaje(requestCliente, DBManager.conn);

                ReqRes.sendResponse(httpExchange, respuestaServidor);
            });

            server.setExecutor(null);
            server.start();

        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
