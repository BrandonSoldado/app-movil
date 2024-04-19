import 'package:app_movil/paginas/notificaciones.dart';
import 'package:app_movil/paginas/juego.dart';
import 'package:flutter/material.dart';
import 'package:app_movil/main.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

int id_juego = 0;

class Juego {
  final int id;
  final String nombre;
  final String monto;
  final String iniciado;

  Juego(this.id, this.nombre, this.monto, this.iniciado);
}

final List<Juego> juegos = [];

String s = usuarioActual.email;

class principal extends StatefulWidget {
  @override
  State<principal> createState() => _principalState();
}

class _principalState extends State<principal> {
  Future<void> get_juegos() async {
    final response = await http.get(Uri.parse(
        'http://localhost:8000/api/obtener_lista_de_juegos/' +
            usuarioActual.id.toString()));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      juegos.clear(); // Limpiar la lista antes de agregar los nuevos juegos
      for (var juegoJson in data['juegos']) {
        juegos.add(Juego(
          juegoJson['id'],
          juegoJson['nombre'],
          juegoJson['monto_dinero_individual'],
          juegoJson['estado'],
        ));
      }
      setState(() {});
      print(juegos);
    } else {
      print('Failed to get data: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_juegos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hola, " + usuarioActual.nombre,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(184, 12, 214, 180),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/anonymous_user.jpg'),
                      radius: 30,
                    ),
                    SizedBox(height: 8),
                    Text(
                      usuarioActual.nombre,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Notificaciones',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Invitaciones()),
                );
              },
            ),
            ListTile(
              title: Text(
                'Cerrar Sesión',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Inicio()),
                );
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: Color.fromRGBO(1, 68, 134, 1),
          ),
          Align(
            alignment: AlignmentDirectional.topStart,
            child: FractionallySizedBox(
              heightFactor: 0.5,
              child: Container(
                padding: EdgeInsets.all(30),
                margin:
                    EdgeInsets.only(left: 40, top: 30, right: 40, bottom: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ListView.builder(
                  itemCount: juegos.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.only(
                          left: 0, top: 0, right: 0, bottom: 10),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(184, 12, 214, 180),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            juegos[index].nombre,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            juegos[index].monto,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            juegos[index].iniciado,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (juegos[index].iniciado != "No Iniciado") {
                                id_juego = juegos[index].id;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => VerJuego()));
                              }
                            },
                            child: Text('Ver',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
