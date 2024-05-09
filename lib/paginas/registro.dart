import 'package:app_movil/paginas/principal.dart';
import 'package:app_movil/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//------------------------------------------------------------------------------------------------------------

Future<void> set_usuario(String nombre,String fecha_de_nacimiento,String telefono,String ci,String email,String direccion,String password,String rol_app)async{
  final response = await http.post(Uri.parse('http://146.190.146.167/api/users'),
  body: jsonEncode({'nombre': nombre,'fecha_de_nacimiento': fecha_de_nacimiento,'telefono': telefono,'ci': ci,'email': email,
  'direccion': direccion,
  'password': password,
  'rol_app': rol_app}),
  headers: {'Content-Type': 'application/json'},
  );
  if (response.statusCode == 201) {
    final data = jsonDecode(response.body);
    print(data);
    bandera = true;
  } 
  else{
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

List<Juego> lista_juegos_usuario = [];

final TextEditingController nombre_usuario_controller = TextEditingController();
final TextEditingController email_usuario_controller = TextEditingController();
final TextEditingController password_usuario_controller= TextEditingController();
final TextEditingController telefono_usuario_controller = TextEditingController();
final TextEditingController fecha_usuario_controller = TextEditingController();
final TextEditingController ci_usuario_controller = TextEditingController();
final TextEditingController direccion_usuario_controller = TextEditingController();
//------------------------------------------------------------------------------------------------------------

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
            image: AssetImage('assets/fondo_pantalla.jpg'),
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
      controller: nombre_usuario_controller,
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
      controller: email_usuario_controller,
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
      controller: password_usuario_controller,
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
      controller: telefono_usuario_controller,
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
      controller: fecha_usuario_controller,
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
      controller: ci_usuario_controller,
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
      controller: direccion_usuario_controller,
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
      String usuario = nombre_usuario_controller.text;
      String gmail = email_usuario_controller.text;
      String contrasena = password_usuario_controller.text;
      String telefono = telefono_usuario_controller.text;
      String fecha = fecha_usuario_controller.text;
      String ci = ci_usuario_controller.text;
      String direccion = direccion_usuario_controller.text;
      if (usuario.length>0 && gmail.length>10 && gmail.contains("@gmail.com") && contrasena.length>0 && telefono.length == 8 && ci.length==7 && direccion.length>0) {
        await set_usuario(usuario, fecha, telefono, ci, gmail, direccion,contrasena, "Jugador");
        await obtener_datos_usuario(gmail,contrasena);
        await obtener_juegos_usuario();
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