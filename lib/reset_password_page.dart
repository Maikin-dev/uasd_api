import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  Future<void> _resetPassword() async {
    final response = await http.post(
      Uri.parse('https://uasdapi.ia3x.com/reset_password'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'usuario': _usuarioController.text,
        'email': _emailController.text,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Solicitud de restablecimiento enviada')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al enviar la solicitud')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Restablecer Contraseña')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usuarioController,
              decoration: const InputDecoration(labelText: 'Usuario'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetPassword,
              child: const Text('Restablecer Contraseña'),
            ),
          ],
        ),
      ),
    );
  }
}