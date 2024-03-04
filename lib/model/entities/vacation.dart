import 'package:cloud_firestore/cloud_firestore.dart';

class Vacation {
  final String id;
  final DateTime date;

  Vacation({
    required this.id,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
    };
  }

  factory Vacation.fromJson(Map<String, dynamic> json) {
    return Vacation(
      id: json['id'] as String,
      date: (json['date'] as Timestamp).toDate(),
    );
  }
}
