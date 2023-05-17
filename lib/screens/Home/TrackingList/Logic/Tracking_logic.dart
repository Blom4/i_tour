import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:i_tour/constants/constants.dart';
import 'package:i_tour/logic/Email.dart';
import 'package:i_tour/logic/firebase_auth.dart';

class TrackingLogic {
  static Future removePerson({required String user}) async {
    //search for current auth user then check monitor users if they exist
    bool isFound = true;
    var results = await firebaseInstance
        .collection("User")
        .where("email", isEqualTo: Auth().currentUser!.email!.toLowerCase())
        .get();
    var data;

    for (var element in results.docs.first.data()['monitor'] ?? []) {
      data = await element.get();
      if (user.toLowerCase() == data.data()['email'].toString()) {
        isFound = true;
        break;
      }
    }
    if (isFound) {
      await EmailCode.sendEmailToOnePerson(
          to: user.toLowerCase(),
          info:
              "Email, ${Auth().currentUser!.email!} has removed access to his/her tour tracking account",
          header: "Sorry to say goodbye",
          subject: "Access removed to tour tracking account ");
      var res = await firebaseInstance
          .collection("User")
          .where("email", isEqualTo: user.toLowerCase())
          .get();
      if (res.docs.isNotEmpty) {
        var result = await firebaseInstance
            .collection("User")
            .where("email", isEqualTo: Auth().currentUser!.email!.toLowerCase())
            .get();
        return await result.docs.first.reference.update({
          "monitor": FieldValue.arrayRemove([res.docs.first.reference])
        });
      }
    }
  }

  static Future addTrackingUser(
      {required String user, required isFound}) async {
    if (!isFound) {
      await EmailCode.sendEmailToOnePerson(
          to: user.toLowerCase(),
          info:
              "Email, ${Auth().currentUser!.email!} has given you access his/her tour tracking account.",
          header: "Please Track my Tour",
          subject: "Track my tour");
      var res = await firebaseInstance
          .collection("User")
          .where("email", isEqualTo: user.toLowerCase())
          .get();
      if (res.docs.isNotEmpty) {
        var result = await firebaseInstance
            .collection("User")
            .where("email", isEqualTo: Auth().currentUser!.email!.toLowerCase())
            .get();
        return await result.docs.first.reference.update({
          "monitor": FieldValue.arrayUnion([res.docs.first.reference])
        });
        // print(result.docs.first.reference);
      }

      // print(res.docs.first.reference);
    }
  }
}
