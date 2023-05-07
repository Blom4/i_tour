import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:i_tour/constants/constants.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signWithEmailAndPassword(
      {required String email, required String password}) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> createUserWithEmailAndPassword(
      {required String email, required String password,required String full_name}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password,);
      if (currentUser != null) {
        await firebaseInstance.collection("User").add({
          'auth_id': currentUser!.uid,
          'full_name':full_name,
          'liveLocation':const GeoPoint(0, 0),
          'monitor':null

        });
      } else {}
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
