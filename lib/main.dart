import 'package:app_movil/paginas/principal.dart';
import 'package:app_movil/paginas/registro.dart';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class Usuario {
  int id;
  String nombre;
  String fechaDeNacimiento;
  String telefono;
  String email;
  String ci;
  String direccion;
  String rolApp;

  Usuario({
    required this.id,
    required this.nombre,
    required this.fechaDeNacimiento,
    required this.telefono,
    required this.email,
    required this.ci,
    required this.direccion,
    required this.rolApp,
  });
}

Usuario usuarioActual = Usuario(
    id: 1,
    nombre: "",
    fechaDeNacimiento: "",
    telefono: "",
    email: "",
    ci: "",
    direccion: "",
    rolApp: "");

bool bandera = false;

Future<void> get_usuario(String email, String password) async {
  final response = await http.post(
    Uri.parse('http://172.20.10.4:8000/api/check_user'),
    body: jsonEncode({'email': email, 'password': password}),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    bandera = true;
    final userData = jsonDecode(response.body)['user'];
    usuarioActual = Usuario(
      id: userData['id'],
      nombre: userData['nombre'],
      fechaDeNacimiento: userData['fecha_de_nacimiento'],
      telefono: userData['telefono'],
      email: userData['email'],
      ci: userData['ci'],
      direccion: userData['direccion'],
      rolApp: userData['rol_app'],
    );
  } else {
    bandera = false;
  }
}

final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
void main() => runApp(MiApp());

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Pasanaku",
      home: Inicio(),
    );
  }
}

class Inicio extends StatefulWidget {
  const Inicio({Key? key}) : super(key: key);
  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromRGBO(1, 68, 134, 1),
        child: cuerpo(context),
      ),
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
        inicio_sesion(),
        SizedBox(
          height: 40,
        ),
        pasanaku(),
        image(),
        email(),
        contrasena(),
        SizedBox(
          height: 20,
        ),
        boton_iniciar(context),
        SizedBox(
          height: 20,
        ),
        boton_registro(context),
      ],
    )),
  );
}

Widget pasanaku() {
  return Text(
    "Pasanaku",
    style: TextStyle(
        color: Color.fromARGB(184, 12, 214, 180),
        fontSize: 35.0,
        fontWeight: FontWeight.bold),
  );
}

Widget image() {
  return Container(
    padding: EdgeInsets.only(left: 60, top: 5, right: 60, bottom: 30),
    margin: EdgeInsets.only(left: 80, top: 30, right: 80, bottom: 30),
    child: Image.network(
        "https://media.istockphoto.com/id/1343496367/es/vector/concepto-de-trabajo-en-equipo-conexi%C3%B3n-de-cinco-manos.jpg?s=612x612&w=0&k=20&c=ym1ur5S3mbC-p4b9Yi4q9D1lhTwV6nC9mA11cVGLWCo="),
  );
}

Widget inicio_sesion() {
  return Text(
    "Iniciar Sesion",
    style: TextStyle(
        color: Colors.white, fontSize: 35.0, fontWeight: FontWeight.bold),
  );
}

Widget email() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    child: TextField(
      controller: emailController,
      decoration: InputDecoration(
        hintText: "Email",
        fillColor: Colors.white,
        filled: true,
      ),
    ),
  );
}

Widget contrasena() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    child: TextField(
      controller: passwordController,
      obscureText: true,
      decoration: InputDecoration(
        hintText: "Contraseña",
        fillColor: Colors.white,
        filled: true,
      ),
    ),
  );
}

Widget boton_iniciar(BuildContext context) {
  return TextButton(
    onPressed: () async {
      String email = emailController.text;
      String password = passwordController.text;
      if (email.contains("@gmail.com")) {
        await get_usuario(email, password);
        if (bandera) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => principal()));
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Usuario no existe!'),
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
              title: Text('Error de sintaxis en el email! '),
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
    },
    child: Text(
      "Iniciar Sesion",
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

Widget boton_registro(BuildContext context) {
  return TextButton(
    onPressed: () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => registro()));
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
