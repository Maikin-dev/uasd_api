import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MisSolicitudesPage extends StatefulWidget {
  @override
  _MisSolicitudesPageState createState() => _MisSolicitudesPageState();
}

class _MisSolicitudesPageState extends State<MisSolicitudesPage> {
  List<dynamic> misSolicitudes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMisSolicitudes();
  }

  Future<void> fetchMisSolicitudes() async {
    final url = Uri.parse("https://uasdapi.ia3x.com/mis_solicitudes");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          misSolicitudes = data['data'];
          isLoading = false;
        });
      } else {
        throw Exception("Error al cargar las solicitudes");
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
        title: const Text("Mis Solicitudes"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : misSolicitudes.isEmpty
              ? const Center(child: Text("No tienes solicitudes realizadas"))
              : ListView.builder(
                  itemCount: misSolicitudes.length,
                  itemBuilder: (context, index) {
                    final solicitud = misSolicitudes[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: Icon(
                          solicitud['estado'] == 'pendiente'
                              ? Icons.access_time
                              : Icons.check_circle,
                          color: solicitud['estado'] == 'pendiente' ? Colors.orange : Colors.green,
                        ),
                        title: Text(
                          solicitud['tipo_solicitud'] ?? "Sin tipo",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("Estado: ${solicitud['estado']}"),
                      ),
                    );
                  },
                ),
    );
  }
}
