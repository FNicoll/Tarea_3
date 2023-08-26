import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tarea3/Rutas/constantes.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:tarea3/modelos/peliculamodel.dart';

class Inicio extends StatelessWidget {
  Inicio({super.key});

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Películas Populares'),
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
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.length + 1,
                  itemBuilder: (BuildContext context, index) {
                    if (index < currentPeliculaModels.length) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, Routes.detailsPeliculaModel.name,
                              arguments: currentPeliculaModels[index]);
                        },
                        child: RowPeliculaModel(
                          PeliculaModel: currentPeliculaModels[index],
                        ),
                      );
                    } else {
                      return TextButton(
                        onPressed: () {
                          loadPeliculaModels(context);
                        },
                        child: const Text("Cargar más películas"),
                      );
                    }
                  },
                ),
              ),
            ],
          );
        },
      )),
    );
  }

  Future<List<PeliculaModel>> obtenerPeliculas() async {
    final response = await http.get(
      Uri.parse(
          'https://api.thePeliculaModeldb.org/3/PeliculaModel/popular?language=es-ES&page=1&api_key=f41cf6ed550dbfa29eb141e252443db6'),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((results) => PeliculaModel.fromJson(results)).toList();
    } else {
      throw Exception('Error no se resolvio la petición');
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
