import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MateriasDisponiblesPage extends StatefulWidget {
  @override
  _MateriasDisponiblesPageState createState() => _MateriasDisponiblesPageState();
}

class _MateriasDisponiblesPageState extends State<MateriasDisponiblesPage> {
  List<dynamic> materiasDisponibles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMateriasDisponibles();
  }

  Future<void> fetchMateriasDisponibles() async {
    final url = Uri.parse("https://uasdapi.ia3x.com/materias_disponibles");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          materiasDisponibles = data['data'];
          isLoading = false;
        });
      } else {
        throw Exception("Error al cargar las materias disponibles");
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

  Future<void> agregarMateria(String materiaId) async {
    final url = Uri.parse("https://uasdapi.ia3x.com/agregar_materia");
    try {
      final response = await http.post(
        url,
        body: json.encode({"materia_id": materiaId}),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Materia añadida a la preselección")),
        );
      } else {
        throw Exception("Error al añadir la materia");
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
        title: const Text("Materias Disponibles"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: materiasDisponibles.length,
              itemBuilder: (context, index) {
                final materia = materiasDisponibles[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(materia['nombre']),
                    trailing: ElevatedButton(
                      onPressed: () {
                        agregarMateria(materia['id']);
                      },
                      child: const Text("Agregar"),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
