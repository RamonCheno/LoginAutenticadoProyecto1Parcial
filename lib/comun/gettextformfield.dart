import 'package:flutter/material.dart';

import 'com_helper.dart';

class GetTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintName;
  final IconData icon;
  final bool isObscureText;
  final TextInputType inputType;

  const GetTextFormField(
      {required this.controller,
      required this.hintName,
      required this.icon,
      this.isObscureText = false,
      this.inputType = TextInputType.text,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        controller: controller,
        obscureText: isObscureText,
        keyboardType: inputType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            if (hintName == 'Confirmar contraseña') {
              return 'Confirma tu contraseña';
            } else {
              return 'Ingrese su $hintName';
            }
          }
          if (hintName == 'Email' && !validateEmail(value)) {
            return 'Ingrese un email valido';
          }
          return null;
        },
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              borderSide: BorderSide(color: Colors.blue)),
          prefixIcon: Icon(icon),
          hintText: hintName,
          labelText: hintName,
          fillColor: Colors.grey[200],
          filled: true,
        ),
      ),
    );
  }
}
