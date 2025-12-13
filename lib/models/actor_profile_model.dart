import 'package:cloud_firestore/cloud_firestore.dart';

class ActorProfile {
  final String uid;
  final String name;
  final String bio;
  final int age;
  final String height;
  final String gender;
  final List<String> skills;
  final List<String> languages;
  final List<String> photoUrls;
  final List<String> videoUrls;
  final String experience; // 'fresher', 'intermediate', 'professional'
  final DateTime createdAt;

  ActorProfile({
    required this.uid,
    required this.name,
    required this.bio,
    required this.age,
    required this.height,
    required this.gender,
    required this.skills,
    required this.languages,
    required this.photoUrls,
    required this.videoUrls,
    required this.experience,
    required this.createdAt,
  });

  factory ActorProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ActorProfile(
      uid: doc.id,
      name: data['name'] ?? '',
      bio: data['bio'] ?? '',
      age: data['age'] ?? 18,
      height: data['height'] ?? '',
      gender: data['gender'] ?? '',
      skills: List<String>.from(data['skills'] ?? []),
      languages: List<String>.from(data['languages'] ?? []),
      photoUrls: List<String>.from(data['photoUrls'] ?? []),
      videoUrls: List<String>.from(data['videoUrls'] ?? []),
      experience: data['experience'] ?? 'fresher',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'bio': bio,
      'age': age,
      'height': height,
      'gender': gender,
      'skills': skills,
      'languages': languages,
      'photoUrls': photoUrls,
      'videoUrls': videoUrls,
      'experience': experience,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}