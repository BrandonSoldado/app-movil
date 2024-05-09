import 'package:app_movil/paginas/cobrar.dart';
import 'package:app_movil/paginas/notificaciones.dart';
import 'package:app_movil/paginas/juego.dart';
import 'package:app_movil/paginas/registro.dart';
import 'package:flutter/material.dart';
import 'package:app_movil/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//------------------------------------------------------------------------------------------------------------
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
          tiempoPorTurno: juegoJson['juego']['tiempo_por_turno']+" hrs.",
          tiempoParaOfertar: juegoJson['juego']['tiempo_para_ofertar']+" hrs.",
          fecha_inicio: juegoJson['juego']['fecha_de_inicio'],
          oferta_minimo: "200"+" bs.",
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
      } 
    }
  } 
}

Future<void> get_notificaciones_inicio_juegos() async {
  final response = await http.get(Uri.parse('http://146.190.146.167/api/obtener_lista_de_juegos/'+id_usuario.toString()));
  if (response.statusCode == 200){
      final data = jsonDecode(response.body);
      lista_notificacion_inicio_juego.clear();
      for (var juegoJson in data['juegos']) {
        if (juegoJson['estado'] != "No Iniciado") {
          lista_notificacion_inicio_juego.add(NotificacionInicioJuego(nombre_juego: "El juego " + juegoJson['nombre'] + " ha comenzado!" 
          + " fecha de inicio "+ juegoJson['fecha_de_inicio']));
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

Future<void> get_turnos_gngt(String id_juego_parametro, String nombre_juego_parametro, int numero_turno) async {
    final response = await http.get(Uri.parse('http://146.190.146.167/api/obtener_listado_de_turnos/' +id_juego_parametro));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      for (var juegoJson in data['turnos']) {       
        if(la_fecha_ya_paso(juegoJson['fecha_final'])){
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
        if(la_fecha_ya_paso(juegoJson['fecha_final'])==false){
          nombre_turno = "Turno "+numero_turno.toString();
          fecha_finalizacion_turno = juegoJson['fecha_final']; 
          fecha_inicio_turno = juegoJson['fecha_inicio'];
          id_turno = juegoJson['id'].toString();
          return true;
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
                //await obtener_notificacion_pagos2();
                await obtener_notificacion_ganador();
                
                //await get_notificaciones_ganador_turno();



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
                          if(lista_juegos_usuario[index * 2].estado != "No Iniciado"){
                              id_juego = lista_juegos_usuario[index * 2].id;
                              bandera_usuario_gano_turno = await get_usuario_gano_turno(id_juego.toString());
                              bandera_hay_turno_disponible = await hay_turno_disponible(id_juego.toString(), 1);
                              await obtener_nombre_juego();
                              Navigator.push(context, MaterialPageRoute(builder: (context) => VerJuego()));
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
                              if(lista_juegos_usuario[index * 2 + 1].estado != "No Iniciado"){
                              id_juego = lista_juegos_usuario[index * 2 + 1].id;
                              bandera_usuario_gano_turno = await get_usuario_gano_turno(id_juego.toString());
                              bandera_hay_turno_disponible = await hay_turno_disponible(id_juego.toString(), 1);
                              await obtener_nombre_juego();
                              Navigator.push(context, MaterialPageRoute(builder: (context) => VerJuego()));
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