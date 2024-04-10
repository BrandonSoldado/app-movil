import 'package:app_movil/paginas/principal.dart';
import 'package:flutter/material.dart';

class registro extends StatelessWidget {
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController gmailController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController fechaController = TextEditingController();
  final TextEditingController ciController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(1, 68, 134, 1),
      body: cuerpo(context),
    );
  }

  Widget cuerpo(BuildContext context){
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            nombre(),
            SizedBox(height: 50,),
            usuario(),
            gmail(),
            Contrasea(),
            telefono(),
            fecha(),
            ci(),
            direccion(),
            SizedBox(height: 20,),
            registrar(context),
            SizedBox(height: 20,),
            cancelar(context),
          ],
        ),
      ),
    );
  }

  Widget nombre(){
    return Text("Ingrese sus Datos", style: TextStyle(color: Colors.white, fontSize: 35.0, fontWeight: FontWeight.bold),);
  }

  Widget usuario(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
      child: TextField(
        controller: usuarioController,
        decoration: InputDecoration(
          hintText: "Nombre de usuario",
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }

  Widget gmail(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
      child: TextField(
        controller: gmailController,
        decoration: InputDecoration(
          hintText: "gmail",
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }

  Widget Contrasea(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
      child: TextField(
        controller: contrasenaController,
        decoration: InputDecoration(
          hintText: "Contraseña",
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }

  Widget telefono(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
      child: TextField(
        controller: telefonoController,
        decoration: InputDecoration(
          hintText: "telefono",
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }

  Widget fecha(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
      child: TextField(
        controller: fechaController,
        decoration: InputDecoration(
          hintText: "fecha de nacimiento",
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }

  Widget ci(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
      child: TextField(
        controller: ciController,
        decoration: InputDecoration(
          hintText: "ci",
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }

  Widget direccion(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
      child: TextField(
        controller: direccionController,
        decoration: InputDecoration(
          hintText: "direccion",
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }

  Widget registrar(BuildContext context){
    return TextButton(
      onPressed: (){
        String usuario = usuarioController.text;
        String gmail = gmailController.text;
        String contrasena = contrasenaController.text;
        String telefono = telefonoController.text;
        String fecha = fechaController.text;
        String ci = ciController.text;
        String direccion = direccionController.text;
        
        // Realizar la validación de los datos y otras acciones necesarias
          if(gmail=="brandon60@" && contrasena=="12345"){
              Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=>principal()) 
        );
          }
          else{
            showDialog(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
      title: Text('El email o el telefono ya estan registrado o son invalidos!'),
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
        
      },
      child: Text("Registrarse", style: TextStyle(fontSize: 25, color: Colors.white),),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(184, 12, 214, 180)),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        ),
      ),
    );
  }

  Widget cancelar(BuildContext context){
    return TextButton(
      onPressed: (){
        Navigator.pop(context);
      },
      child: Text("Cancelar", style: TextStyle(fontSize: 25, color: Colors.white),),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(184, 214, 12, 12)),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        ),
      ),
    );
  }
}