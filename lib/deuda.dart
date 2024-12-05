import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DeudaPage extends StatelessWidget {
  final String apiUrl = "https://uasdapi.ia3x.com/deudas";

  Future<List<Map<String, dynamic>>> fetchDeudas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('authToken');

    if (authToken == null || authToken.isEmpty) {
      throw Exception('Token de autenticación no encontrado. Por favor, inicia sesión.');
    }

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody is List) {
        return responseBody.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Formato de datos inesperado: ${responseBody.runtimeType}');
      }
    } else {
      throw Exception('Error en la solicitud (HTTP ${response.statusCode}): ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deudas'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchDeudas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            final deudas = snapshot.data!;
            if (deudas.isEmpty) {
              return const Center(child: Text("No se encontraron deudas."));
            }
            return ListView.builder(
              itemCount: deudas.length,
              itemBuilder: (context, index) {
                final deuda = deudas[index];
                final monto = deuda['monto'] ?? 0;
                final pagada = deuda['pagada'] == true ? "Pagada" : "Pendiente";
                final fecha = deuda['fechaActualizacion'] ?? "Sin fecha";

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text("Deuda: \$${monto.toString()}"),
                    subtitle: Text("Estado: $pagada\nÚltima actualización: $fecha"),
                    onTap: () {
                      // Puedes agregar una navegación para más detalles aquí
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Detalle de deuda"),
                          content: Text("Monto: \$${monto.toString()}\nEstado: $pagada\nÚltima actualización: $fecha"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Cerrar"),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("No se encontraron deudas."));
          }
        },
      ),
    );
  }
}
