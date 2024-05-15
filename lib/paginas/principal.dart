import 'package:app_movil/paginas/cobrar.dart';
import 'package:app_movil/paginas/notificaciones.dart';
import 'package:app_movil/paginas/juego.dart';
import 'package:app_movil/paginas/registro.dart';
import 'package:flutter/material.dart';
import 'package:app_movil/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
//------------------------------------------------------------------------------------------------------------
String sumarFechaYDuracion(String fecha, String duracion) {
  // Parsear la fecha en formato "yyyy-MM-dd HH:mm:ss"
  DateTime fechaInicial = DateTime.parse(fecha);
  
  // Parsear la duración en formato "HH:mm:ss"
  List<String> duracionParts = duracion.split(':');
  Duration duracionSumar = Duration(
    hours: int.parse(duracionParts[0]),
    minutes: int.parse(duracionParts[1]),
    seconds: int.parse(duracionParts[2]),
  );
  
  // Sumar la fecha inicial y la duración
  DateTime fechaFinal = fechaInicial.add(duracionSumar);
  
  // Formatear la fecha final como cadena en formato "yyyy-MM-dd HH:mm:ss"
  DateFormat formato = DateFormat("yyyy-MM-dd HH:mm:ss");
  String fechaFinalFormateada = formato.format(fechaFinal);
  
  return fechaFinalFormateada;
}




Future<bool> usuario_fue_eliminado(String id_juego_parametro) async {
    final response = await http.get(Uri.parse('http://146.190.146.167/api/obtener_listado_de_jugadores/' +id_juego_parametro));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['jugadores'];
      for (var juegoJson in data) {
        if(juegoJson['user_id']==id_usuario){
            if(juegoJson['estado']=="Retirado"){
              return true;
            }
        }
      }
      
    }
    return false;
  }





   Future<void> get_notificaciones_juegos_finalizado() async {
    final response = await http.get(Uri.parse(
        'http://146.190.146.167/api/obtener_lista_de_juegos/' + id_usuario.toString()));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      lista_notificacion_finalizacion_juego.clear();
      for (var juegoJson in data['juegos']) {
        if(juegoJson['estado']=="Finalizado"){
          lista_notificacion_finalizacion_juego.add("El juego "+juegoJson['nombre']+" ha finalizado!");
        }
      }
      
    }
  }



  Future<void> get_notificaciones_participantes_eliminados() async {
    final response = await http.get(Uri.parse(
        'http://146.190.146.167/api/obtener_lista_de_juegos/' + id_usuario.toString()));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      lista_notificacion_jugadores_eliminados.clear();
      for (var juegoJson in data['juegos']) {
        await get_notificaciones_participantes_eliminados2(juegoJson['id'].toString());
      }
      
    }
  }

  Future<void> get_notificaciones_participantes_eliminados2(String id_juego_parametro) async {
    final response = await http.get(Uri.parse(
        'http://146.190.146.167/api/obtener_listado_de_jugadores/' + id_juego_parametro));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final data2 = jsonDecode(response.body)['juego'];
      String nombre_juego = data2['nombre'];
      for (var juegoJson in data['jugadores']) {
        if (juegoJson['estado'] == "Retirado") {
           String nombre = await obtener_nombre_participante(juegoJson['user_id'].toString());
           lista_notificacion_jugadores_eliminados.add("El jugador "+nombre+" ha sido eliminado del juego "+nombre_juego);
        }
      }
      
    }
  }


  Future<void> obtener_participantes_juego(String id_juego_parametro) async {
    final response = await http.get(Uri.parse(
        'http://146.190.146.167/api/obtener_listado_de_jugadores/' + id_juego_parametro));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      participantes.clear();
      for (var juegoJson in data['jugadores']) {
        if (juegoJson['estado'] == "Aceptado") {
           participantes.add(await obtener_nombre_participante(juegoJson['user_id'].toString()));
        }
      }
      
    }
  }


  Future<String> obtener_nombre_participante(String id_user_parametro) async {
    final response = await http.get(Uri.parse(
        'http://146.190.146.167/api/users/' + id_user_parametro));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['user'];
      return data['nombre']; 
    }
    else{
      return "default"; 
    }
  }




  Future<void> get_notificaciones_invitaciones_juegos() async {
    final response = await http.get(Uri.parse(
        'http://146.190.146.167/api/obtener_lista_de_invitaciones/' +
            id_usuario.toString()));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      nuevasInvitaciones.clear();
      for (var juegoJson in data['invitaciones']) {
        if (juegoJson['estado'] == "En espera") {
          nuevasInvitaciones.add(Invitation(id_invitacion: juegoJson['id'],invitationText: "Te han enviado una invitación para un juego. ¿Quieres participar?", 
          nombre: juegoJson['juego']['nombre'], montoDinero: juegoJson['juego']['monto_dinero_individual']+" bs.", 
          tiempoPorTurno: "hrs.",
          tiempoParaOfertar: juegoJson['juego']['tiempo_para_ofertar']+" hrs.",
          fecha_inicio: juegoJson['juego']['fecha_de_inicio'],
          oferta_minimo: juegoJson['juego']['monto_minimo_para_ofertar']+" bs.",
          id_juego: juegoJson['juego']['id']));
        }
      }
      
    }
  }

