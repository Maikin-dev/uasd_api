import 'package:flutter/material.dart';
import 'login_page.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Image.asset('assets/logo-uasd.jpg', height: 120),
            const SizedBox(height: 20),
            Text(
              'Universidad Autónoma de Santo Domingo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Divider(thickness: 1.0),
            const SizedBox(height: 20),
            // Misión
            Text(
              'Misión',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Su Misión es formar críticamente profesionales, investigadores y técnicos en las ciencias, las humanidades y las artes necesarias y eficientes para coadyuvar a las transformaciones que demanda el desarrollo nacional sostenible, así como difundir los ideales de la cultura de paz, progreso, justicia social, equidad de género y respeto a los derechos humanos, a fin de contribuir a la formación de una conciencia colectiva basada en valores.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 30),
            // Visión
            Text(
              'Visión',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'La Universidad tiene como Visión ser una institución de excelencia y liderazgo académico, gestionada con eficiencia y acreditada nacional e internacionalmente; con un personal docente, investigador, extensionistas y egresados de alta calificación; creadora de conocimientos científicos y nuevas tecnologías, y reconocida por su contribución al desarrollo humano con equidad y hacia una sociedad democrática y solidaria.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 30),
            // Valores
            Text(
              'Valores',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'La Universidad está orientada hacia el respeto y la defensa de la dignidad humana y se sustenta en los siguientes valores:',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 10),
            Text(
              'a) Solidaridad\nb) Transparencia\nc) Verdad\nd) Igualdad\ne) Libertad\nf) Equidad',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: const Text('Acceder'),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
