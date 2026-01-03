import 'package:cloud_firestore/cloud_firestore.dart';

class Match {
  final String id;
  final String castingCallId;
  final String actorId;
  final String directorId;
  final double matchScore;
  final String status; // 'pending', 'accepted', 'rejected', 'interested'
  final DateTime createdAt;

  Match({
    required this.id,
    required this.castingCallId,
    required this.actorId,
    required this.directorId,
    required this.matchScore,
    required this.status,
    required this.createdAt,
  });

  factory Match.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Match(
      id: doc.id,
      castingCallId: data['castingCallId'] ?? '',
      actorId: data['actorId'] ?? '',
      directorId: data['directorId'] ?? '',
      matchScore: (data['matchScore'] ?? 0).toDouble(),
      status: data['status'] ?? 'pending',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'castingCallId': castingCallId,
      'actorId': actorId,
      'directorId': directorId,
      'matchScore': matchScore,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
