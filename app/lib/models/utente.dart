import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app2/models/attivita.dart';

class Utente {
  String? nome;
  String? cognome;
  String? username;
  String? email;
  String? password;
  String? telefono;
  bool? admin;
  List<Attivita>? listaAttivita;
  String? referenceId;

  Utente(this.username, {this.nome, this.cognome, this.email, this.password, this.telefono, this.admin, this.listaAttivita, this.referenceId});
  factory Utente.fromSnapshot(DocumentSnapshot snapshot) {
    final newUtente = Utente.fromJson(snapshot.data() as Map<String, dynamic>);
    newUtente.referenceId = snapshot.reference.id;
    return newUtente;
  }

  factory Utente.fromJson(Map<String, dynamic> json) =>
      _utenteFromJson(json);
  Map<String, dynamic> toJson() => _utenteToJson(this);

  @override
  String toString() => 'Utente<$username>';
}


Utente _utenteFromJson(Map<String, dynamic> json) {
  return Utente(
    json['username'] as String,
    nome: json['nome'] as String,
    cognome: json['cognome'] as String,
    email: json['email'] as String,
    password: json['password'] as String,
    telefono: json['telefono'] as String,
    admin: json['admin'] as bool,
    listaAttivita:  _convertiAttivita(json['listaAttivita'] as List<dynamic>));
}

List<Attivita> _convertiAttivita(List<dynamic> vaccinationMap) {
  final activities = <Attivita>[];
  for (final activity in vaccinationMap) {
    activities.add(Attivita.fromJson(activity as Map<String, dynamic>));
  }
  return activities;
}


Map<String, dynamic> _utenteToJson(Utente instance) =>
    <String, dynamic>{
      'username': instance.username,
      'nome': instance.nome,
      'cognome': instance.cognome,
      'email': instance.email,
      'password': instance.password,
      'telefono': instance.telefono,
      'admin': instance.admin,
      'listaAttivita': _getListaAttivita(instance.listaAttivita),
    };


List<Map<String, dynamic>>? _getListaAttivita(List<Attivita>? activities) {
  if (activities == null) {
    return null;
  }
  final activityMap = <Map<String, dynamic>>[];
  activities.forEach((activity) {
    activityMap.add(activity.toJson());
  });
  return activityMap;
}





