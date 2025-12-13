import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String name;
  final String role; // 'actor' or 'director'
  final String? profileImage;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    this.profileImage,
    required this.createdAt,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      role: data['role'] ?? 'actor',
      profileImage: data['profileImage'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'role': role,
      'profileImage': profileImage,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}