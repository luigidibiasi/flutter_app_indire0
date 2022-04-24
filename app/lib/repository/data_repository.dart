import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/models/attivita.dart';
import '../models/utente.dart';


class DataRepository {
  final CollectionReference collection = FirebaseFirestore.instance.collection('Utenti');

  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }

  Future<DocumentReference> addUtente(Utente utente) {
    return collection.add(utente.toJson());
  }

  void updateUtente(Utente utente) async {
    await collection.doc(utente.referenceId).update(utente.toJson());
  }

  void deleteUtente(Utente utente) async {
    await collection.doc(utente.referenceId).delete();
  }

  Future<Utente?> checkCredentials(String username, String password) async {
    Utente? utente;
    await collection.where('username', isEqualTo: username).where('password', isEqualTo: password)
        .get()
        .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
            utente = Utente.fromJson(data!);
          });
        });
    return utente;
  }


  Future<List<Utente>> getAllUsers() async {
    List<Utente> utenti = [];
    await collection.where('admin', isEqualTo: false).get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Utente? utente;
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        utente = Utente.fromJson(data!);
        utente.referenceId = doc.reference.id;
        utenti.add(utente);
      });
    });
    return utenti;
  }


  Future<bool> checkUsername(String username) async {
    bool exists = false;
    await collection.where('username', isEqualTo: username)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        exists = true;
      });
    });
    return exists;
  }

  Future<Utente?> getByUsername(String username) async {
    Utente? utente;
    await collection.where('username', isEqualTo: username)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        utente = Utente.fromJson(data!);
        utente?.referenceId = doc.reference.id;
      });
    });
    return utente;
  }

  Future<bool> checkEmail(String email) async {
    bool exists = false;
    await collection.where('email', isEqualTo: email)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        exists = true;
      });
    });
    return exists;
  }

  Future<bool> checkTelefono(String telefono) async {
    bool exists = false;
    await collection.where('email', isEqualTo: telefono)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        exists = true;
      });
    });
    return exists;
  }

  List<Utente> filterUserActivities(List<Utente> utenti, DateTime date){
    List<Utente> filtered_users = [];
    utenti.forEach((element) {
      List<Attivita>? lista = element.listaAttivita;
      for (var a in lista!){
        if (a.data?.day == date.day){
          filtered_users.add(element);
          break;
        }
      }
    });
    return filtered_users;
  }

  Map<Attivita, Utente> getUserAndActivities(List<Utente> utenti, DateTime date){
    Map<Attivita, Utente> activities = {};
    utenti.forEach((element) {
      List<Attivita>? lista = element.listaAttivita;
      for (var a in lista!){
        if (a.data?.day == date.day){
          activities[a] = element;
        }
      }
    });
    return activities;
  }

  List<Utente> getAvailableUsers(List<Utente> utenti, DateTime date, TimeOfDay start, TimeOfDay end){
    double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute/60.0;
    List<Utente> filtered_users = [];
    utenti.forEach((element) {
      bool available = true;
      List<Attivita>? lista = element.listaAttivita;
      for (var a in lista!){
        if (a.data?.day == date.day){
          if (!(toDouble(a.orainizio!) > toDouble(start) && toDouble(end) <= toDouble(a.orainizio!)) ||
              !(toDouble(start) > toDouble(a.orainizio!) && toDouble(start) <= toDouble(a.orafine!))) {
            available = false;
            break;
          }
        }
      }
      if (available){
        filtered_users.add(element);
      }
    });
    return filtered_users;
  }
}