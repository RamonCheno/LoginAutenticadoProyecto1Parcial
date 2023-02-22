import 'package:flutter/material.dart';

import '../databaseHelperHandler/db_helper.dart';
import '../model/user_model.dart';
import 'login_form.dart';

const darkBlueColor = Color(0xff486579);

class HomeScreen extends StatefulWidget {
  const HomeScreen(this.fullName, this.rol, {Key? key}) : super(key: key);
  final String fullName;
  final String rol;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista Asistencia app'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Bienvenido ${widget.rol} ${widget.fullName}', style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginForm()),
                      (Route<dynamic> route) => false);
                },
                child: const Text('Inicio')),
            if (widget.rol == 'admin')
              const Text(
                'SOY ADMINISTRADOR',
                style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
          ],
        ),
      ),
    );
  }
}
