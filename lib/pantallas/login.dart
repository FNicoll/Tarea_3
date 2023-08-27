import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tarea3/Rutas/constantes.dart';
import 'package:tarea3/textfield.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final userName = TextEditingController();
  final password = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "LOGIN",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25.0),
                  child: CachedNetworkImage(
                      placeholder: (context, url) {
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorWidget: (context, url, error) {
                        return const Icon(
                          Icons.no_photography,
                          color: Colors.black,
                          size: 100,
                        );
                      },
                      width: 120,
                      imageUrl:
                          "https://cdn-icons-png.flaticon.com/512/295/295128.png"),
                ),
                Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      children: [
                        Textfield(
                          controller: userName,
                          icon: Icons.mail,
                          label: "Ingrese su usuario",
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Ingrese un correo valido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Textfield(
                          controller: password,
                          icon: Icons.password,
                          label: "Ingrese su contraseña",
                          passwordText: true,
                          viewButton: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Contraseña invalida';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    login(context);
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(200, 50)),
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> obtenerToken(String userName, String password) async {
    String? token;

    final response = await http.post(
      Uri.parse('https://fakestoreapi.com/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'username': userName,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      token = responseData['token'];
      return token;
    } else {
      return null;
    }
  }

  login(BuildContext context) async {
    final mensaje = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final String? token = await obtenerToken(userName.text, password.text);

    if (formKey.currentState!.validate() && token != null) {
      await box.write('token', token);
      navigator.pushNamed(Constantes.inicio.name);
      return;
    }
    mensaje.showSnackBar(
      const SnackBar(
        content: Text("Credenciales no válidas"),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
