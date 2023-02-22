import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../comun/com_helper.dart';
import '../comun/get_login_signup_header.dart';
import '../comun/gettextformfield.dart';
import '../databaseHelperHandler/db_helper.dart';
import '../model/password_encrypt.dart';
import 'fingerpoint_screen.dart';
import 'signup_form.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

  final _conUserName = TextEditingController();
  final _conUserPassword = TextEditingController();
  late DBHelper dbHelper;
  PassEncrypt encrypt = PassEncrypt();

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
  }

  login() async {
    String userName = _conUserName.text;
    String password = _conUserPassword.text;
    if (userName.isEmpty) {
      alertDialog(context, 'Ingrese el nombre de usuario');
    } else if (password.isEmpty) {
      alertDialog(context, 'Ingrese la contraseña');
    } else {
      String passwordEncrypt = encrypt.passwordEncryptSha256(password);
      await dbHelper.getLoginUsers(userName, passwordEncrypt).then((userData) {
        if (userData != null) {
          String rolUser = userData.rol;
          String nombre = userData.fullName;
          Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => FingerpointScreen(rolUser, nombre)),
                (Route<dynamic> route) => false);
        } else {
          alertDialog(context, 'Error: Usuario no encontrado!!!');
        }
      }).catchError((error) {
        print(error);
        alertDialog(context, 'Error: login fallado!!!');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista Asistencia app'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const GetLoginSignupHeader('Login'),
              const SizedBox(height: 10.0),
              GetTextFormField(
                  controller: _conUserName,
                  icon: Icons.person,
                  hintName: 'Nombre de usuario'),
              const SizedBox(
                height: 10.0,
              ),
              GetTextFormField(
                controller: _conUserPassword,
                icon: Icons.lock,
                hintName: 'Contraseña',
                isObscureText: true,
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextButton(
                  onPressed: login,
                  child: const Text(
                    "Entrar",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('¿No tiene cuenta?'),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignupForm()));
                      },
                      child: const Text(
                        'Registrarse',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
