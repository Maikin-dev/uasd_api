import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class VerPreseleccionPage extends StatefulWidget {
  @override
  _VerPreseleccionPageState createState() => _VerPreseleccionPageState();
}

class _VerPreseleccionPageState extends State<VerPreseleccionPage> {
  List<dynamic> preseleccion = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPreseleccion();
  }

  Future<void> fetchPreseleccion() async {
    final url = Uri.parse("https://uasdapi.ia3x.com/ver_preseleccion");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          preseleccion = data['data'];
          isLoading = false;
        });
      } else {
        throw Exception("Error al cargar la preselección");
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

  Future<void> cancelarPreseleccion() async {
    final url = Uri.parse("https://uasdapi.ia3x.com/cancelar_preseleccion");
    try {
      final response = await http.post(url);
      if (response.statusCode == 200) {
        setState(() {
          preseleccion = [];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Preselección cancelada")),
        );
      } else {
        throw Exception("Error al cancelar la preselección");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Preselección Actual"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : preseleccion.isEmpty
              ? const Center(child: Text("No hay materias preseleccionadas"))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: preseleccion.length,
                        itemBuilder: (context, index) {
                          final materia = preseleccion[index];
                          return ListTile(
                            title: Text(materia['nombre']),
                          );
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: cancelarPreseleccion,
                      child: const Text("Cancelar Preselección"),
                    ),
                  ],
                ),
    );
  }
}
