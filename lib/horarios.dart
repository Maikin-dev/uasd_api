import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HorariosPage extends StatelessWidget {
  final String apiUrl = "https://uasdapi.ia3x.com/eventos";

  Future<List<Map<String, dynamic>>> fetchHorarios() async {
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
        title: const Text('Horarios'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchHorarios(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            final horarios = snapshot.data!;
            if (horarios.isEmpty) {
              return const Center(child: Text("No se encontraron horarios."));
            }
            return ListView.builder(
              itemCount: horarios.length,
              itemBuilder: (context, index) {
                final horario = horarios[index];
                final title = horario['titulo'] ?? 'Sin título';
                final hora = horario['fechaEvento'] ?? 'Sin hora';
                final aula = horario['lugar'] ?? 'Sin aula';
                final ubicacion = (horario['coordenadas'] as String?)?.split(',') ?? ['0.0', '0.0'];

                // Validación de coordenadas
                if (ubicacion.length < 2) {
                  ubicacion.addAll(['0.0', '0.0']);
                }
                final latitud = double.tryParse(ubicacion[0]) ?? 0.0;
                final longitud = double.tryParse(ubicacion[1]) ?? 0.0;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(title),
                    subtitle: Text("Hora: $hora - Aula: $aula"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AulaMapaPage(
                            aula: aula,
                            lat: latitud,
                            lng: longitud,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("No se encontraron horarios."));
          }
        },
      ),
    );
  }
}

class AulaMapaPage extends StatelessWidget {
  final String aula;
  final double lat;
  final double lng;

  const AulaMapaPage({required this.aula, required this.lat, required this.lng});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ubicación del Aula: $aula"),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(lat, lng),
          zoom: 16,
        ),
        markers: {
          Marker(
            markerId: const MarkerId("aula"),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(title: "Aula $aula"),
          ),
        },
      ),
    );
  }
}