Future<void> obtener_nombre_juego() async {
  final response = await http.get(Uri.parse('http://146.190.146.167/api/obtener_lista_de_juegos/' +id_usuario.toString()));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    for (var juegoJson in data['juegos']) {
      if (juegoJson['id'] == id_juego) {
        nombre_juego = juegoJson['nombre'];
        monto_minimo_ofertar = int.parse(juegoJson['monto_minimo_para_ofertar']);
        monto_maximo_ofertar = int.parse(juegoJson['monto_maximo_para_ofertar']);
        fecha_finalizacion_oferta = juegoJson['tiempo_para_ofertar'];
      } 
    }
  } 
}

Future<void> get_notificaciones_inicio_juegos() async {
  final response = await http.get(Uri.parse('http://146.190.146.167/api/obtener_lista_de_juegos/'+id_usuario.toString()));
  if (response.statusCode == 200){
      final data = jsonDecode(response.body);
      lista_notificacion_inicio_juego.clear();
      lista_notificacion_finalizacion_juego.clear();
      for (var juegoJson in data['juegos']) {
        if (juegoJson['estado'] != "No Iniciado") {
          lista_notificacion_inicio_juego.add(NotificacionInicioJuego(nombre_juego: "El juego " + juegoJson['nombre'] + " ha comenzado!" 
          + " fecha de inicio "+ juegoJson['fecha_de_inicio']));
        }    
        if (juegoJson['estado'] == "Finalizado") {
          lista_notificacion_finalizacion_juego.add("El juego "+juegoJson['nombre']+" ha finalizado!");
        } 
      }

    }
  }

Future<void> get_turnos(String id_juego_parametro, String nombre_juego_parametro, int numero_turno) async {
    final response = await http.get(Uri.parse('http://146.190.146.167/api/obtener_listado_de_turnos/' +id_juego_parametro));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      for (var juegoJson in data['turnos']) {
        lista_notificacion_inicio_turnos.add("El turno "+numero_turno.toString()+" del juego "+nombre_juego_parametro+" ha comenzado, "+"termina "
        +juegoJson['fecha_final']);
        numero_turno = numero_turno + 1;
      }
      
    }
  }

  Future<void> get_notificaciones_inicio_turnos() async {
    final response = await http.get(Uri.parse('http://146.190.146.167/api/obtener_lista_de_juegos/' +id_usuario.toString()));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['juegos'];
      lista_notificacion_inicio_turnos.clear();
      for (var juegoJson in data) {
        if (juegoJson['estado'] != "No Iniciado") {
          await get_turnos(juegoJson['id'].toString(), juegoJson['nombre'], 1);    
        }
      }
      
    }
  }




