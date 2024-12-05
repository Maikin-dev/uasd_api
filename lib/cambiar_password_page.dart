import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CambiarPasswordPage extends StatefulWidget {
  @override
  _CambiarPasswordPageState createState() => _CambiarPasswordPageState();
}

class _CambiarPasswordPageState extends State<CambiarPasswordPage> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  Future<void> _cambiarPassword() async {
    final response = await http.post(
      Uri.parse('https://uasdapi.ia3x.com/cambiar_password'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'oldPassword': _oldPasswordController.text,
        'newPassword': _newPasswordController.text,
        'confirmPassword': _confirmPasswordController.text,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contraseña cambiada exitosamente')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al cambiar la contraseña')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cambiar Contraseña')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _oldPasswordController,
              decoration: const InputDecoration(labelText: 'Contraseña Antigua'),
              obscureText: true,
            ),
            TextField(
              controller: _newPasswordController,
              decoration: const InputDecoration(labelText: 'Nueva Contraseña'),
              obscureText: true,
            ),
            TextField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(labelText: 'Confirmar Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _cambiarPassword,
              child: const Text('Cambiar Contraseña'),
            ),
          ],
        ),
      ),
    );
  }
}