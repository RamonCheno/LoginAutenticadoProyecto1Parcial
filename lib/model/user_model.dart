class UserModel{
  late String fullName;
  late String userName;
  late String email;
  late String password;
  late String rol;

  UserModel({required this.fullName, required this.email, required this.password, required this.userName, required this.rol});

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      'Nombre_Usuario': userName,
      'Nombre_Completo': fullName,
      'Correo': email,
      'Contrasena':password,
      'Rol': rol
    };
    return map;
  }

  UserModel.formMap(Map<String, dynamic> map){
    userName = map['Nombre_Usuario'];
    fullName = map['Nombre_Completo'];
    email = map['Correo'];
    password = map['Contrasena'];
    rol = map['Rol'];
  }

}