Future<int> obtener_mayor_oferta_turno(String id_turno_parametro, int oferta_parametro) async {
  final response = await http.get(Uri.parse('http://146.190.146.167/api/obtener_listado_de_ofertas/'+id_turno_parametro));
  if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['ofertas'];
      for (var juegoJson in data) {
        if(oferta_parametro<int.parse(juegoJson['monto_dinero'])){
          oferta_parametro = int.parse(juegoJson['monto_dinero']);
        }
      }     
    }
  return oferta_parametro;
}

Future<String> obtener_nombre_ganador_turno(String id_turno_parametro) async {
  final response = await http.get(Uri.parse('http://146.190.146.167/api/obtener_ganador/'+id_turno_parametro));
  if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['ganador']['user'];
      return  data['nombre']; 
    }
  return "";
}

bool la_fecha_ya_paso(String fecha_hora) {
  DateTime targetDateTime = DateTime.parse(fecha_hora);
  DateTime currentDateTime = DateTime.now();
  return currentDateTime.isAfter(targetDateTime);
}


Future<bool> alguien_gano_este_turno(String id_turno_parametro) async {
  final response = await http.get(Uri.parse('http://146.190.146.167/api/ganadorturnos/'+id_turno_parametro));
  if (response.statusCode == 200) {
      return true; 
    }
  return false;
}


Future<void> get_turnos_gngt(String id_juego_parametro, String nombre_juego_parametro, int numero_turno) async {
    final response = await http.get(Uri.parse('http://146.190.146.167/api/obtener_listado_de_turnos/' +id_juego_parametro));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      for (var juegoJson in data['turnos']) {       
        if(await alguien_gano_este_turno(juegoJson['id'].toString())){
          int monto_dinero_ofertado = await obtener_mayor_oferta_turno(juegoJson['id'].toString(), 0);
          String nombre_ganador_turno = await obtener_nombre_ganador_turno(juegoJson['id'].toString());
          lista_notificacion_ganador_turno.add("El ganador del turno "+numero_turno.toString()+" del juego "+nombre_juego_parametro +" es "
          +nombre_ganador_turno+" con una oferta de "+monto_dinero_ofertado.toString()+" bs.");
        }
        numero_turno = numero_turno + 1;
      }
      
    }
  }

  Future<void> get_notificaciones_ganador_turno() async {
    final response = await http.get(Uri.parse('http://146.190.146.167/api/obtener_lista_de_juegos/' +id_usuario.toString()));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      lista_notificacion_ganador_turno.clear();
      for (var juegoJson in data['juegos']) {
        if (juegoJson['estado'] != "No Iniciado") {
          await get_turnos_gngt(juegoJson['id'].toString(), juegoJson['nombre'], 1);
        }
      }
    }
  }





Future<bool> get_usuario_gano_turno(String id_juego_parametro) async {
    final response = await http.get(Uri.parse('http://146.190.146.167/api/obtener_listado_de_turnos/' +id_juego_parametro));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      for (var juegoJson in data['turnos']) {       
        if(nombre_usuario==await obtener_nombre_ganador_turno(juegoJson['id'].toString())){
          turno_id_cobrar = juegoJson['id'].toString();
          return true;
        }
      }    
    }
    turno_id_cobrar = "";
    return false;
  }

bool bandera_usuario_gano_turno = false;



Future<bool> hay_turno_disponible(String id_juego_parametro, int numero_turno) async {
    final response = await http.get(Uri.parse('http://146.190.146.167/api/obtener_listado_de_turnos/' +id_juego_parametro));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      for (var juegoJson in data['turnos']) {       
        if(la_fecha_ya_paso(sumarFechaYDuracion(juegoJson['fecha_inicio'], fecha_finalizacion_oferta))==false){
          nombre_turno = "Turno "+numero_turno.toString();
          fecha_inicio_siguiente_turno = juegoJson['fecha_final'];           
          fecha_inicio_oferta = juegoJson['fecha_inicio'];
          fecha_finalizacion_oferta = sumarFechaYDuracion(fecha_inicio_oferta, fecha_finalizacion_oferta);
          id_turno = juegoJson['id'].toString();
          return true;
        }
        else{
          fecha_inicio_siguiente_turno = juegoJson['fecha_final']; 
        }
        numero_turno = numero_turno + 1;
      }    
    }
    return false;
  }



