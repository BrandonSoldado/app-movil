import 'package:app_movil/paginas/principal.dart';
import 'package:flutter/material.dart';
import 'package:app_movil/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';


String obtenerFechaHoraActual() {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
  return formattedDate;
}


String estado_oferta_enviada= "";

int id_turno = 0;


String nombre_juego = "";


class Turno {
  final String nombre_turno;
  final String fecha_finalizacion_turno;
  final String fecha_inicio_turno;

 
  Turno({
    required this.nombre_turno,
    required this.fecha_finalizacion_turno,
    required this.fecha_inicio_turno,
  });
}
final List<Turno> turnos = [
];


  Future<void> get_turno2() async {
    final response = await http.get(Uri.parse(
        'http://localhost:8000/api/obtener_listado_de_turnos/' +
            id_juego.toString()));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      for (var juegoJson in data['turnos']) {
        id_turno = juegoJson['id'];
      }
    } else {
      print('Failed to get data: ${response.statusCode}');
    }
  }
Future<void> dar_ofertar(String dinero) async {
  final response = await http.post(
    Uri.parse('http://localhost:8000/api/ofertas'),
    body: jsonEncode({
      'monto_dinero': dinero,
      'fecha': obtenerFechaHoraActual(),
      'tipo': "oferta",
      'user_id': usuarioActual.id.toString(),
      'turno_id': id_turno,
    }),
    headers: {'Content-Type': 'application/json'},
  );
  if (response.statusCode == 201) {
    final data = jsonDecode(response.body);
    print(data);
    estado_oferta_enviada = "Oferta enviada con exito!";
  } else {
    print('Failed to post data: ${response.statusCode}');
    estado_oferta_enviada = "Error! oferta enviada fuera de tiempo!";
  }
}




class VerJuego extends StatefulWidget {
  const VerJuego({super.key});

  @override
  State<VerJuego> createState() => _VerJuegoState();
}

class _VerJuegoState extends State<VerJuego> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Juego: " + nombre_juego,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: Color.fromARGB(184, 12, 214, 180),
      ),
      body: Container(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                buildTurnoInfo(turnos),
                SizedBox(height: 100),
           
                ingresar_ofertar(),
                SizedBox(height: 14),
                boton_ofertar(context),
              ],
            ),
          ),
    );
  }
}

final TextEditingController ofertaController = TextEditingController();
//String password = passwordController.text;

Widget ingresar_ofertar() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 100, vertical: 0),
    child: TextField(
      controller: ofertaController,
      decoration: InputDecoration(
        hintText: "ofertar(bs)",
        fillColor: Color.fromARGB(184, 12, 214, 180),
        filled: true,
      ),
      style: TextStyle(fontWeight: FontWeight.bold), // Aplica negrita al texto ingresado
    ),
  );
}

Widget boton_ofertar(BuildContext context) {
  return TextButton(
    onPressed: () async {
      String s = ofertaController.text;
      await dar_ofertar(s);


      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(estado_oferta_enviada),
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


    },
    child: Text(
      "Enviar",
      style: TextStyle(fontSize: 25, color: Colors.black),
    ),
    style: ButtonStyle(
      backgroundColor:
          MaterialStateProperty.all<Color>(Color.fromARGB(184, 12, 214, 180)),
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      ),
    ),
  );
}


Widget buildTurnoInfo(List<Turno> turnos) {
  if(turnos.length>0){
      return Column(
    
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        turnos[0].nombre_turno + " esta disponible",
        style: TextStyle(
          color: Colors.black,
          fontSize: 35.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 3),
      Text(
        "Fecha inicio: " + turnos[0].fecha_inicio_turno,
        style: TextStyle(
          color: Colors.black,
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        "Fecha finalización: " + turnos[0].fecha_finalizacion_turno,
        style: TextStyle(
          color: Colors.black,
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
  }
  else{
  return Text("No hay turnos disponibles");}
  
}