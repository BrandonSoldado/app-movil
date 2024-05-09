import 'package:app_movil/paginas/deudas.dart';
import 'package:app_movil/paginas/pagar.dart';
import 'package:app_movil/paginas/principal.dart';
import 'package:app_movil/paginas/cobrar.dart';
import 'package:flutter/material.dart';
import 'package:app_movil/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';


String obtenerFechaHoraActual() {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
  return formattedDate;
}

String estado_oferta_enviada= "";

String nombre_juego = "";

String nombre_turno = "";
String id_turno = "";
String fecha_finalizacion_turno = "";
String fecha_inicio_turno = "";
int monto_minimo_ofertar = 0;
bool bandera_ya_oferto = false;


Future<void> usuario_ya_oferto(String id_turno_parametro) async {
    final response = await http.get(Uri.parse('http://146.190.146.167/api/obtener_listado_de_ofertas/' +id_turno_parametro));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['ofertas'];
      for (var juegoJson in data) {       
        if(id_usuario==juegoJson['user_id']){
          bandera_ya_oferto = true;
        }
      }    
    }
    else {
    print('XXXXXXXXXXXXXX: ${response.statusCode}');
   bandera_ya_oferto = false;
  }
  }



Future<void> obtener_monto_minimo_ofertar() async {
    final response = await http.get(Uri.parse('http://146.190.146.167/api/obtener_lista_de_juegos/' +id_usuario.toString()));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['juegos'];
      for (var juegoJson in data) {       
        if(id_juego==juegoJson['id']){
          monto_minimo_ofertar = int.parse(juegoJson['monto_minimo_para_ofertar']);
        }
      }    
    }
    else {
    print('YYYYYYYYYYYYYYYY ${response.statusCode}');
    monto_minimo_ofertar = 0;
  }
}


Future<void> dar_ofertar(String dinero) async {
  if(bandera_hay_turno_disponible){
    if(bandera_usuario_gano_turno==false){
          await usuario_ya_oferto(id_turno);
          if(bandera_ya_oferto==false){
            await obtener_monto_minimo_ofertar();
            if(int.parse(dinero) >= monto_minimo_ofertar){
            final response = await http.post(
    Uri.parse('http://146.190.146.167/api/ofertas'),
    body: jsonEncode({
      'monto_dinero': dinero,
      'fecha': obtenerFechaHoraActual(),
      'tipo': "oferta",
      'user_id': id_usuario.toString(),
      'turno_id': id_turno,
    }),
    headers: {'Content-Type': 'application/json'},
  );
  if (response.statusCode == 201) {
    final data = jsonDecode(response.body);
    print(data);
    estado_oferta_enviada = "Oferta enviada con exito!";
  } else {
    print('Failed to post data: ${response.statusCode}');
    estado_oferta_enviada = "Error! oferta enviada fuera de tiempo!";
  }
          }
          else{
            estado_oferta_enviada = "El monto minimo para ofertar es de "+monto_minimo_ofertar.toString()+" bs.";
          }
          }
          else{
            estado_oferta_enviada = "Ya ofertaste por este turno!";
          }
    }
    else{
    estado_oferta_enviada = "Ganaste algun turno, no podes ofertar!";
  }
  }
  else{
    estado_oferta_enviada = "No hay turnos disponibles para ofertar!";
  }
}








class VerJuego extends StatefulWidget {
  const VerJuego({super.key});

  @override
  State<VerJuego> createState() => _VerJuegoState();
}

class _VerJuegoState extends State<VerJuego> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: Text(nombre_juego,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  backgroundColor: Color.fromARGB(184, 12, 214, 180),
  actions: <Widget>[
    Row(
      children: <Widget>[
        boton_subir_qr(context),
        SizedBox(width: 2.0),
        boton_scanear_qr(context),
         SizedBox(width: 5.0),
      ],
    ),
  ],
),
      body: Container(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                buildTurnoInfo(),
                SizedBox(height: 70),
           
                ingresar_ofertar(),
                SizedBox(height: 14),
                boton_ofertar(context),
  
                
              ],
            ),
          ),
    );
  }
}

final TextEditingController ofertaController = TextEditingController();
//String password = passwordController.text;

Widget ingresar_ofertar() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 1),
    child: TextField(
      controller: ofertaController,
      decoration: InputDecoration(
        hintText: "ofertar(bs)",
        fillColor: Color.fromARGB(184, 12, 214, 180),
        filled: true,
      ),
      style: TextStyle(fontWeight: FontWeight.bold), // Aplica negrita al texto ingresado
    ),
  );
}


Widget boton_subir_qr(BuildContext context) {
  return TextButton(
    onPressed: (){
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => CobrarQR()));
    },
    child: Text(
      "Cobrar",
      style: TextStyle(fontSize: 15, color: Colors.black),
    ),
    style: ButtonStyle(
      backgroundColor:
          MaterialStateProperty.all<Color>(Colors.white),
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
        EdgeInsets.only(left: 1,top: 1,right: 1,bottom: 1),
      ),
    ),
  );
}



Widget boton_scanear_qr(BuildContext context) {
  return TextButton(
    onPressed: ()async{
      await get_turnos_deudas(1);
      Navigator.push(
          
          context, MaterialPageRoute(builder: (context) => DeudasPagar()));
    },
    child: Text(
      "Deudas",
      style: TextStyle(fontSize: 15, color: Colors.black),
    ),
    style: ButtonStyle(
      backgroundColor:
          MaterialStateProperty.all<Color>(Colors.white),
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
        EdgeInsets.only(left: 1,top: 1,right: 1,bottom: 1),
      ),
    ),
  );
}



Widget boton_ofertar(BuildContext context) {
  return TextButton(
    onPressed: () async {
      String s = ofertaController.text;
      await dar_ofertar(s);


      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(estado_oferta_enviada),
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


    },
    child: Text(
      "Enviar",
      style: TextStyle(fontSize: 25, color: Colors.black),
    ),
    style: ButtonStyle(
      backgroundColor:
          MaterialStateProperty.all<Color>(Color.fromARGB(184, 12, 214, 180)),
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      ),
    ),
  );
}


Widget buildTurnoInfo() {
  if(bandera_hay_turno_disponible){
      if(bandera_usuario_gano_turno==false){
        return Column(
    
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        nombre_turno + " esta disponible",
        style: TextStyle(
          color: Colors.black,
          fontSize: 22.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 3),
      Text(
        "Fecha inicio: " + fecha_inicio_turno,
        style: TextStyle(
          color: Colors.black,
          fontSize: 13.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        "Fecha finalización: " + fecha_finalizacion_turno,
        style: TextStyle(
          color: Colors.black,
          fontSize: 13.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
      }
      else{
        return Text("Ganaste un turno, no podes participar de mas turnos!",style: TextStyle(
          color: Colors.black,
          fontSize: 22.0,
          fontWeight: FontWeight.bold,
        ),);
        }
      
  }
  else{
  return Text("No hay turnos disponibles!",style: TextStyle(
          color: Colors.black,
          fontSize: 22.0,
          fontWeight: FontWeight.bold,
        ),);}
  
}