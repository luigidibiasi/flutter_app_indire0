import 'package:flutter_app2/repository/data_repository.dart';

DataRepository repository = DataRepository();
class Validator {
  static String? validateName({required String name}) {
    if (name == null) {
      return null;
    }
    if (name.isEmpty) {
      return 'Name can\'t be empty';
    }

    return null;
  }

  static String? validateSurname({required String name}) {
    if (name == null) {
      return null;
    }
    if (name.isEmpty) {
      return 'Surname can\'t be empty';
    }

    return null;
  }

  static String? validateEmail({required String email}) {
    if (email == null) {
      return null;
    }

    email = email.trim();
    RegExp emailRegExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    if (email.isEmpty) {
      return 'Email can\'t be empty';
    } else if (!emailRegExp.hasMatch(email)) {
      return 'Enter a correct email';
    }

    return null;
  }


  static String? validatePassword({required String password}) {
    if (password == null) {
      return null;
    }
    if (password.isEmpty) {
      return 'Password can\'t be empty';
    } else if (password.length < 6) {
      return 'Enter a password with length at least 6';
    }

    return null;
  }

  static String? validateTelefono({required String telefono}) {
    if (telefono == null) {
      return null;
    }
    telefono = telefono.trim();
    RegExp emailRegExp = RegExp(r"^[0-9]{10}");
    
    if (telefono.isEmpty) {
      return 'Password can\'t be empty';
    } else if (!emailRegExp.hasMatch(telefono)) {
      return 'Enter a correct telephone number';
    }

    return null;
  }



  static String? validateUsername({required String username}) {
    if (username == null) {
      return null;
    }
    if (username.isEmpty) {
      return 'Username can\'t be empty';
    }

    return null;
  }

}