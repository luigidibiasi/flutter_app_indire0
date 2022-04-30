import 'package:cloud_firestore/cloud_firestore.dart';
import 'attivita.dart';

class Utente {
  String? nome;
  String? cognome;
  String? email;
  String? password;
  String? telefono;
  bool? admin;
  List<Attivita>? listaAttivita = [];
  String? referenceId;

  Utente(this.email, {this.nome, this.cognome, this.password, this.telefono, this.admin, this.listaAttivita, this.referenceId});
  factory Utente.fromSnapshot(DocumentSnapshot snapshot) {
    final newUtente = Utente.fromJson(snapshot.data() as Map<String, dynamic>);
    newUtente.referenceId = snapshot.reference.id;
    return newUtente;
  }

  factory Utente.fromJson(Map<String, dynamic> json) =>
      _utenteFromJson(json);
  Map<String, dynamic> toJson() => _utenteToJson(this);

  @override
  String toString() => 'Utente<$email>';

  void deleteActivity(Attivita activity){
    this.listaAttivita?.remove(activity);
  }
}


Utente _utenteFromJson(Map<String, dynamic> json) {
  return Utente(
    json['email'] as String,
    nome: json['nome'] as String,
    cognome: json['cognome'] as String,
    password: json['password'] as String,
    telefono: json['telefono'] as String,
    admin: json['admin'] as bool,
    listaAttivita:  _convertiAttivita(json['listaAttivita'] as List<dynamic>));
}

List<Attivita> _convertiAttivita(List<dynamic> activitiesMap) {
  final activities = <Attivita>[];
  for (final activity in activitiesMap) {
    activities.add(Attivita.fromJson(activity as Map<String, dynamic>));
  }
  return activities;
}


Map<String, dynamic> _utenteToJson(Utente instance) =>
    <String, dynamic>{
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





