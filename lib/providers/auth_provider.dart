import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face2screen/models/user_model.dart';

enum AuthStatus { loading, unauthenticated, actor, director }

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? _user;
  AuthStatus _status = AuthStatus.loading;

  UserModel? get user => _user;
  AuthStatus get status => _status;

  /// 🔥 Call this ONCE at app start
  Future<void> initAuth() async {
    try {
      final firebaseUser = _auth.currentUser;

      if (firebaseUser == null) {
        _status = AuthStatus.unauthenticated;
        notifyListeners();
        return;
      }

      final doc = await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (!doc.exists) {
        await logout();
        return;
      }

      _user = UserModel.fromFirestore(doc);

      _status = _user!.role == 'actor' ? AuthStatus.actor : AuthStatus.director;

      notifyListeners();
    } catch (e) {
      log('Auth init error: $e');
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    }
  }

  Future<void> registerUser(
    String email,
    String password,
    String name,
    String role,
  ) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final newUser = UserModel(
      uid: credential.user!.uid,
      email: email,
      name: name,
      role: role,
      createdAt: DateTime.now(),
    );

    await _firestore.collection('users').doc(newUser.uid).set(newUser.toMap());

    _user = newUser;
    _status = role == 'actor' ? AuthStatus.actor : AuthStatus.director;

    notifyListeners();
  }

  Future<void> loginUser(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final doc = await _firestore
        .collection('users')
        .doc(credential.user!.uid)
        .get();

    if (!doc.exists) {
      await logout();
      return;
    }

    _user = UserModel.fromFirestore(doc);

    _status = _user!.role == 'actor' ? AuthStatus.actor : AuthStatus.director;

    notifyListeners();
  }

  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}
