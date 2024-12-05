import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TipoSolicitudPage extends StatefulWidget {
  @override
  _TipoSolicitudPageState createState() => _TipoSolicitudPageState();
}

class _TipoSolicitudPageState extends State<TipoSolicitudPage> {
  List<dynamic> tiposSolicitudes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTiposSolicitudes();
  }

  Future<void> fetchTiposSolicitudes() async {
    final url = Uri.parse("https://uasdapi.ia3x.com/tipos_solicitudes");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          tiposSolicitudes = data['data'];
          isLoading = false;
        });
      } else {
        throw Exception("Error al cargar los tipos de solicitudes");
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
        title: const Text("Tipos de Solicitudes"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : tiposSolicitudes.isEmpty
              ? const Center(child: Text("No hay tipos de solicitudes disponibles"))
              : ListView.builder(
                  itemCount: tiposSolicitudes.length,
                  itemBuilder: (context, index) {
                    final solicitud = tiposSolicitudes[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.article,
                          color: Colors.blue,
                        ),
                        title: Text(
                          solicitud['descripcion'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Seleccionaste: ${solicitud['descripcion']}")),
                            );
                          },
                          child: const Text("Seleccionar"),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
