import 'package:app_movil/paginas/principal.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

final TextEditingController usuarioController = TextEditingController();
final TextEditingController gmailController = TextEditingController();
final TextEditingController contrasenaController = TextEditingController();
final TextEditingController telefonoController = TextEditingController();
final TextEditingController fechaController = TextEditingController();
final TextEditingController ciController = TextEditingController();
final TextEditingController direccionController = TextEditingController();

bool bandera = false;
Future<void> set_usuario(
    String nombre,
    String fecha_de_nacimiento,
    String telefono,
    String ci,
    String email,
    String direccion,
    String password,
    String rol_app) async {
  final response = await http.post(
    Uri.parse('http://localhost:8000/api/users'),
    body: jsonEncode({
      'nombre': nombre,
      'fecha_de_nacimiento': fecha_de_nacimiento,
      'telefono': telefono,
      'ci': ci,
      'email': email,
      'direccion': direccion,
      'password': password,
      'rol_app': rol_app
    }),
    headers: {'Content-Type': 'application/json'},
  );
  if (response.statusCode == 201) {
    final data = jsonDecode(response.body);
    print(data);
    bandera = true;
  } else {
    print('Failed to post data: ${response.statusCode}');
    bandera = false;
  }
}

class registro extends StatefulWidget {
  @override
  State<registro> createState() => _registroState();
}

class _registroState extends State<registro> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(1, 68, 134, 1),
      body: cuerpo(context),
    );
  }
}

Widget cuerpo(BuildContext context) {
  return Container(
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          nombre(),
          SizedBox(
            height: 50,
          ),
          usuario(),
          gmail(),
          Contrasea(),
          telefono(),
          fecha(),
          ci(),
          direccion(),
          SizedBox(
            height: 20,
          ),
          registrar(context),
          SizedBox(
            height: 20,
          ),
          cancelar(context),
        ],
      ),
    ),
  );
}

Widget nombre() {
  return Text(
    "Ingrese sus Datos",
    style: TextStyle(
        color: Colors.white, fontSize: 35.0, fontWeight: FontWeight.bold),
  );
}

Widget usuario() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    child: TextField(
      controller: usuarioController,
      decoration: InputDecoration(
        hintText: "Nombre de usuario",
        fillColor: Colors.white,
        filled: true,
      ),
    ),
  );
}

Widget gmail() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    child: TextField(
      controller: gmailController,
      decoration: InputDecoration(
        hintText: "gmail",
        fillColor: Colors.white,
        filled: true,
      ),
    ),
  );
}

Widget Contrasea() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    child: TextField(
      controller: contrasenaController,
      decoration: InputDecoration(
        hintText: "Contraseña",
        fillColor: Colors.white,
        filled: true,
      ),
    ),
  );
}

Widget telefono() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    child: TextField(
      controller: telefonoController,
      decoration: InputDecoration(
        hintText: "telefono",
        fillColor: Colors.white,
        filled: true,
      ),
    ),
  );
}

Widget fecha() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    child: TextField(
      controller: fechaController,
      decoration: InputDecoration(
        hintText: "fecha de nacimiento",
        fillColor: Colors.white,
        filled: true,
      ),
    ),
  );
}

Widget ci() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    child: TextField(
      controller: ciController,
      decoration: InputDecoration(
        hintText: "ci",
        fillColor: Colors.white,
        filled: true,
      ),
    ),
  );
}

Widget direccion() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    child: TextField(
      controller: direccionController,
      decoration: InputDecoration(
        hintText: "direccion",
        fillColor: Colors.white,
        filled: true,
      ),
    ),
  );
}

Widget registrar(BuildContext context) {
  return TextButton(
    onPressed: () async {
      String usuario = usuarioController.text;
      String gmail = gmailController.text;
      String contrasena = contrasenaController.text;
      String telefono = telefonoController.text;
      String fecha = fechaController.text;
      String ci = ciController.text;
      String direccion = direccionController.text;

      if (gmail.contains("@gmail.com") && telefono.length == 8) {
        await set_usuario(usuario, fecha, telefono, ci, gmail, direccion,
            contrasena, "Jugador");
        print(bandera.toString() +
            "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
        if (bandera == true) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Usuario Registrado!!'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => principal()));
                    },
                    child: Text('Cerrar'),
                  ),
                ],
              );
            },
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Email o telefono ya estan registrado!'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cerrar'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error de sintaxis en el email o telefono'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => principal()));
                  },
                  child: Text('Cerrar'),
                ),
              ],
            );
          },
        );
      }
    },
    child: Text(
      "Registrarse",
      style: TextStyle(fontSize: 25, color: Colors.black),
    ),
    style: ButtonStyle(
      backgroundColor:
          MaterialStateProperty.all<Color>(Color.fromARGB(184, 12, 214, 180)),
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
        EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      ),
    ),
  );
}

Widget cancelar(BuildContext context) {
  return TextButton(
    onPressed: () {
      Navigator.pop(context);
    },
    child: Text(
      "Cancelar",
      style: TextStyle(fontSize: 25, color: Colors.black),
    ),
    style: ButtonStyle(
      backgroundColor:
          MaterialStateProperty.all<Color>(Color.fromARGB(184, 12, 214, 180)),
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
        EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      ),
    ),
  );
}
