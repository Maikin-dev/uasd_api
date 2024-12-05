import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acerca de los Desarrolladores'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DeveloperCard(
              name: "Javier García Martínez",
              matricula: "2023-0671",
              image: "assets/javier.jpg", // Asegúrate de agregar esta imagen a tu carpeta assets.
              quote: "«El que pasa el tiempo arrepintiéndose del pasado, pierde el presente y arriesga el futuro» —Francisco de Quevedo",
            ),
            const SizedBox(height: 16),
            DeveloperCard(
              name: "Maikin Custodio García",
              matricula: "2023-0297",
              image: "assets/maikin.jpg", // Asegúrate de agregar esta imagen a tu carpeta assets.
              quote: "«La mala noticia es que el tiempo vuela. La buena noticia es que tú eres el piloto» —Michael Altshuler",
            ),
          ],
        ),
      ),
    );
  }
}

class DeveloperCard extends StatelessWidget {
  final String name;
  final String matricula;
  final String image;
  final String quote;

  const DeveloperCard({
    required this.name,
    required this.matricula,
    required this.image,
    required this.quote,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(image),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Matrícula: $matricula",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    quote,
                    style: const TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
