import 'package:app_movil/paginas/principal.dart';
import 'package:app_movil/paginas/registro.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//------------------------------------------------------------------------------------------------------------
void main() => runApp(MiApp());

//------------------------------------------------------------------------------------------------------------

Future<void> obtener_datos_usuario(String email, String password) async {
  final response = await http.post(Uri.parse('http://146.190.146.167/api/check_user'),
  body: jsonEncode({'email': email, 'password': password}),headers: {'Content-Type': 'application/json'},);
  if (response.statusCode == 200) {
    bandera = true;
    final data = jsonDecode(response.body)['user'];
    id_usuario = data['id'];
    nombre_usuario = data['nombre'];
    email_usuario = data['email'];
  } 
  else {
    bandera = false;
  }
}

Future<void> obtener_juegos_usuario() async {
  final response = await http.get(Uri.parse('http://146.190.146.167/api/obtener_lista_de_juegos/'+id_usuario.toString()));
  if (response.statusCode == 200){
    final data = jsonDecode(response.body)['juegos'];
    lista_juegos_usuario.clear();
    for (var juegoJson in data) {
      lista_juegos_usuario.add(Juego(juegoJson['id'],juegoJson['nombre'],juegoJson['monto_dinero_individual'],juegoJson['estado'],));
    }
  } 
}
    

final TextEditingController email_controller = TextEditingController();
final TextEditingController password_controller = TextEditingController();
int id_usuario = 0;
String nombre_usuario = "";
String email_usuario = "";
bool bandera = false;
//------------------------------------------------------------------------------------------------------------

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
        titulo(),
        SizedBox(height: 110),
        caja_email(),
        SizedBox(height: 12,),
        caja_password(),     
        SizedBox(height: 60,),
        boton_iniciar(context),
        SizedBox(height: 15,),
        boton_registro(context)      
        ],
      )
    ),
  );
}

Widget titulo() {
  return Text(
    "Inicio de Sesion",
    style: TextStyle(
        color: Colors.white, fontSize: 35.0, fontWeight: FontWeight.bold),
  );
}

Widget caja_email() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
    child: TextField(
      controller: email_controller,
      decoration: InputDecoration(
        hintText: "Email",
        fillColor: Colors.white,
        filled: true,
      ),
    ),
  );
}

Widget caja_password() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
    child: TextField(
      controller: password_controller,
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
      if (email_controller.text.contains("@gmail.com") && email_controller.text.length>0 && password_controller.text.length>0) {
        await obtener_datos_usuario(email_controller.text, password_controller.text);
        if (bandera) {
          await obtener_juegos_usuario();
          Navigator.push(context, MaterialPageRoute(builder: (context) => principal()));
        } 
        else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Cuenta no esta registrada!'),
                actions: <Widget>[
                  TextButton(
                    onPressed:(){Navigator.of(context).pop();
                    },
                    child: Text('Cerrar'),
                  ),
                ],
              );
            },
          );
        }
      } 
      else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Datos invalido!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {Navigator.of(context).pop();
                  },
                  child: Text('Cerrar'),
                ),
              ],
            );
          },
        );
      }
    },
    child: Text("Iniciar Sesión",style: TextStyle(color: Colors.black, fontSize: 25.0, fontWeight: FontWeight.bold),
    ),
    style: ButtonStyle(backgroundColor:MaterialStateProperty.all<Color>(Colors.white),padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),),
    ),
  );
}

Widget boton_registro(BuildContext context){
  return TextButton(
    onPressed: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => registro()));
    },
    child: Text("Registrarse",style: TextStyle(fontSize: 19, color: Colors.white),),
    style: ButtonStyle(padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
    ),
  );
}