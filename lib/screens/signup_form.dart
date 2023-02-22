import 'package:flutter/material.dart';

import '../comun/com_helper.dart';
import '../comun/get_login_signup_header.dart';
import '../comun/gettextformfield.dart';
import '../databaseHelperHandler/db_helper.dart';
import '../model/password_encrypt.dart';
import '../model/user_model.dart';
import 'login_form.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();

  final _conName = TextEditingController();
  final _conUserName = TextEditingController();
  final _conEmail = TextEditingController();
  final _conUserPassword = TextEditingController();
  final _conUserCPassword = TextEditingController();
  late DBHelper dbHelper;
  PassEncrypt encrypt = PassEncrypt();
  static const String admin = 'admin1234@gmail.com';

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
  }

  singUp() async {
    final form = _formKey.currentState;

    String name = _conName.text;
    String username = _conUserName.text;
    String email = _conEmail.text;
    String password = _conUserPassword.text;
    String confirmPass = _conUserCPassword.text;
    String rol;

    if (form != null) {
      if (form.validate()) {
        if (password != confirmPass) {
          alertDialog(context,'falta de coincidencia de contraseña');
        } else {
          form.save();
          String passwordEncrypt = encrypt.passwordEncryptSha256(password);
          rol = email == admin ? 'admin' : 'usuario';
          UserModel user =
              UserModel(fullName: name, email: email, password: passwordEncrypt, userName: username, rol: rol);
          await dbHelper.saveData(user).then((userData) {
            alertDialog(context,'Guardado correctamente');
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginForm()),
                (Route<dynamic> route) => false);
          }).catchError((error) {
            print(error);
            alertDialog(context,'Usuario existente');
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista Asistencia app'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const GetLoginSignupHeader('Registrarse'),
                const SizedBox(height: 10.0),
                GetTextFormField(
                  controller: _conUserName,
                  icon: Icons.person_outline,
                  hintName: 'Nombre de usuario',
                ),
                const SizedBox(
                  height: 10.0,
                ),
                GetTextFormField(
                  controller: _conName,
                  icon: Icons.person,
                  inputType: TextInputType.name,
                  hintName: 'Nombre completo',
                ),
                const SizedBox(
                  height: 10.0,
                ),
                GetTextFormField(
                  controller: _conEmail,
                  icon: Icons.email,
                  inputType: TextInputType.emailAddress,
                  hintName: 'Email',
                ),
                const SizedBox(
                  height: 10.0,
                ),
                GetTextFormField(
                  controller: _conUserPassword,
                  icon: Icons.lock,
                  hintName: 'Contraseña',
                  isObscureText: true,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                GetTextFormField(
                  controller: _conUserCPassword,
                  icon: Icons.lock,
                  hintName: 'Confirmar contraseña',
                  isObscureText: true,
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: TextButton(
                    onPressed: singUp,
                    child: const Text(
                      'Entrar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('¿Tiene cuenta?'),
                      TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginForm()),
                              (Route<dynamic> route) => false);
                        },
                        child: const Text(
                          'Iniciar Sesión',
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
      ),
    );
  }
}
