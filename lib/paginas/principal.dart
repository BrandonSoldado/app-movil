import 'package:app_movil/paginas/notificaciones.dart';
import 'package:app_movil/paginas/juego.dart';
import 'package:app_movil/paginas/registro.dart';
import 'package:flutter/material.dart';
import 'package:app_movil/main.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

int id_juego = 0;

  Future<void> get_nombre_juego() async {
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
    } else {
      print('Failed to get data: ${response.statusCode}');
    }
  }



  Future<void> get_notificaciones_inicio_juegos() async {
    final response = await http.get(Uri.parse(
        'http://localhost:8000/api/obtener_lista_de_juegos/' +
            usuarioActual.id.toString()));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      lista_notificacion_inicio_juego.clear();
      lista_notificacion_inicio_turno.clear();
      //listaElementos.add(Elemento(nombre: "El ganador del turno 1 del juego ROBLOX es GAMER3214"));
      for (var juegoJson in data['juegos']) {
        if (juegoJson['estado'] != "No Iniciado") {
          lista_notificacion_inicio_juego.add(NotificacionInicioJuego(nombre_juego: "El juego " + juegoJson['nombre'] + " ha comenzado!"));
          await get_turno(juegoJson['id'].toString());
          lista_notificacion_inicio_turno.add(NotificacionInicioTurno(nombre_turno: "El turno 1 del juego " +juegoJson['nombre'] +" ha comenzado! Termina a las "+
          turnos[0].fecha_finalizacion_turno));
        }
      }
    } else {
      print('Failed to get data: ${response.statusCode}');
    }
  }

class IdTurno {
  final String id;
  IdTurno({
    required this.id,
  });
}
final List<IdTurno> id_turnos = [
    
];


  Future<void> get_notificaciones_ganador_turno() async {
    final response = await http.get(Uri.parse('http://localhost:8000/api/obtener_lista_de_juegos/' +usuarioActual.id.toString()));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      lista_notificacion_ganador_turno.clear();
      for (var juegoJson in data['juegos']) {
        if (juegoJson['estado'] != "No Iniciado") {
          await get_id_turno(juegoJson['id'].toString());
          await get_notificaciones_ganador_turno2(id_turnos[0].id, juegoJson['nombre']);
        }
      }
    } else {
      print('Failed to get data: ${response.statusCode}');
    }
  }

  Future<void> get_id_turno(String id_juego22) async {
    final response = await http.get(Uri.parse('http://localhost:8000/api/obtener_listado_de_turnos/' +id_juego22));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      id_turnos.clear();
      for (var juegoJson in data['turnos']) {
        id_turnos.add(IdTurno(id: juegoJson['id'].toString()));
      }    
    } else {
      print('Failed to get data: ${response.statusCode}');
    }
  }


Future<void> get_notificaciones_ganador_turno2(String id_turno_actual22, String nombre_juego) async {
  final response = await http.get(Uri.parse('http://localhost:8000/api/obtener_ganador/' +id_turno_actual22));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    var ganador = data['ganador'];
    lista_notificacion_ganador_turno.add(NotificacionGandorTurno(nombre_ganador: "El ganador del turno 1 en el juego $nombre_juego es ${ganador['user']['nombre']}"));
  } else {
    print('Failed to get data: ${response.statusCode}');
  }
}


  Future<void> get_notificaciones_invitaciones_juegos() async {
    final response = await http.get(Uri.parse(
        'http://localhost:8000/api/obtener_lista_de_invitaciones/' +
            usuarioActual.id.toString()));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      nuevasInvitaciones.clear();
      for (var juegoJson in data['invitaciones']) {
        if (juegoJson['estado'] == "En espera") {
          nuevasInvitaciones.add(Invitation(id_invitacion: juegoJson['id'],invitationText: "Te han enviado una invitación para un juego. ¿Quieres participar?", 
          nombre: juegoJson['juego']['nombre'], montoDinero: juegoJson['juego']['monto_dinero_individual']+" bs", 
          tiempoPorTurno: juegoJson['juego']['tiempo_por_turno']+" hrs.",
          tiempoParaOfertar: juegoJson['juego']['tiempo_para_ofertar']+" hrs.",
          id_juego: juegoJson['juego']['id']));
        }
      }
      
    } else {
      print('Failed to get data: ${response.statusCode}');
    }
  }


Future<void> get_turno(String id_juego) async {
    final response = await http.get(Uri.parse('http://localhost:8000/api/obtener_listado_de_turnos/' +id_juego));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      turnos.clear();
      for (var juegoJson in data['turnos']) {
        turnos.add(Turno(nombre_turno: "Turno 1", fecha_finalizacion_turno: juegoJson['fecha_final'], fecha_inicio_turno: juegoJson['fecha_inicio']));
      }
      
    } else {
      print('Failed to get data: ${response.statusCode}');
    }
  }




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
              onTap: () async{
                await get_notificaciones_invitaciones_juegos();
                await get_notificaciones_inicio_juegos();
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
          itemCount: (juegos.length / 2).ceil(),
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
                          juegos[index * 2].nombre,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          juegos[index * 2].monto,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          juegos[index * 2].estado,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: ()async {
                          if(juegos[index * 2].estado != "No Iniciado"){
                            id_juego = juegos[index * 2].id;
                          await get_turno2();
                          await get_nombre_juego();
                          await get_turno(id_juego.toString());
                                Navigator.push(
          context, MaterialPageRoute(builder: (context) => VerJuego()));
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
                  child: (index * 2 + 1 < juegos.length)
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
                                juegos[index * 2 + 1].nombre,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                juegos[index * 2 + 1].monto,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                juegos[index * 2 + 1].estado,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () async{
                              if(juegos[index * 2 + 1].estado != "No Iniciado"){
                            id_juego = juegos[index * 2 + 1].id;
                         await get_turno2();
                            await get_nombre_juego();
                          await get_turno(id_juego.toString());
                                Navigator.push(
          context, MaterialPageRoute(builder: (context) => VerJuego()));
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