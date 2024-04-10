import 'package:flutter/material.dart';

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

List<Invitation> nuevasInvitaciones = [
  Invitation(
    userImage: 'assets/anonymous_user.jpg',
    invitationText: '¡Hola! Te invito a mi juego 1. ¿Quieres participar?',
    nombre: 'Juego 1',
    montoDinero: '200bs',
    tiempoPorTurno: 'No Iniciado',
  ),
  Invitation(
    userImage: 'assets/anonymous_user.jpg',
    invitationText: 'Hola! Te invito a mi juego 2. ¿Quieres participar?',
    nombre: 'Juego 1',
    montoDinero: '300bs',
    tiempoPorTurno: 'No Iniciado',
  ),
];

class Invitaciones extends StatefulWidget {
  const Invitaciones({Key? key}) : super(key: key);

  @override
  _InvitacionesState createState() => _InvitacionesState();
}

class _InvitacionesState extends State<Invitaciones> {
  void _acceptInvitation() {
    setState(() {
      // Actualizar el estado aquí
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Invitaciones"),
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
                          title: const Text('Detalles de la invitación'),
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
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancelar'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                nuevasInvitaciones.removeAt(index);
                                onAccept();
                                Navigator.of(context).pop();
                              },
                              child: const Text('Aceptar'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('Ver', style: TextStyle(color: Colors.black)),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(184, 12, 214, 180),
                    ),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    nuevasInvitaciones.removeAt(index);
                    onAccept();
                  },
                  child: const Text('Rechazar', style: TextStyle(color: Colors.black)),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(184, 214, 12, 12),
                    ),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
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