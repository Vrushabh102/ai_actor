import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? _user;
  bool _isAuthenticated = false;
  String _userRole = '';

  UserModel? get user => _user;
  bool get isAuthenticated => _isAuthenticated;
  String get userRole => _userRole;

  Future<void> registerUser(String email, String password, String name, String role) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserModel newUser = UserModel(
        uid: userCredential.user!.uid,
        email: email,
        name: name,
        role: role,
        createdAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set(
            newUser.toMap(),
          );

      _user = newUser;
      _isAuthenticated = true;
      _userRole = role;
      notifyListeners();
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  Future<void> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot doc = await _firestore.collection('users').doc(userCredential.user!.uid).get();
      if (doc.exists) {
        _user = UserModel.fromFirestore(doc);
        _isAuthenticated = true;
        _userRole = _user!.role;
      }
      notifyListeners();
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<UserModel?> getCurrentUser() async {
    User? firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      DocumentSnapshot doc = await _firestore.collection('users').doc(firebaseUser.uid).get();
      if (doc.exists) {
        _user = UserModel.fromFirestore(doc);
        _isAuthenticated = true;
        _userRole = _user!.role;
        notifyListeners();
        return _user;
      }
    }
    _isAuthenticated = false;
    notifyListeners();
    return null;
  }

  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    _isAuthenticated = false;
    _userRole = '';
    notifyListeners();
  }
}