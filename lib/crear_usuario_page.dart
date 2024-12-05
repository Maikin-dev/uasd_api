import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CrearUsuarioPage extends StatefulWidget {
  @override
  _CrearUsuarioPageState createState() => _CrearUsuarioPageState();
}

class _CrearUsuarioPageState extends State<CrearUsuarioPage> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _authTokenController = TextEditingController();

  Future<void> _crearUsuario() async {
    final response = await http.post(
      Uri.parse('https://uasdapi.ia3x.com/crear_usuario'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': 0,
        'nombre': _nombreController.text,
        'apellido': _apellidoController.text,
        'username': _usernameController.text,
        'password': _passwordController.text,
        'email': _emailController.text,
        'authToken': _authTokenController.text,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario creado exitosamente')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al crear el usuario')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Usuario')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _apellidoController,
              decoration: const InputDecoration(labelText: 'Apellido'),
            ),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Usuario'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _authTokenController,
              decoration: const InputDecoration(labelText: 'Auth Token'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _crearUsuario,
              child: const Text('Crear Usuario'),
            ),
          ],
        ),
      ),
    );
  }
}