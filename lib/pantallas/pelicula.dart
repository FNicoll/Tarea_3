import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:tarea3/modelos/actoresmodel.dart';
import 'dart:convert';

import 'package:tarea3/modelos/peliculamodel.dart';

//ignore: must_be_immutable
class PeliculaDetalle extends StatelessWidget {
  PeliculaDetalle({super.key});

  List<Actores> credits = [];

  @override
  Widget build(BuildContext context) {
    final pelicula =
        ModalRoute.of(context)!.settings.arguments as PeliculaModel;
    return Scaffold(
      appBar: AppBar(
        title: Text(pelicula.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 350,
              child: CachedNetworkImage(
                placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(strokeWidth: 4)),
                errorWidget: (context, url, error) => const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.cloud_off),
                    Text("Sin conexión"),
                  ],
                ),
                imageUrl:
                    "https://image.tmdb.org/t/p/w500${pelicula.posterPath}",
                width: 200,
                height: 300,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20, horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Descripción",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(pelicula.overview),
                  const SizedBox(
                    height: 8,
                  ),
                  Text("Fecha de Lanzamiento: ${pelicula.releaseDate}"),
                  const SizedBox(
                    height: 8,
                  ),
                  Text("Rating: ${pelicula.voteAverage}"),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Titulo Original: ${pelicula.originalTitle}",
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Lenguaje Original: ${pelicula.originalLanguage}",
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                    "Actores",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  FutureBuilder(
                      future: obtenerActores(pelicula),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: ActorItem(credits: credits),
                          );
                        } else if (snapshot.hasError) {
                          return const Text('Error al obtener los créditos.');
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> obtenerActores(PeliculaModel pelicula) async {
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/movie/${pelicula.id}/credits?language=es-ES&api_key=609321cea0d560839b0baba2f464f9c5'),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['cast'];
      credits = results.map((results) => Actores.fromJson(results)).toList();
    } else {
      throw Exception('Error no se resolvio la petición');
    }
  }
}

class ActorItem extends StatelessWidget {
  const ActorItem({
    super.key,
    required this.credits,
  });

  final List<Actores> credits;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        children: credits.map((index) {
          return Row(
            children: [
              Column(
                children: [
                  (index.profilePath != null)
                      ? CircleAvatar(
                          radius: 70,
                          backgroundImage: NetworkImage(
                            "https://image.tmdb.org/t/p/w500${index.profilePath}",
                          ),
                        )
                      : const CircleAvatar(
                          radius: 70,
                          child: Icon(
                            Icons.person,
                            size: 120,
                          ),
                        ),
                  Text(index.name),
                  Text(index.character)
                ],
              ),
              const SizedBox(
                width: 15,
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
