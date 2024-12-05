import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CrearSolicitudPage extends StatefulWidget {
  @override
  _CrearSolicitudPageState createState() => _CrearSolicitudPageState();
}

class _CrearSolicitudPageState extends State<CrearSolicitudPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tipoController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  bool isSubmitting = false;

  Future<void> crearSolicitud() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isSubmitting = true;
    });

    final url = Uri.parse("https://uasdapi.ia3x.com/crear_solicitud");
    final body = {
      "tipo": _tipoController.text.trim(),
      "descripcion": _descripcionController.text.trim(),
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["success"] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Solicitud creada exitosamente")),
          );
          Navigator.pop(context); // Volver a la página anterior
        } else {
          throw Exception(data["message"] ?? "Error al crear la solicitud");
        }
      } else {
        throw Exception("Error en el servidor: ${response.statusCode}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crear Solicitud"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _tipoController,
                decoration: const InputDecoration(
                  labelText: "Tipo de Solicitud",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor ingrese el tipo de solicitud";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descripcionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Descripción",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor ingrese una descripción";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: isSubmitting ? null : crearSolicitud,
                child: isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Enviar Solicitud"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
