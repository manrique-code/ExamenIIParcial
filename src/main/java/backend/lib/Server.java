package backend.lib;

import com.sun.net.httpserver.HttpContext;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpServer;
import org.json.JSONObject;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.util.concurrent.Executor;

public class Server {
    public static void main(String[] args) {
        HttpServer server = null;
        try {
            server = HttpServer.create(new InetSocketAddress(4000), 0);

            // request para ver el nombre y la versión de la app
            server.createContext("/", (httpExchange) -> {
                JSONObject jres = new JSONObject();

                jres.put("Nombre", "");
            });

            server.setExecutor(null);
            server.start();

        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
