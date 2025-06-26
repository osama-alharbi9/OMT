import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omt/core/common/helpers/helper_functions.dart';

class AuthProvider extends StateNotifier<User?> {
  AuthProvider([FirebaseAuth? auth, FirebaseFirestore? database])
    : _auth = auth ?? FirebaseAuth.instance,
      _dataBase = database ?? FirebaseFirestore.instance,
      super(FirebaseAuth.instance.currentUser) {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      state = user;
    });
  }
  FirebaseAuth _auth;
  FirebaseFirestore _dataBase;
  Future<void> signIn(String name, String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      state = _auth.currentUser;
      showToast('signed');
      final userDoc =
          await _dataBase.collection('users').doc(_auth.currentUser!.uid).get();
      print('signed in ');

      if (!userDoc.exists) {
        await _dataBase.collection('users').doc(_auth.currentUser!.uid).set({
          'name': name,
          'email': email,
        });
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
      state = null;
      showToast('Error',isError: true);
    }
  }

  Future<void> createNewUser(String name, String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (_auth.currentUser != null) {
        _dataBase.collection('users').doc().set({'name': name, 'email': email});
        showToast('user created');
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      state = null;
      showToast(e.message!);
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      state = null;
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }
}

final authProvider = StateNotifierProvider<AuthProvider, User?>(
  (ref) => AuthProvider(),
);
