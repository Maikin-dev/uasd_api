import 'package:flutter/material.dart';
import 'news_page.dart';
import 'horarios.dart';
import 'seleccion.dart';
import 'deuda.dart';
import 'solicitudes_page.dart';
import 'tareas.dart';
import 'eventos.dart';
import 'videos.dart';
import 'about.dart';

class MenuLateral extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menú Principal',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          // Noticias
          ListTile(
            leading: Icon(Icons.article),
            title: const Text('Noticias'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NoticiasPage()),
              );
            },
          ),
          // Horarios
          ListTile(
            leading: Icon(Icons.schedule),
            title: const Text('Horarios'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HorariosPage()),
              );
            },
          ),
          // Preselección
          ListTile(
            leading: Icon(Icons.check_circle),
            title: const Text('Preselección'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SeleccionPage()),
              );
            },
          ),
          // Deuda
          ListTile(
            leading: Icon(Icons.attach_money),
            title: const Text('Deuda'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DeudaPage()),
              );
            },
          ),
          // Solicitudes
          ListTile(
            leading: Icon(Icons.request_page),
            title: const Text('Solicitudes'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SolicitudesPage()),
              );
            },
          ),
          // Tareas
          ListTile(
            leading: Icon(Icons.assignment),
            title: const Text('Mis Tareas'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TareasPage()),
              );
            },
          ),
          // Eventos
          ListTile(
            leading: Icon(Icons.event),
            title: const Text('Eventos'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EventosPage()),
              );
            },
          ),
          // Videos
          ListTile(
            leading: Icon(Icons.video_library),
            title: const Text('Videos'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VideosPage()),
              );
            },
          ),
          // Acerca de
          ListTile(
            leading: Icon(Icons.info),
            title: const Text('Acerca de'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutPage()),
              );
            },
          ),
          // Salir
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: const Text('Salir'),
            onTap: () {
              Navigator.pop(context); // Cierra el menú lateral
              Navigator.pop(context); // Regresa al inicio o cierra sesión
            },
          ),
        ],
      ),
    );
  }
}
