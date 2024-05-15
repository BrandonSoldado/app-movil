import 'package:app_movil/main.dart';
import 'package:app_movil/paginas/deudas.dart';
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

bool bandera_ya_pago = false;
Future<void> pagar_qr_escaneado() async {
  final url = Uri.parse('http://146.190.146.167/api/pagos/'+objeto_deuda.id_pago);
  final response = await http.put(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
  "descripcion" : "test",
  "monto_dinero" : objeto_deuda.monto_dinero,
  "fecha_limite" : objeto_deuda.fecha_limite,
  "tipo" : objeto_deuda.tipo,
  "user_id" : id_usuario.toString(),
  "turno_id" : objeto_deuda.turno_id_del_juego,
  "estado" : "Pagado"
    }),
  );
  
  if (response.statusCode == 200) {
    print('XXXXXXXXXXX');
  } else {
    print('YYYYYYYYYYYYY ${response.statusCode}');
  }
}





Future<void> obtener_qr_cobra() async {
  if(bandera_ya_pago){
    final response = await http.get(Uri.parse('http://146.190.146.167/api/ganadorturnos/' + objeto_deuda.turno_id_del_juego));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body)['ganadorturno'];
    if (data['estado'] != "No se puede pagar") {
          await pagar_qr_escaneado();
          text_escanear_qr_paga = "Pago realizado mediante QR!";
          bandera_ya_pago = false;

    } 
    else {
    text_escanear_qr_paga = "El ganador no subió el QR de pago!";
  }
  } 
  }
  else{
    text_escanear_qr_paga = "Ya pagaste mediante QR!";
  }
}












Deudas objeto_deuda = Deudas(monto_dinero: "", fecha_limite: "", tipo: "", id_pago: "", text_deuda: "", turno_id_del_juego: "");
class NotificacionDeudas {
  final String text_deudas;
  NotificacionDeudas({required this.text_deudas});
}


int zzz = 0;

String base64Image = "";

String base64Image2 = "";

String text_escanear_qr_paga = "";


class PagarQR extends StatefulWidget {
  const PagarQR({Key? key}) : super(key: key);

  @override
  State<PagarQR> createState() => _PagarQRState();
}

class _PagarQRState extends State<PagarQR> {
  Uint8List? _qrImageData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pagar Deudas',
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
              'Ingresa un QR y escanealo para pagar',
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
                    await obtener_qr_cobra();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title:  Text(text_escanear_qr_paga),
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
                    'Escanear',
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
final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    final bytes = await pickedFile.readAsBytes();
    base64Image = base64Encode(bytes);
    print('Base64 Image: $base64Image'); // Imprimir base64Image aquí
    
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