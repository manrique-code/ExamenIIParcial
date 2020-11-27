package edu.icc;

import org.json.JSONObject;

public class Server {
    public static void main(String[] args) {
        JSONObject saludo = new JSONObject();

        saludo.put("Saludo", "Hola Mundo");

        System.out.println(saludo.getString("Saludo"));
    }
}
