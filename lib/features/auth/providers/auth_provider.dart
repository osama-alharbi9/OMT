import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:omt/core/common/helpers/helper_functions.dart';
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
  final FirebaseAuth _auth;
 final FirebaseFirestore _dataBase;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseFirestore get dataBase=>_dataBase;

  Future<void> signIn(String name, String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      state = _auth.currentUser;
      showToast('signed');
      final userDoc =
          await _dataBase.collection('users').doc(_auth.currentUser!.uid).get();
          final userData=userDoc.data();
          state!.updateDisplayName(userData?['name']??'Anonymous');
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
  Future<void> googleSignIn(BuildContext context) async {

    try {
final googleUser = await _googleSignIn.signIn(); 
     if (googleUser == null) {
        print('Google Sign-In canceled');

        return;
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      state = userCredential.user;
      print('Signed in with Google: ${state?.displayName}');
    } catch (e) {
      print('Google Sign-In failed: $e');

      if (context.mounted) {
        showToast('Google Sign in faild: $e',isError: true);
      }
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
        final userDoc =
          await _dataBase.collection('users').doc(_auth.currentUser!.uid).get();
          final userData=userDoc.data();
                  state!.updateDisplayName(userData?['name']??'Anonymous');

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

  Stream<Map<String,List>> getUserLists() async* {
    try {
      final userLists =
          await _dataBase.collection('lists').doc(_auth.currentUser!.uid).get();
      final data = userLists.data() ?? {'': []};
      yield data.map((key, value) => MapEntry(key, List<dynamic>.from(value)));
    } catch (e) {
      print(e);
      yield {};
    }
  }
    } 
  

final authProvider = StateNotifierProvider<AuthProvider, User?>(
  (ref) => AuthProvider(),
);
