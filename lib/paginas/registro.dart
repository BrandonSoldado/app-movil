import 'package:app_movil/paginas/principal.dart';
import 'package:app_movil/main.dart';
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



class Juego {
  final int id;
  final String nombre;
  final String monto;
  final String estado;

  Juego(this.id, this.nombre, this.monto, this.estado);
}

List<Juego> juegos = [
];

  Future<void> get_juegos() async {
    final response = await http.get(Uri.parse(
        'http://localhost:8000/api/obtener_lista_de_juegos/' +
            usuarioActual.id.toString()));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      juegos.clear();
      for (var juegoJson in data['juegos']) {
        juegos.add(Juego(
          juegoJson['id'],
          juegoJson['nombre'],
          juegoJson['monto_dinero_individual'],
          juegoJson['estado'],
        ));
      }
      print(juegos);
    } else {
      print('Failed to get data: ${response.statusCode}');
    }
  }

class registro extends StatefulWidget {
  @override
  State<registro> createState() => _registroState();
}

class _registroState extends State<registro> {

  @override
  Widget build(BuildContext context) {
 return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://static.vecteezy.com/system/resources/previews/030/464/065/non_2x/futuristic-finance-hand-held-nft-data-on-laptop-showcases-stock-market-for-business-investors-vertical-mobile-wallpaper-ai-generated-free-photo.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.grey.withOpacity(0.3), // Filtro de color gris con opacidad
          ),
          cuerpo(context),
        ],
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
          nombre(),
          SizedBox(
            height: 30,
          ),
          usuario(),
          gmail(),
          contrasena(),
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
    "Unete a Pasanaku",
    style: TextStyle(
        color: Colors.white, fontSize: 33.0, fontWeight: FontWeight.bold),
  );
}

Widget usuario() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
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
    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
    child: TextField(
      controller: gmailController,
      decoration: InputDecoration(
        hintText: "email",
        fillColor: Colors.white,
        filled: true,
      ),
    ),
  );
}

Widget contrasena() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
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
    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
    child: TextField(
      controller: telefonoController,
      decoration: InputDecoration(
        hintText: "telefono (#8)",
        fillColor: Colors.white,
        filled: true,
      ),
    ),
  );
}

Widget fecha() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
    child: TextField(
      controller: fechaController,
      decoration: InputDecoration(
        hintText: "fecha nacimiento (año-mes-dia)",
        fillColor: Colors.white,
        filled: true,
      ),
    ),
  );
}

Widget ci() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
    child: TextField(
      controller: ciController,
      decoration: InputDecoration(
        hintText: "ci (#7)",
        fillColor: Colors.white,
        filled: true,
      ),
    ),
  );
}

Widget direccion() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
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

      if (usuario.length>0 && gmail.length>10 && gmail.contains("@gmail.com") && contrasena.length>0 && telefono.length == 8 && ci.length==7 && direccion.length>0) {
        await set_usuario(usuario, fecha, telefono, ci, gmail, direccion,
            contrasena, "Jugador");
        await get_usuario(gmail,contrasena);
        await get_juegos();
        if (bandera == true) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Usuario Registrado!!'),
                actions: <Widget>[
                  TextButton(
                    onPressed: (){
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
              title: Text('Datos invalidos!'),
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
      "Crear Cuenta",
      style: TextStyle(fontSize: 25, color: Colors.black),
    ),
    style: ButtonStyle(
      backgroundColor:
          MaterialStateProperty.all<Color>(Colors.white),
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
      style: TextStyle(fontSize: 19, color: Colors.white),
    ),
    style: ButtonStyle(
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
        EdgeInsets.zero, // Elimina el padding
      ),
      backgroundColor: MaterialStateProperty.all<Color>(
        Colors.transparent, // Hace transparente el fondo
      ),
    ),
  );
}