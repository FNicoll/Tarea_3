import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tarea3/Rutas/constantes.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tarea3/modelos/peliculamodel.dart';

class Inicio extends StatelessWidget {
  Inicio({super.key});

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Películas Populares'),
        backgroundColor: const Color.fromARGB(255, 181, 151, 232),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.close_outlined),
              title: const Text('Salir'),
              onTap: () {
                SystemNavigator.pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout_outlined),
              title: const Text('Cerrar Sesión'),
              onTap: () {
                Navigator.pop(context);
                cerrarSesion(context);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: FutureBuilder(
          future: obtenerPeliculas(),
          builder: (BuildContext context,
              AsyncSnapshot<List<PeliculaModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.none) {
              return const Center(child: Text('No hay conexion'));
            }
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cloud_off, size: 100),
                    Text(
                      '${snapshot.error}',
                      style: const TextStyle(fontSize: 30),
                    ),
                  ],
                ),
              );
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.data!.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.cloud_off, size: 100),
                    Text(
                      'No hay datos',
                      style: TextStyle(fontSize: 30),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, Constantes.pelicula.name,
                        arguments: snapshot.data![index]);
                  },
                  child: Column(
                    children: [
                      Tarjeta(
                        pelicula: snapshot.data![index],
                      ),
                      const Divider(
                        thickness: 2,
                        height: 3,
                      )
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<List<PeliculaModel>> obtenerPeliculas() async {
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/movie/popular?language=es-ES&page=1&api_key=609321cea0d560839b0baba2f464f9c5'),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((results) => PeliculaModel.fromJson(results)).toList();
    } else {
      return [];
    }
  }

  cerrarSesion(BuildContext context) async {
    final navigator = Navigator.of(context);
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cerrar Sesión'),
          content: const Text('¿Desea cerrar sesión?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                navigator.pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                await box.remove('token');
                navigator.pop();
                navigator.pushNamedAndRemoveUntil(
                    Constantes.login.name, (route) => false);
              },
              child: const Text('Si'),
            ),
          ],
        );
      },
    );
  }
}

class Tarjeta extends StatelessWidget {
  const Tarjeta({
    super.key,
    required this.pelicula,
  });

  final PeliculaModel pelicula;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 248, 159, 226),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            SizedBox(
              width: 100,
              height: 150,
              child: Image.network(
                "https://image.tmdb.org/t/p/w500/${pelicula.posterPath}",
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pelicula.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '${pelicula.overview.length < 100 ? pelicula.overview : pelicula.overview.substring(0, 100)}...',
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
