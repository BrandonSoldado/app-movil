import 'package:app_movil/paginas/principal.dart';
import 'package:flutter/material.dart';
import 'package:app_movil/main.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;

class Invitation {
  final String invitationText;
  final String nombre;
  final String montoDinero;
  final String tiempoPorTurno;
  final String tiempoParaOfertar;
  final String fecha_inicio;
  final String oferta_minimo;
  final int id_juego;
  final int id_invitacion;

  Invitation({
    required this.invitationText,
    required this.nombre,
    required this.montoDinero,
    required this.tiempoPorTurno,
    required this.tiempoParaOfertar,
    required this.fecha_inicio,
    required this.oferta_minimo,
    required this.id_juego,
    required this.id_invitacion
  });
}

List<Invitation> nuevasInvitaciones = [
];



class NotificacionInicioJuego {
  final String nombre_juego;
  NotificacionInicioJuego({required this.nombre_juego});
}
List<NotificacionInicioJuego> lista_notificacion_inicio_juego = [
];

List<String> lista_notificacion_inicio_turnos = [];





List<String> lista_notificacion_ganador_turno = [
];


class NotificacionPagoCuota{
  final String texto_notificacion;
  final String montoDinero;
    final String tiempoParaPagar;
      final String tipoPago;
      final String base64;
  NotificacionPagoCuota({
    required this.texto_notificacion,
    required this.montoDinero,
    required this.tiempoParaPagar,
    required this.tipoPago,
    required this.base64
    });
}
List<NotificacionPagoCuota> lista_notificacion_pago_cuota = [
 //NotificacionPagoCuota(texto_notificacion: "Pago Cuota del turno 1, del juego ROBLOX", montoDinero: "200 bs", tiempoParaPagar: "2024-04-29 15:00:20", tipoPago: "Cuota"),
  //NotificacionPagoCuota(texto_notificacion: "Pago Penalizacion del turno 1, del juego ROBLOX", montoDinero: "100 bs", tiempoParaPagar: "2024-04-29 16:00:20", tipoPago: "Penalizacion")
];


List<String> lista_notificacion_ganador_turno222 = [
];



Future<void> aceptar_rechazar_invitacion(String id_invitacion, String userId, String juegoId, String rolJuego, String identificadorInvitaciones, String estado) async {
  final url = Uri.parse('http://146.190.146.167/api/juegousers/'+id_invitacion);
  
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




Future<bool> verificar_ganador(String id_turno_parametro) async {
  final response = await http.get(Uri.parse('http://146.190.146.167/api/ganadorturnos/' + id_turno_parametro));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body)['ganadorturno'];
    
    if (data['user_id'] == id_usuario) {
      return true;
    }
  }
  return false;
}

Future<int> obtener_monto_qr_ganador(String id_turno_parametro) async {
    final response = await http.get(Uri.parse('http://146.190.146.167/api/obtener_pagos/' +id_usuario.toString()));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      for (var juegoJson in data['pagos']) {
        if(id_turno_parametro==juegoJson['turno_id']){
          return juegoJson['monto_dinero'];
        }
      }
      
    }
    return -1;
  }





Future<void> get_turnos_ganador(String id_juego_parametro, String monto_individual_parametro,String nombre_juego_parametro, int numero_turno) async {
    final response = await http.get(Uri.parse('http://146.190.146.167/api/obtener_listado_de_turnos/' +id_juego_parametro));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['turnos'];
      
      for (var juegoJson in data) {
        if(await verificar_ganador(juegoJson['id'].toString())){
           int vv = await obtener_monto_qr_ganador(juegoJson['id'].toString());
           if(vv!= -1){
            lista_notificacion_ganador_turno222.add("Ganaste el Turno "+numero_turno.toString()+" del juego "+nombre_juego_parametro+", debes subir a la plataforma un QR de cobra con un monto de "+
            vv.toString()+" bs, para que los demas puedan pagarte.");
           }
           else{
            lista_notificacion_ganador_turno222.add("Ganaste el Turno "+numero_turno.toString()+" del juego "+nombre_juego_parametro+", debes subir a la plataforma un QR de cobra con un monto de "+
            monto_individual_parametro+" bs, para que los demas puedan pagarte.");
           }
        }
        numero_turno = numero_turno + 1;
      }
      
    }
  }



Future<void> obtener_notificacion_ganador() async {
  final response = await http.get(Uri.parse('http://146.190.146.167/api/obtener_lista_de_juegos/' +id_usuario.toString()));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body)['juegos'];
    lista_notificacion_ganador_turno222.clear();
    for (var juegoJson in data) {
      await get_turnos_ganador(juegoJson['id'].toString(),juegoJson['monto_dinero_individual'],juegoJson['nombre'],1);
    }
  } 
}








Future<bool> verificar_si_subio_qr(String id_turno_parametro) async {
    final response = await http.get(Uri.parse('http://146.190.146.167/api/ganadorturnos/' +id_turno_parametro));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['ganadorturno'];      
       if(data['estado'] != null && data['estado'] != "No se puede pagar") {
  return true;
}  
    }
    return false;
}



  







