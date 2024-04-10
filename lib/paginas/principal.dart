import 'package:app_movil/paginas/invitaciones.dart';
import 'package:flutter/material.dart';

class Juego {
  final String nombre;
  final String monto;
  final bool iniciado;

  Juego(this.nombre, this.monto, this.iniciado);
}

final List<Juego> juegos = [
  Juego('Juego1', '200bs', false),
    Juego('Juego1', '200bs', false),
    Juego('Juego1', '200bs', false),
    Juego('Juego1', '200bs', false),
    Juego('Juego1', '200bs', false),
  ];

  final List<Juego> j = [
    Juego('Juego1', '200bs', false),
    Juego('Juego1', '200bs', false),
    Juego('Juego1', '200bs', false),
    Juego('Juego1', '200bs', false),
    Juego('Juego1', '200bs', false),

  ];


class principal extends StatefulWidget {
  @override
  State<principal> createState() => _principalState();
}

class _principalState extends State<principal> {
  final String nombre = "Brandon Soldado";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bienvenido, " + nombre),
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
                      nombre,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: Text('Invitaciones'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Invitaciones() ),
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
                margin: EdgeInsets.only(left: 20, top: 30, right: 20, bottom: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ListView.builder(
                  itemCount: juegos.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.only(left: 60, top: 1, right: 60, bottom: 10),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(184, 12, 214, 180),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(juegos[index].nombre),
                          Text(juegos[index].monto),
                          Text(juegos[index].iniciado ? 'Iniciado' : 'No Iniciado'),
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