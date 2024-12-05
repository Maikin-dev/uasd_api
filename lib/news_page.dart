import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class NoticiasPage extends StatelessWidget {
  final String apiUrl = "https://uasdapi.ia3x.com/noticias";

  Future<List<dynamic>> fetchNoticias() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('authToken');

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody['success'] == true) {
        return responseBody['data'];
      } else {
        throw Exception(responseBody['message'] ?? 'Error al cargar las noticias');
      }
    } else {
      throw Exception('Error en la solicitud');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Noticias")),
      body: FutureBuilder(
        future: fetchNoticias(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            List noticias = snapshot.data!;
            return ListView.builder(
              itemCount: noticias.length,
              itemBuilder: (context, index) {
                final noticia = noticias[index];
                final title = noticia['title'] ?? 'Sin título';
                final description = noticia['description'] ?? 'Sin descripción';

                return ListTile(
                  title: Text(title),
                  subtitle: Text(description),
                  onTap: () {
                    // Abrir detalle de noticia
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}