bool bandera_hay_turno_disponible = false;






class IdTurno {
  final String id;
  IdTurno({
    required this.id,
  });
}
final List<IdTurno> id_turnos = [
    
];
int id_juego = 0;

//------------------------------------------------------------------------------------------------------------
class principal extends StatefulWidget {
  @override
  State<principal> createState() => _principalState();
}

class _principalState extends State<principal> {
@override
  void initState() {
    // TODO: implement initState
    super.initState() ;
    setState(() {
      
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hola, " + nombre_usuario,
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
                color: Color.fromARGB(184, 12, 214, 180),
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
                      nombre_usuario,
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
              onTap: () async{
                await get_notificaciones_invitaciones_juegos();
                await get_notificaciones_inicio_juegos();
                await get_notificaciones_inicio_turnos();
                await get_notificaciones_ganador_turno();
                await obtener_notificacion_pagos2();
                await obtener_notificacion_ganador();
                await get_notificaciones_participantes_eliminados();
                await get_notificaciones_ganador_turno();

 

Navigator.push(context, MaterialPageRoute(builder: (context) => Invitaciones())).then((value) {
  // Este código se ejecutará cuando regreses a la página actual
  setState(() {
    // Actualiza la página aquí
  });
});

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
      color: Colors.white,
    ),
    Positioned.fill(
      top: 20,
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(left: 20, top: 1, right: 20, bottom: 25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: ListView.builder(
          itemCount: (lista_juegos_usuario.length / 2).ceil(),
          itemBuilder: (context, index) {
            return Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.only(left: 5,top: 5,right: 5,bottom: 5),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(184, 12, 214, 180),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          lista_juegos_usuario[index * 2].nombre,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          lista_juegos_usuario[index * 2].monto,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          lista_juegos_usuario[index * 2].estado,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: ()async {
                          if(lista_juegos_usuario[index * 2].estado == "Iniciado"){
                              id_juego = lista_juegos_usuario[index * 2].id;
                              if(await usuario_fue_eliminado(id_juego.toString())==false){
                                  await obtener_nombre_juego();
                              bandera_usuario_gano_turno = await get_usuario_gano_turno(id_juego.toString());
                              bandera_hay_turno_disponible = await hay_turno_disponible(id_juego.toString(), 1);
                              await obtener_participantes_juego(id_juego.toString());
                              Navigator.push(context, MaterialPageRoute(builder: (context) => VerJuego()));
                              }
                              else{
                                showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Fuiste eliminado de este juego!'),
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
                            }
                          },
                          child: Text(
                            'Ver',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.white,
                            ),
                            foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: (index * 2 + 1 < lista_juegos_usuario.length)
                      ? Container(
                          padding: EdgeInsets.all(20),
                          margin: EdgeInsets.only(left: 5),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(184, 12, 214, 180),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                lista_juegos_usuario[index * 2 + 1].nombre,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                lista_juegos_usuario[index * 2 + 1].monto,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                lista_juegos_usuario[index * 2 + 1].estado,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () async{
                              if(lista_juegos_usuario[index * 2 + 1].estado == "Iniciado"){
                              id_juego = lista_juegos_usuario[index * 2 + 1].id;
                              if(await usuario_fue_eliminado(id_juego.toString())==false){
                                  await obtener_nombre_juego();
                              bandera_usuario_gano_turno = await get_usuario_gano_turno(id_juego.toString());
                              bandera_hay_turno_disponible = await hay_turno_disponible(id_juego.toString(), 1);
                              await obtener_participantes_juego(id_juego.toString());
                              Navigator.push(context, MaterialPageRoute(builder: (context) => VerJuego()));
                              }
                               else{
                                showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Fuiste eliminado de este juego!'),
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
                              }






                                },
                                child: Text(
                                  'Ver',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(
                                    Colors.white,
                                  ),
                                  foregroundColor: MaterialStateProperty.all<Color>(
                                    Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                ),
              ],
            );
          },
        ),
      ),
    ),
  ],
),
    );
  }
}