import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:i_tour/constants/constants.dart';

class Auth {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  Future<void> signWithEmailAndPassword(
      {required String email, required String password}) async {
    await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future createUserWithEmailAndPassword(
      {required String email,
      required String password,
      required String full_name}) async {
        // _firebaseAuth.sendEmailVerification()
    try {
      Position pos = await determinePosition();
      await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (currentUser != null) {
        var res = await firebaseInstance.collection("User").add({
          'auth_id': currentUser!.uid,
          'email':currentUser!.email,
          'full_name': full_name,
          'liveLocation': GeoPoint(pos.latitude, pos.longitude),
          'monitor': null
        });
        if (res.id.isNotEmpty) {
          return const Response(statusCode: 201);
        } else {
          throw Exception("user document not created");
        }
      } else {
        throw Exception("user auth not created");
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}
