import 'package:app_movil/paginas/principal.dart';
import 'package:app_movil/paginas/registro.dart';
import 'package:flutter/material.dart';

void main() => runApp(MiApp());

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Pasanaku",
      home: Inicio(),
    );
  }
}

class Inicio extends StatefulWidget {
  const Inicio({Key? key}) : super(key: key);

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(  
        color: Color.fromRGBO(1, 68, 134, 1),
        child: cuerpo(context), 
      ),   
    );
  }

  Widget cuerpo(BuildContext context){
    return Container(       
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[         
            inicio_sesion(),
            SizedBox(height: 40,),
            pasanaku(),
            image(),
            email(),
            contrasena(),
            SizedBox(height: 20,),
            boton_iniciar(context),
            SizedBox(height: 40,),
            boton_registro(context),
          ],
        )
      ),
    );
  }

  Widget pasanaku(){
    return Text("Pasanaku", style: TextStyle(color: Colors.white, fontSize: 35.0, fontWeight: FontWeight.bold),);
  }

  Widget image(){
    return Container(
      padding: EdgeInsets.only(left: 60,top: 5,right: 60,bottom: 60),
      child: Image.network("https://apuntesdetrabajosocial.com/wp-content/uploads/2023/06/ayuda-blog.jpg"),
    );
  }

  Widget inicio_sesion(){
    return Text("Iniciar Sesion", style: TextStyle(color: Colors.white, fontSize: 35.0, fontWeight: FontWeight.bold),);
  }

  Widget email(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
      child: TextField(
        controller: emailController,
        decoration: InputDecoration(
          hintText: "Email",
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }

  Widget contrasena(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
      child: TextField(
        controller: passwordController,
        obscureText: true,
        decoration: InputDecoration(
          hintText: "Contraseña",
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }

  Widget boton_iniciar(BuildContext context){
    return TextButton(
      onPressed: (){
        String email = emailController.text;
        String password = passwordController.text;
        // Aquí puedes usar el email y la contraseña para iniciar sesión
        if(email=="brandon60@" && password=="12345"){
            
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=>principal()) 
        );
        }else{
           showDialog(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
      title: Text('Usuario no existe!'),
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
      child: Text("Iniciar Sesion", style: TextStyle(fontSize: 25, color: Colors.white),),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(184, 12, 214, 180)),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        ),
      ),
    );
  }

  Widget boton_registro(BuildContext context){
    return TextButton(
      onPressed: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=>registro()) 
        );
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
}


