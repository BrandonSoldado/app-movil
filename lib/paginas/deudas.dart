import 'package:app_movil/paginas/cobrar.dart';
import 'package:app_movil/paginas/pagar.dart';
import 'package:app_movil/paginas/notificaciones.dart';
import 'package:app_movil/paginas/juego.dart';
import 'package:app_movil/paginas/principal.dart';
import 'package:app_movil/paginas/registro.dart';
import 'package:flutter/material.dart';
import 'package:app_movil/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class Deudas {
  final String monto_dinero;
  final String fecha_limite;
  final String tipo;
  final String id_pago;
  final String text_deuda;
  final String turno_id_del_juego;
  Deudas({
    required this.monto_dinero,
    required this.fecha_limite,
    required this.tipo,
    required this.id_pago,
    required this.text_deuda,
    required this.turno_id_del_juego});
}

List<Deudas> lista_notificacion_deudas = [
  //NotificacionDeudas(text_deudas: "Pago Cuota del turno 1, del juego ROBLOX"),
  //NotificacionDeudas(text_deudas: "Pago Penalizacion del turno 1, del juego ROBLOX")
];











Future<void> obtener_pagos_usuario(int id_turno_parametro, String nombre_turno_parametro) async {
    final response = await http.get(Uri.parse('http://146.190.146.167/api/obtener_pagos/' +id_usuario.toString()));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['pagos'];
      for (var juegoJson in data) {
        if(juegoJson ['turno_id']==id_turno_parametro && juegoJson ['turno_id']!=turno_id_cobrar &&juegoJson ['estado']=="No Pagado"){
          lista_notificacion_deudas.add(Deudas(monto_dinero: juegoJson ['monto_dinero'], fecha_limite: juegoJson ['fecha_limite'], tipo: juegoJson ['tipo'], 
          id_pago: juegoJson ['id'].toString(), text_deuda: "Pago "+juegoJson ['tipo']+" del "+nombre_turno_parametro+" del juego "+nombre_juego, turno_id_del_juego: id_turno_parametro.toString()));
        }
      }
    }
  }



Future<void> get_turnos_deudas(int numero_turno) async {
    final response = await http.get(Uri.parse('http://146.190.146.167/api/obtener_listado_de_turnos/' +id_juego.toString()));
    if (response.statusCode == 200) {
      
      final data = jsonDecode(response.body)['turnos'];
      lista_notificacion_deudas.clear();
      for (var juegoJson in data) {
        await obtener_pagos_usuario(juegoJson ['id'], "Turno "+numero_turno.toString());
        numero_turno = numero_turno + 1;
        
      }
      
    }
  }
  



class DeudasPagar extends StatefulWidget {
  const DeudasPagar({super.key});

  @override
  State<DeudasPagar> createState() => _DeudasPagarState();
}

class _DeudasPagarState extends State<DeudasPagar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Deudas",
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(184, 12, 214, 180),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            ListView.builder(
              shrinkWrap: true,
              itemCount: lista_notificacion_deudas.length,
              itemBuilder: (context, index) {
                return InvitationCard2(
                  index: index,
                  contenido: lista_notificacion_deudas[index].text_deuda,
                );
              },
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
                ElevatedButton(
                  onPressed: (){                 
                    objeto_deuda = lista_notificacion_deudas[index];
                    bandera_ya_pago = true;
                    Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PagarQR()),
                  
                );
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: const Text(
                      'Pagar',
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

