package backend.lib;

import backend.lib.controllers.ReqRes;
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
               JSONObject respuestaServidor = new JSONObject();
               JSONObject payload = new JSONObject();

               String usuario = requestCliente.getJSONObject("payload").getString("usuario");
               String contra = requestCliente.getJSONObject("payload").getString("contraseña");

                if(usuario.equals("srios") && contra.equals("movil1")){
                    payload.put("message", "Iniciada la sesión");
                    respuestaServidor.put("status", "correcto");
                    respuestaServidor.put("payload", payload);
                } else {
                    payload.put("message", "Usuario o contraseña incorrectos");
                    respuestaServidor.put("status", "incorrecto");
                    respuestaServidor.put("payload", payload);
                }
                ReqRes.sendResponse(httpExchange,respuestaServidor);
            });

            server.setExecutor(null);
            server.start();

        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
