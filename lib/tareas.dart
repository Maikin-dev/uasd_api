import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TareasPage extends StatefulWidget {
  @override
  TareasPageState createState() => TareasPageState();
}

class TareasPageState extends State<TareasPage> {
  List<Map<String, dynamic>> tareas = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEventos();
  }

  Future<void> fetchEventos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('authToken');

    if (authToken == null || authToken.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Token no válido o no encontrado.")),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    final url = Uri.parse("https://uasdapi.ia3x.com/tareas");
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          setState(() {
            tareas = data.cast<Map<String, dynamic>>();
            isLoading = false;
          });
        } else {
          throw Exception("Formato de datos inesperado.");
        }
      } else {
        throw Exception("Error en la solicitud (HTTP ${response.statusCode}): ${response.reasonPhrase}");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tareas de la UASD"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : tareas.isEmpty
              ? const Center(child: Text("No hay Tareas actualmente."))
              : ListView.builder(
                  itemCount: tareas.length,
                  itemBuilder: (context, index) {
                    final tarea = tareas[index];
                    final titulo = tarea['titulo'] ?? 'Sin título';
                    final descripcion = tarea['descripcion'] ?? 'Sin descripción';
                    final completada = tarea['lugar'] ?? '';
                    final fechaVencimiento = tarea['fechaEvento'] ?? '';

                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: const Icon(Icons.event, color: Colors.blue),
                        title: Text(titulo),
                        subtitle: Text("Estado\nFecha"),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetalleEventoPage(
                                evento: tarea,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}

class DetalleEventoPage extends StatelessWidget {
  final Map<String, dynamic> evento;

  const DetalleEventoPage({Key? key, required this.evento}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titulo = evento['titulo'] ?? 'Sin título';
    final descripcion = evento['descripcion'] ?? 'Sin descripción';
    final completada = evento['completada'] ?? 'Sin lugar ';
    final fechaVencimiento = evento['fechaVencimiento'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.date_range, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  "Fecha: $fechaVencimiento",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.place, color: Colors.red),
                const SizedBox(width: 8),
                Text(
                  "Completada: $completada",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              "Descripción:",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              descripcion,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
