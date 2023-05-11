import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:i_tour/constants/constants.dart';
import 'package:i_tour/logic/firebase_auth.dart';

class TrackingLogic {
  static Future addTrackingUser(
      {required String user, required isFound}) async {
    if (!isFound) {
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
