package backend.lib.controllers;

import com.sun.net.httpserver.HttpExchange;
import org.json.JSONObject;

import java.io.*;
import java.nio.charset.StandardCharsets;

public class ReqRes {

    public static JSONObject getRequest(HttpExchange he) throws IOException {
        InputStream is = he.getRequestBody();
        InputStreamReader lectorBinario = new InputStreamReader(is, "utf-8");
        BufferedReader br = new BufferedReader(lectorBinario);
        StringBuilder buf = new StringBuilder(512);

        int b;
        while((b = br.read()) != -1){
        buf.append((char)b);
        }

        br.close();
        lectorBinario.close();

        return new JSONObject(buf.toString());
    }

    public static void sendResponse(HttpExchange he, JSONObject jrespond) throws IOException{
        he.getResponseHeaders().set("Content-Type", "application/json; charset=UTF-8");
        byte[] bytes = jrespond.toString().getBytes(StandardCharsets.UTF_8);
        he.sendResponseHeaders(200, bytes.length);
        OutputStream os = he.getResponseBody();
        os.write(bytes);
        os.close();
    }

}
