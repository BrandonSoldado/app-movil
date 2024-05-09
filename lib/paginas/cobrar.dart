import 'package:app_movil/main.dart';
import 'package:flutter/material.dart';
import 'package:app_movil/paginas/notificaciones.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:qr_image/qr_image.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

String obtenerFechaHoraActual() {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
  return formattedDate;
}


Future<bool> ya_subio_qr_paga() async {
  final response = await http.get(Uri.parse('http://146.190.146.167/api/ganadorturnos/' + turno_id_cobrar));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    var ganadorTurno = data['ganadorturno']; // Accede al objeto 'ganadorturno' directamente
    if (ganadorTurno != null && ganadorTurno['estado'] == "Si se puede pagar") {
      return true;
    }
  }
  return false;
}



Future<void> subir_qr_cobra() async {
  if(await ya_subio_qr_paga()==false){
      final url = Uri.parse('http://146.190.146.167/api/ganadorturnos/'+turno_id_cobrar);
  final response = await http.put(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'fecha': obtenerFechaHoraActual(),
      'user_id': id_usuario.toString(),
      'turno_id': turno_id_cobrar,
      'estado': "Si se puede pagar",
      'qr_gandor_deposito': base64Image
    }),
  );
  
  if (response.statusCode == 200) {
    text_subir_qr_cobra = "QR Subido a la plataforma!";
  } 
  }
  else{
    text_subir_qr_cobra = "Ya subiste tu QR!";
  }
}


String turno_id_cobrar = "";
String base64Image = "";
String text_subir_qr_cobra = "";
int zzz = 0;

class CobrarQR extends StatefulWidget {
  const CobrarQR({Key? key}) : super(key: key);

  @override
  State<CobrarQR> createState() => _CobrarQRState();
}

class _CobrarQRState extends State<CobrarQR> {
  Uint8List? _qrImageData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cobrar Deudas',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(184, 12, 214, 180),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 35.0),
            const Text(
              'Ingresa un QR para que los demas puedan pagar',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 60.0),
            Stack(
              children: [
                Container(
                  width: 280.0,
                  height: 360.0,
                  color: Colors.grey[200],
                  child: _qrImageData != null
                      ? Image.memory(_qrImageData!)
                      : const Text(
                          'Aquí se mostrará el QR',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20.0),
                        ),
                ),
                Positioned(
                  top: 10.0,
                  right: 10.0,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        zzz = 0;
                        _qrImageData = null;
                      });
                    },
                    icon: const Icon(Icons.close),
                    color: Colors.black,
                    iconSize: 24.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _pickImageFromGallery,
                  child: const Text(
                    'Abrir',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(184, 12, 214, 180)),
                  ),
                ),
                const SizedBox(width: 100.0),
                ElevatedButton(
                  onPressed: () async{
                    await subir_qr_cobra();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title:  Text(text_subir_qr_cobra),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cerrar'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text(
                    'Subir',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(184, 12, 214, 180)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

Future<void> _pickImageFromGallery() async {
  final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    final bytes = await pickedFile.readAsBytes();
    base64Image = base64Encode(bytes);
    
    setState(() {
      zzz = 1;
    });
    _generateQrImageData(pickedFile.path);
  }
}

  Future<void> _generateQrImageData(String data) async {
    final qrImageData = await QrPainter(
      data: data,
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.L,
    ).toImageData(280);
    setState(() {
      _qrImageData = qrImageData!.buffer.asUint8List();
    });
  }
}