Future<void> get_turnos_pagos2(String id_juego_parametro,String nombre_juego_parametro, int numero_turno) async {
    final response = await http.get(Uri.parse('http://146.190.146.167/api/obtener_listado_de_turnos/' +id_juego_parametro));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['turnos'];      
      for (var juegoJson in data) {
        if(await verificar_si_subio_qr(juegoJson['id'].toString())){
          lista_notificacion_pago_cuota.add(NotificacionPagoCuota(texto_notificacion: "Pago de un QR, debes escanear el siguiente QR de cobra para poder pagar ",
          montoDinero: juegoJson['monto_dinero'], tiempoParaPagar: juegoJson['fecha_limite'], tipoPago: juegoJson['tipo'], base64: ""));
        }
        numero_turno = numero_turno + 1;
      }
      
    }
  }

Future<void> obtener_notificacion_pagos2() async {
  final response = await http.get(Uri.parse('http://146.190.146.167/api/obtener_lista_de_juegos/' +id_usuario.toString()));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body)['juegos'];
    lista_notificacion_pago_cuota.clear();
    for (var juegoJson in data) {
      await get_turnos_pagos2(juegoJson['id'].toString(),juegoJson['nombre'],1);
    }
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
                  fecha_inicio: nuevasInvitaciones[index].fecha_inicio,
                  oferta_minimo: nuevasInvitaciones[index].oferta_minimo,
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
              itemCount: lista_notificacion_inicio_turnos.length,
              itemBuilder: (context, index) {
                return InvitationCard2(
                  index: index,
                  contenido: lista_notificacion_inicio_turnos[index],
                );
              },
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: lista_notificacion_ganador_turno.length,
              itemBuilder: (context, index) {
                return InvitationCard2(
                  index: index,
                  contenido: lista_notificacion_ganador_turno[index],
                );
              },
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: lista_notificacion_ganador_turno222.length,
              itemBuilder: (context, index) {
                return InvitationCard2(
                  index: index,
                  contenido: lista_notificacion_ganador_turno222[index],
                );
              },
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: lista_notificacion_pago_cuota.length,
              itemBuilder: (context, index) {
                return InvitationCard2(
                  index: index,
                  contenido: lista_notificacion_pago_cuota[index].texto_notificacion,
                );
              },
            ),
            
            
          ],
        ),
      ),
    );
  }
}



class InvitationCard3 extends StatelessWidget {
  final int index;
  final String invitationText;
  final String montoDinero;
  final String tiempoPagar;
  final String tipoPago;
   final VoidCallback actualizarInvitaciones; 

  const InvitationCard3({
    required this.index,
    required this.invitationText,
    required this.montoDinero,
    required this.tiempoPagar,
    required this.tipoPago,
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
            Text(
              invitationText,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Center(
                            child: const Text(
                            'Detalles del pago',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text('Monto dinero: $montoDinero',style: TextStyle(fontSize: 15),),
                              
                              Text('Tipo pago: $tipoPago',style: TextStyle(fontSize: 15),),
                              Text('Tiempo pora pagar: $tiempoPagar',style: TextStyle(fontSize: 11.5),),
                              Container(
        child: FutureBuilder<Uint8List>(
          future: _generateQrImageData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Image.memory(snapshot.data!);
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
                              
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
                                Navigator.of(context).pop();

                              },
                              child: const Text(
                                'Guardar',
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
                
                SizedBox(width: 33,)
              ],
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
  final String fecha_inicio;
  final String oferta_minimo;
   final VoidCallback actualizarInvitaciones; 

  const InvitationCard({
    required this.index,
    required this.invitationText,
    required this.nombre,
    required this.montoDinero,
    required this.tiempoPorTurno,
    required this.tiempoParaOfertar,
    required this.fecha_inicio,
    required this.oferta_minimo,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
      
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
                              Text('Fecha inicio: $fecha_inicio'),
                              Text('Oferta minima: $oferta_minimo'),
                              SizedBox(height: 10,),                  
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(width: 12,),
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
                            SizedBox(width: 20,),
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
                                await aceptar_rechazar_invitacion(nuevasInvitaciones[index].id_invitacion.toString() ,id_usuario.toString(), nuevasInvitaciones[index].id_juego.toString(), "Jugador", email_usuario, "Aceptado");
                                
                                await get_notificaciones_invitaciones_juegos();
                                await obtener_juegos_usuario();
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
                            ),
                            ],
                          ),
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
                ElevatedButton(
                  onPressed: ()async {
                    await aceptar_rechazar_invitacion(nuevasInvitaciones[index].id_invitacion.toString() ,id_usuario.toString(), nuevasInvitaciones[index].id_juego.toString(), "Jugador", email_usuario, "Rechazado");
                    await get_notificaciones_invitaciones_juegos();
                    await obtener_juegos_usuario();
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
                SizedBox(width: 33,)
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
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.end, // Alinea el botón a la derecha
              children: <Widget>[
              ],
            ),
          ],
        ),
      ),
    );
  }
}


Future<Uint8List> _generateQrImageData() async {
    final qrPainter = QrPainter(
      data: 'Datos del código QR',
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.L,
    );
    final ui.Image qrImage = await qrPainter.toImage(200);
    ByteData? byteData = await qrImage.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }