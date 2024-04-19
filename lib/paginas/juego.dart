import 'package:app_movil/paginas/principal.dart';
import 'package:flutter/material.dart';
import 'package:app_movil/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


Future<void> dar_ofertar(String dinero) async {
  final response = await http.post(
    Uri.parse('http://localhost:8000/api/ofertas'),
    body: jsonEncode({
      'monto_dinero': dinero,
      'fecha': "2024-04-18",
      'tipo': "oferta",
      'user_id': usuarioActual.id.toString(),
      'turno_id': id_turno,
    }),
    headers: {'Content-Type': 'application/json'},
  );
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print(data);
  } else {
    print('Failed to post data: ${response.statusCode}');
  }
}

int id_turno = 0;

class Oferta {
  final String monto;

  Oferta(this.monto);
}

final List<Oferta> ofertas = [];

String nombre_juego = "";

class VerJuego extends StatefulWidget {
  const VerJuego({super.key});

  @override
  State<VerJuego> createState() => _VerJuegoState();
}

class _VerJuegoState extends State<VerJuego> {
  Future<void> get_juego() async {
    final response = await http.get(Uri.parse(
        'http://localhost:8000/api/obtener_lista_de_juegos/' +
            usuarioActual.id.toString()));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      for (var juegoJson in data['juegos']) {
        if (juegoJson['id'] == id_juego) {
          nombre_juego = juegoJson['nombre'];
        }
      }
      setState(() {});
    } else {
      print('Failed to get data: ${response.statusCode}');
    }
  }

  Future<void> get_ofertas() async {
    final response = await http.get(Uri.parse(
        'http://localhost:8000/api/obtener_listado_de_ofertas/' +
            id_turno.toString()));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      ofertas.clear(); // Limpiar la lista antes de agregar los nuevos juegos
      for (var juegoJson in data['ofertas']) {
        ofertas.add(Oferta("Ofertaron " + juegoJson['monto_dinero'] + "bs"));
      }
      setState(() {});
    } else {
      print('Failed to get data: ${response.statusCode}');
    }
  }

  Future<void> get_turno() async {
    final response = await http.get(Uri.parse(
        'http://localhost:8000/api/obtener_listado_de_turnos/' +
            id_juego.toString()));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      ofertas.clear(); // Limpiar la lista antes de agregar los nuevos juegos
      for (var juegoJson in data['turnos']) {
        id_turno = juegoJson['id'];
      }
    } else {
      print('Failed to get data: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_juego();
    //get_ofertas();
    get_turno();
    get_ofertas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(1, 68, 134, 1),
      appBar: AppBar(
        title: Text("Juego, " + nombre_juego,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        backgroundColor: Color.fromARGB(184, 12, 214, 180),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 60, vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 5),
                Text("El Turno 1 disponible",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 40),
                Text("Jugadores que mas ofertaron",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 2),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ListView.builder(
                      itemCount: ofertas.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.all(20),
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(184, 12, 214, 180),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(ofertas[index].monto,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 40),
                ingresar_ofertar(),
                SizedBox(height: 20),
                boton_ofertar(context),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final TextEditingController ofertaController = TextEditingController();
//String password = passwordController.text;

Widget ingresar_ofertar() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 120, vertical: 4),
    child: TextField(
      controller: ofertaController,
      decoration: InputDecoration(
        hintText: "participa (bs.)",
        fillColor: Colors.white,
        filled: true,
      ),
    ),
  );
}

Widget boton_ofertar(BuildContext context) {
  return TextButton(
    onPressed: () async {
      String s = ofertaController.text;
      await dar_ofertar(s);
    },
    child: Text(
      "Ofertar",
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
