import 'package:app_movil/paginas/principal.dart';
import 'package:flutter/material.dart';
import 'package:app_movil/main.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Invitation {
  final String invitationText;
  final String nombre;
  final String montoDinero;
  final String tiempoPorTurno;
  final String tiempoParaOfertar;
  final int id_juego;
  final int id_invitacion;

  Invitation({
    required this.invitationText,
    required this.nombre,
    required this.montoDinero,
    required this.tiempoPorTurno,
    required this.tiempoParaOfertar,
    required this.id_juego,
    required this.id_invitacion
  });
}

List<Invitation> nuevasInvitaciones = [
];


  //Elemento(nombre: "El juego 1 Comenzo!"),
 //   Elemento(nombre: "El turno 1 del juego 1 comenzo!, termina a las 2024-04-18 a las 17:60:12"),
      //Elemento(nombre: "El ganador del turno 1 del juego 1 es Gamer1231"),


class NotificacionInicioJuego {
  final String nombre_juego;
  NotificacionInicioJuego({required this.nombre_juego});
}
List<NotificacionInicioJuego> lista_notificacion_inicio_juego = [
];


class NotificacionInicioTurno {
  final String nombre_turno;
  NotificacionInicioTurno({required this.nombre_turno});
}
List<NotificacionInicioTurno> lista_notificacion_inicio_turno = [
];


class NotificacionGandorTurno {
  final String nombre_ganador;
  NotificacionGandorTurno({required this.nombre_ganador});
}
List<NotificacionGandorTurno> lista_notificacion_ganador_turno = [
];



Future<void> aceptar_rechazar_invitacion(String id_invitacion, String userId, String juegoId, String rolJuego, String identificadorInvitaciones, String estado) async {
  final url = Uri.parse('http://localhost:8000/api/juegousers/'+id_invitacion);
  
  final response = await http.put(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'user_id': userId,
      'juego_id': juegoId,
      'rol_juego': rolJuego,
      'identificador_invitacion': identificadorInvitaciones,
      'estado': estado,
    }),
  );
  
  if (response.statusCode == 200) {
    print('Datos actualizados correctamente');
  } else {
    print('Error al actualizar los datos. Código de estado: ${response.statusCode}');
  }
}


class Invitaciones extends StatefulWidget {
  const Invitaciones({Key? key}) : super(key: key);

  @override
  _InvitacionesState createState() => _InvitacionesState();
}

class _InvitacionesState extends State<Invitaciones> {
  
void actualizarInvitaciones() {
  setState(() {
    // Actualiza el estado de nuevasInvitaciones
  });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notificaciones",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(184, 12, 214, 180),
      ),
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
                  invitationText: nuevasInvitaciones[index].invitationText,
                  nombre: nuevasInvitaciones[index].nombre,
                  montoDinero: nuevasInvitaciones[index].montoDinero,
                  tiempoPorTurno: nuevasInvitaciones[index].tiempoPorTurno,
                  tiempoParaOfertar: nuevasInvitaciones[index].tiempoParaOfertar,
                   actualizarInvitaciones: actualizarInvitaciones,
                );
              },
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: lista_notificacion_inicio_juego.length,
              itemBuilder: (context, index) {
                return InvitationCard2(
                  index: index,
                  contenido: lista_notificacion_inicio_juego[index].nombre_juego,
                );
              },
            ),

             ListView.builder(
              shrinkWrap: true,
              itemCount: lista_notificacion_inicio_turno.length,
              itemBuilder: (context, index) {
                return InvitationCard2(
                  index: index,
                  contenido: lista_notificacion_inicio_turno[index].nombre_turno,
                );
              },
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: lista_notificacion_ganador_turno.length,
              itemBuilder: (context, index) {
                return InvitationCard2(
                  index: index,
                  contenido: lista_notificacion_ganador_turno[index].nombre_ganador,
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
  final String invitationText;
  final String nombre;
  final String montoDinero;
  final String tiempoPorTurno;
  final String tiempoParaOfertar;
   final VoidCallback actualizarInvitaciones; 

  const InvitationCard({
    required this.index,
    required this.invitationText,
    required this.nombre,
    required this.montoDinero,
    required this.tiempoPorTurno,
    required this.tiempoParaOfertar,
    required this.actualizarInvitaciones,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromARGB(184, 54, 236, 206),
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
  backgroundColor: Colors.white,
  child: Icon(
    Icons.person,
    color: Colors.grey,
  ),
),
            Text(
              invitationText,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 2),
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
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Nombre: $nombre'),
                              Text('Monto dinero: $montoDinero'),
                              Text('Tiempo por turno: $tiempoPorTurno'),
                              Text('Tiempo para ofertar: $tiempoParaOfertar'),
                            ],
                          ),
                          actions: <Widget>[
                            ElevatedButton(
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.all<double>(0),
                                backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.transparent,
                                ),
                                foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Cancelar',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.all<double>(0),
                                backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.transparent,
                                ),
                                foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black,
                                ),
                              ),
                              onPressed: () async{
                                await aceptar_rechazar_invitacion(nuevasInvitaciones[index].id_invitacion.toString() ,usuarioActual.id.toString(), nuevasInvitaciones[index].id_juego.toString(), "Jugador", usuarioActual.email, "Aceptado");
                                
                                await get_notificaciones_invitaciones_juegos();
                                await get_juegos();
                                actualizarInvitaciones();
                                Navigator.of(context).pop();

                              },
                              child: const Text(
                                'Aceptar',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
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
                    elevation: MaterialStateProperty.all<double>(0),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.transparent,
                    ),
                    foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: ()async {
                    await aceptar_rechazar_invitacion(nuevasInvitaciones[index].id_invitacion.toString() ,usuarioActual.id.toString(), nuevasInvitaciones[index].id_juego.toString(), "Jugador", usuarioActual.email, "Rechazado");
                    await get_notificaciones_invitaciones_juegos();
                    await get_juegos();
                    actualizarInvitaciones();                 
                  },
                  child: const Text(
                    'Rechazar',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all<double>(0),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.transparent,
                    ),
                    foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.black,
                    ),
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
      color: Color.fromARGB(184, 54, 236, 206),
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              contenido,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.end, // Alinea el botón a la derecha
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    //nuevasInvitaciones.removeAt(index);
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: const Text(
                      'Eliminar',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                    elevation: MaterialStateProperty.all<double>(0),
                    shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}