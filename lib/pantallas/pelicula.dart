import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:tarea3/modelos/actoresmodel.dart';
import 'dart:convert';
import 'dart:ui';

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
        backgroundColor: const Color.fromARGB(255, 181, 151, 232),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
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
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ),
                ),
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
              ],
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
                  Row(
                    children: [
                      const Text(
                        "Fecha de Lanzamiento: ",
                        style: TextStyle(
                            color: Colors.black, fontStyle: FontStyle.normal),
                      ),
                      Row(
                        children: [
                          Text(
                            pelicula.releaseDate,
                            style: const TextStyle(
                                color: Colors.grey,
                                fontStyle: FontStyle.italic),
                          ),
                          const Icon(Icons.date_range, color: Colors.grey)
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Text(
                        "Rating: ${pelicula.voteAverage} ",
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Row(
                    children: [
                      Text(
                        "Titulo Original:  ",
                      ),
                      Icon(Icons.movie_creation_outlined)
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Text(
                        "Lenguaje Original: ${pelicula.originalLanguage}",
                      ),
                      const Icon(Icons.language)
                    ],
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
                          backgroundColor: Colors.deepPurple,
                          backgroundImage: NetworkImage(
                            "https://image.tmdb.org/t/p/w500${index.profilePath}",
                          ),
                        )
                      : const CircleAvatar(
                          radius: 70,
                          backgroundColor: Colors.deepPurple,
                          child: Icon(
                            Icons.person,
                            size: 120,
                            color: Colors.white,
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
