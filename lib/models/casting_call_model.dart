import 'package:cloud_firestore/cloud_firestore.dart';

class CastingCall {
  final String id;
  final String directorId;
  final String title;
  final String description;
  final String characterName;
  final String requiredGender;
  final int ageMin;
  final int ageMax;
  final List<String> requiredSkills;
  final List<String> requiredLanguages;
  final DateTime deadline;
  final DateTime createdAt;

  CastingCall({
    required this.id,
    required this.directorId,
    required this.title,
    required this.description,
    required this.characterName,
    required this.requiredGender,
    required this.ageMin,
    required this.ageMax,
    required this.requiredSkills,
    required this.requiredLanguages,
    required this.deadline,
    required this.createdAt,
  });

  factory CastingCall.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CastingCall(
      id: doc.id,
      directorId: data['directorId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      characterName: data['characterName'] ?? '',
      requiredGender: data['requiredGender'] ?? 'Any',
      ageMin: data['ageMin'] ?? 18,
      ageMax: data['ageMax'] ?? 60,
      requiredSkills: List<String>.from(data['requiredSkills'] ?? []),
      requiredLanguages: List<String>.from(data['requiredLanguages'] ?? []),
      deadline: (data['deadline'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'directorId': directorId,
      'title': title,
      'description': description,
      'characterName': characterName,
      'requiredGender': requiredGender,
      'ageMin': ageMin,
      'ageMax': ageMax,
      'requiredSkills': requiredSkills,
      'requiredLanguages': requiredLanguages,
      'deadline': Timestamp.fromDate(deadline),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}