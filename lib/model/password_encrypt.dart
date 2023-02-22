import 'dart:convert';
import 'package:crypto/crypto.dart';

class PassEncrypt {
  String passEncrypt ='';

  String passwordEncryptSha256(String pass) {
    /*Metodo de encriptacion y envio de pasword a clase user */
    var bytes = utf8.encode(pass);
    var sha = sha256.convert(bytes);
    passEncrypt = sha.toString();

    return passEncrypt;
  }
}