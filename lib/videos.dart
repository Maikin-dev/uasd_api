import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class VideosPage extends StatelessWidget {
  final String apiUrl = "https://uasdapi.ia3x.com/videos";

  Future<List<Map<String, dynamic>>> fetchVideos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('authToken');

    if (authToken == null || authToken.isEmpty) {
      throw Exception('Token de autenticación no encontrado. Por favor, inicia sesión.');
    }

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody is List) {
        return responseBody.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Formato de datos inesperado: ${responseBody.runtimeType}');
      }
    } else {
      throw Exception('Error en la solicitud (HTTP ${response.statusCode}): ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Videos Educativos'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchVideos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            final videos = snapshot.data!;
            if (videos.isEmpty) {
              return const Center(
                child: Text("No se encontraron videos.",
                    style: TextStyle(fontSize: 18, color: Colors.grey)),
              );
            }
            return ListView.builder(
              itemCount: videos.length,
              itemBuilder: (context, index) {
                final video = videos[index];
                final title = video['titulo'] ?? 'Sin título';
                final videoUrl = video['url'] ?? '';
                final fecha = video['fechaPublicacion'] ?? 'Fecha no disponible';

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  child: Column(
                    children: [
                      Container(
                        height: 180,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          image: DecorationImage(
                            image: NetworkImage(
                              video['thumbnail'] ?? 'https://via.placeholder.com/300x180.png?text=Sin+Imagen',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        title: Text(
                          title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        subtitle: Text("Publicado: $fecha"),
                        trailing: IconButton(
                          icon: const Icon(Icons.play_circle_fill, color: Colors.blueAccent, size: 32),
                          onPressed: () {
                            if (videoUrl.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      VideoPlayerPage(videoUrl: videoUrl, title: title),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("No se encontraron videos."));
          }
        },
      ),
    );
  }
}

class VideoPlayerPage extends StatelessWidget {
  final String videoUrl;
  final String title;

  const VideoPlayerPage({required this.videoUrl, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.play_circle_fill, size: 100, color: Colors.blueAccent),
            const SizedBox(height: 20),
            Text(
              'Reproduciendo video:',
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            const SizedBox(height: 10),
            Text(
              videoUrl,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
