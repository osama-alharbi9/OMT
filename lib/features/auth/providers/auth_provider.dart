import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omt/core/common/helpers/helper_functions.dart';
import 'package:omt/features/discover/models/media_model.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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
  FirebaseFirestore get dataBase=>_dataBase;
  Future<void> signIn(String name, String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      state = _auth.currentUser;
      showToast('signed');
      final userDoc =
          await _dataBase.collection('users').doc(_auth.currentUser!.uid).get();
      final userList =
          await _dataBase.collection('lists').doc(_auth.currentUser!.uid).get();
      print('signed in ');

      if (!userDoc.exists) {
        await _dataBase.collection('users').doc(_auth.currentUser!.uid).set({
          'name': name,
          'email': email,
        });
      }
      if (!userList.exists) {
        await _dataBase.collection('lists').doc(_auth.currentUser!.uid).set({
          'favourites': [],
          'shows': [],
          'movies': [],
          'watchlist': [],
        });
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
      state = null;
      showToast('Error', isError: true);
    }
  }
  Future<void> appleSignIn(BuildContext context) async {
    try {
      final appleUser = await SignInWithApple.getAppleIDCredential(scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName
      ]);
      final oAuthCredential = OAuthProvider('apple.com').credential(
          idToken: appleUser.identityToken,
          accessToken: appleUser.authorizationCode);
      final userCredential = await _auth.signInWithCredential(oAuthCredential);
      state = userCredential.user;
      print('Sign in with Apple: ${state!.displayName}');
    } catch (e) {
      print(e);
    }
  }

  Future<void> createNewUser(String name, String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (_auth.currentUser != null) {
        _dataBase.collection('users').doc(_auth.currentUser!.uid).set({
          'name': name,
          'email': email,
        });
        _dataBase.collection('lists').doc(_auth.currentUser!.uid).set({
          'favourites': [],
          'shows': [],
          'movies': [],
          'watchlist': [],
        });
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

  Future<Map<String, List<dynamic>>> getUserLists() async {
    try {
      final userLists =
          await _dataBase.collection('lists').doc(_auth.currentUser!.uid).get();
      return userLists.data() as Map<String, List<MediaModel>>;
    } catch (e) {
      print(e);
      return {};
    }
  }
}

final authProvider = StateNotifierProvider<AuthProvider, User?>(
  (ref) => AuthProvider(),
);
