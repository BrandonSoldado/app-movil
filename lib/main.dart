import 'package:app_movil/paginas/principal.dart';
import 'package:app_movil/paginas/registro.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Usuario{
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
    required this.rolApp,});}

Future<void> get_usuario(String email, String password) async {
  final response = await http.post(
    Uri.parse('http://localhost:8000/api/check_user'),
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
    bandera = false;}}

Usuario usuarioActual = Usuario(id: 0000,nombre: "",fechaDeNacimiento: "",telefono: "",email: "",ci: "",direccion: "",rolApp: "");
bool bandera = false;
final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();



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
    )),
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
      controller: emailController,
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
      if (email.contains("@gmail.com") && email.length>0 && password.length>0) {
        await get_usuario(email, password);
        if (bandera) {
          await get_juegos();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => principal()));
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Cuenta no esta registrada!'),
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
              title: Text('Datos invalido! '),
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
      "Iniciar Sesión",
      style: TextStyle(
        color: Colors.black, fontSize: 25.0, fontWeight: FontWeight.bold),
    ),
    style: ButtonStyle(
      backgroundColor:
          MaterialStateProperty.all<Color>(Colors.white),
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
        EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
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