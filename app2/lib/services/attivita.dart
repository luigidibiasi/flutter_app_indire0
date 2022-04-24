
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Attivita {
  DateTime? data;
  TimeOfDay? orainizio;
  TimeOfDay? orafine;

  Attivita(this.data, this.orainizio, this.orafine);
  factory Attivita.fromJson(Map<String, dynamic> json) =>
      _attivitaFromJson(json);
  // 4
  Map<String, dynamic> toJson() => _attivitaToJson(this);

  @override
  String toString() => 'Utente<$data>';
}

Attivita _attivitaFromJson(Map<String, dynamic> json) {
  return Attivita(
      (json['data'] as Timestamp).toDate(),
      firebaseToTimeOfDay(json['orainizio']),
      firebaseToTimeOfDay(json['orafine']),
  );
}

Map<String, dynamic> _attivitaToJson(Attivita instance) =>
    <String, dynamic>{
      'data': instance.data,
      'orainizio': timeOfDayToFirebase(instance.orainizio!),
      'orafine': timeOfDayToFirebase(instance.orafine!),
    };


int timeOfDayToFirebase(TimeOfDay timeOfDay){
  return timeOfDay.hour*3600+timeOfDay.minute*60;
}

TimeOfDay firebaseToTimeOfDay(int data){
  int hour = data~/3600;
  int rest = data - hour * 3600;
  int minutes = rest ~/ 60;
  return TimeOfDay(
      hour: hour,
      minute: minutes);
}

