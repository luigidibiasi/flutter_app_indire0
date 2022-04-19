
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
      json['orainizio'] as TimeOfDay,
      json['orafine'] as TimeOfDay,
  );
}

Map<String, dynamic> _attivitaToJson(Attivita instance) =>
    <String, dynamic>{
      'data': instance.data,
      'orainizio': instance.orainizio,
      'orafine': instance.orafine,
    };
