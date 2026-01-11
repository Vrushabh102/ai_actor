import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/actor_profile_model.dart';
import '../models/casting_call_model.dart';
import '../models/match_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Actor Profile Methods
  Future<void> saveActorProfile(ActorProfile profile) async {
    try {
      await _firestore
          .collection('actor_profiles')
          .doc(profile.uid)
          .set(profile.toMap());
    } catch (e) {
      throw Exception('Error saving actor profile: $e');
    }
  }

  Future<ActorProfile?> getActorProfile(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('actor_profiles')
          .doc(uid)
          .get();
      if (doc.exists) {
        return ActorProfile.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Error fetching actor profile: $e');
    }
  }

  // Casting Call Methods
  Future<void> createCastingCall(CastingCall castingCall) async {
    try {
      await _firestore.collection('casting_calls').add(castingCall.toMap());
    } catch (e) {
      throw Exception('Error creating casting call: $e');
    }
  }

  Future<List<CastingCall>> getAllCastingCalls() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('casting_calls')
          .get();
      return snapshot.docs
          .map((doc) => CastingCall.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Error fetching casting calls: $e');
    }
  }

  Future<List<CastingCall>> getDirectorCastingCalls(String directorId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('casting_calls')
          .where('directorId', isEqualTo: directorId)
          .get();
      return snapshot.docs
          .map((doc) => CastingCall.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Error fetching director casting calls: $e');
    }
  }

  // Match Methods
  Future<void> createMatch(Match match) async {
    try {
      await _firestore.collection('matches').add(match.toMap());
    } catch (e) {
      throw Exception('Error creating match: $e');
    }
  }

  Future<List<Match>> getActorMatches() async {
    try {
      final String? userId = FirebaseAuth.instance.currentUser?.uid;
      log('Fetching matches for userId: $userId');
      QuerySnapshot snapshot = await _firestore
          .collection('matches')
          .where('directorId', isEqualTo: userId)
          .get();
      return snapshot.docs.map((doc) => Match.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Error fetching actor matches: $e');
    }
  }

  Future<List<Match>> getCastingAcceptedCallMatches() async {
    try {
      final String? userId = FirebaseAuth.instance.currentUser?.uid;
      log('Fetching matches for userId: $userId');
      QuerySnapshot snapshot = await _firestore
          .collection('matches')
          .where('actorId', isEqualTo: userId)
          .where('status', isEqualTo: 'accepted')
          .get();
      return snapshot.docs.map((doc) => Match.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Error fetching actor matches: $e');
    }
  }

  Future<void> updateMatchStatus(String matchId, String status) async {
    try {
      await _firestore.collection('matches').doc(matchId).update({
        'status': status,
      });
    } catch (e) {
      throw Exception('Error updating match status: $e');
    }
  }
}
