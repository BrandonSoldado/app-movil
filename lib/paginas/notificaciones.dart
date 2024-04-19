import 'package:flutter/material.dart';
import 'package:app_movil/main.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Invitation {
  final String userImage;
  final String invitationText;
  final String nombre;
  final String montoDinero;
  final String tiempoPorTurno;

  Invitation({
    required this.userImage,
    required this.invitationText,
    required this.nombre,
    required this.montoDinero,
    required this.tiempoPorTurno,
  });
}

List<Invitation> nuevasInvitaciones = [];

class Elemento {
  final String nombre;

  Elemento({required this.nombre});
}

List<Elemento> listaElementos = [];

class Invitaciones extends StatefulWidget {
  const Invitaciones({Key? key}) : super(key: key);

  @override
  _InvitacionesState createState() => _InvitacionesState();
}

class _InvitacionesState extends State<Invitaciones> {
  Future<void> get_notificaciones() async {
    final response = await http.get(Uri.parse(
        'http://localhost:8000/api/obtener_lista_de_juegos/' +
            usuarioActual.id.toString()));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      listaElementos.clear();
      //listaElementos.add(Elemento(nombre: "El ganador del turno 1 del juego ROBLOX es GAMER3214"));
      for (var juegoJson in data['juegos']) {
        if (juegoJson['estado'] != "No Iniciado") {
          listaElementos.add(Elemento(
              nombre: "El juego " + juegoJson['nombre'] + " ha comenzado!"));
          listaElementos.add(Elemento(
              nombre: "El turno 1 del juego " +
                  juegoJson['nombre'] +
                  " ha comenzado!"));
        }
      }
      nuevasInvitaciones.add(
        Invitation(
          userImage: 'assets/anonymous_user.jpg',
          invitationText: '¡Hola! Te invito a mi juego 1. ¿Quieres participar?',
          nombre: 'Juego 1',
          montoDinero: '200bs',
          tiempoPorTurno: 'No Iniciado',
        ),
      );
      setState(() {});
    } else {
      print('Failed to get data: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {});
    get_notificaciones();
  }

  void _acceptInvitation() {
    setState(() {
      // Actualizar el estado aquí
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notificaciones"),
        backgroundColor: const Color.fromARGB(184, 12, 214, 180),
      ),
      backgroundColor: const Color.fromRGBO(1, 68, 134, 1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListView.builder(
              shrinkWrap: true,
              itemCount: nuevasInvitaciones.length,
              itemBuilder: (context, index) {
                return InvitationCard(
                  index: index,
                  userImage: nuevasInvitaciones[index].userImage,
                  invitationText: nuevasInvitaciones[index].invitationText,
                  nombre: nuevasInvitaciones[index].nombre,
                  montoDinero: nuevasInvitaciones[index].montoDinero,
                  tiempoPorTurno: nuevasInvitaciones[index].tiempoPorTurno,
                  onAccept: _acceptInvitation,
                );
              },
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: listaElementos.length,
              itemBuilder: (context, index) {
                return InvitationCard2(
                  index: index,
                  contenido: listaElementos[index].nombre,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class InvitationCard extends StatelessWidget {
  final int index;
  final String userImage;
  final String invitationText;
  final String nombre;
  final String montoDinero;
  final String tiempoPorTurno;
  final Function onAccept;

  const InvitationCard({
    required this.index,
    required this.userImage,
    required this.invitationText,
    required this.nombre,
    required this.montoDinero,
    required this.tiempoPorTurno,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              backgroundImage: AssetImage(userImage),
              radius: 40,
            ),
            const SizedBox(height: 16),
            Text(
              invitationText,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text(
                            'Detalles de la invitación',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Nombre: $nombre'),
                              Text('Monto dinero: $montoDinero'),
                              Text('Tiempo por turno: $tiempoPorTurno'),
                            ],
                          ),
                          actions: <Widget>[
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  const Color.fromARGB(184, 12, 214, 180),
                                ),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.black),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Cancelar',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  const Color.fromARGB(184, 12, 214, 180),
                                ),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.black),
                              ),
                              onPressed: () {
                                nuevasInvitaciones.removeAt(index);
                                onAccept();
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Aceptar',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text(
                    'Ver',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(184, 12, 214, 180),
                    ),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    nuevasInvitaciones.removeAt(index);
                    onAccept();
                  },
                  child: const Text(
                    'Rechazar',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(184, 12, 214, 180),
                    ),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class InvitationCard2 extends StatelessWidget {
  final int index;
  final String contenido;

  const InvitationCard2({
    required this.index,
    required this.contenido,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 16),
            Text(
              contenido,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    //nuevasInvitaciones.removeAt(index);
                  },
                  child: const Text('Eliminar',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(184, 12, 214, 180),
                    ),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
