import 'package:tarea3/Rutas/constantes.dart';
import 'package:tarea3/pantallas/inicio.dart';
import 'package:tarea3/pantallas/login.dart';
import 'package:tarea3/pantallas/pelicula.dart';

final rutas = {
  Constantes.login.name: (context) => Login(),
  Constantes.inicio.name: (context) => const Inicio(),
  Constantes.pelicula.name: (context) => const Pelicula(),
};
