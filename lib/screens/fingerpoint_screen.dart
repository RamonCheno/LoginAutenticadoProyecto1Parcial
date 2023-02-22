// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';

import '../model/user_model.dart';
import 'home_screen.dart';

class FingerpointScreen extends StatefulWidget {
  const FingerpointScreen(this.rol, this.fullName, {Key? key}) : super(key: key);
  final String rol;
  final String fullName;

  @override
  State<FingerpointScreen> createState() => _FingerpointScreenState();
}

class _FingerpointScreenState extends State<FingerpointScreen> {
  LocalAuthentication auth = LocalAuthentication();
  String authorized = 'not authorized';
  bool _canCheckBiometric = false;
  late List<BiometricType> _availableBiometric;

  Future<void> _authenticate() async {
    bool autenticated = false;
    try {
      autenticated = await auth.authenticate(
        localizedReason: 'Escanee su huella para authenticar',
        options: const AuthenticationOptions(
            useErrorDialogs: true, stickyAuth: true, biometricOnly: true),
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: 'Lector biometrico para listaUnisierra',
            cancelButton: 'Cancelar',
          )],
      );

      if (autenticated == true) {
        if(widget.rol == 'admin'){
          // Navigator.pushAndRemoveUntil(
          //   context,
          //   MaterialPageRoute(builder: (context) => const AdminScreen()),
          //   (Route<dynamic> route) => false);
        }
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen(widget.fullName, widget.rol)),
            (Route<dynamic> route) => false);
      }
    } on PlatformException catch (e) {
      print(e);
    }
    setState(() {
      authorized =
          autenticated ? 'Autenticacion exitoso' : 'Autenticacion fallido';
      print(authorized);
    });
  }

  Future<void> _checkBiometric() async {
    bool canCheckBiometric = false;

    try {
      canCheckBiometric = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;
    setState(() => _canCheckBiometric = canCheckBiometric);
  }

  Future<void> _getAvailableBiometric() async {
    List<BiometricType> availableBiometric = [];

    try {
      availableBiometric = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }

    setState(() => _availableBiometric = availableBiometric);
  }

  @override
  initState() {
    super.initState();
    _checkBiometric();
    _getAvailableBiometric();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock, size: 40.0),
          const Center(
            child: Text('Aplicación bloqueada',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold)),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 150.0),
            child: Column(
              children: [
                IconButton(
                    onPressed: _authenticate,
                    icon: const Icon(Icons.fingerprint, size: 40.0,)),
                const Text(
                  'Autenticacion por huella digital',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
