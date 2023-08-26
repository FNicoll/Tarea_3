import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tarea3/Rutas/constantes.dart';
import 'package:tarea3/Rutas/rutas.dart';

void main() async {
  await GetStorage.init();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      initialRoute:
          (logueado() ? Constantes.inicio.name : Constantes.login.name),
      routes: rutas,
    );
  }

  bool logueado() {
    final token = box.read('token');
    return token != null && token.isNotEmpty;
  }
}
