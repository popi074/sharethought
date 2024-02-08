import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sharethought/core/base_state/base_state.dart';
import 'package:sharethought/core/controllers/auth/model/usermodel.dart';
import 'package:sharethought/core/network/database_constant.dart';
import 'package:sharethought/core/network/network_util.dart';

import '../../../route/route_generator.dart';
import '../../../services/navigator_service.dart';
import '../../../view/guestprofile/state.dart';

final guestProvider = StateNotifierProvider<GuestController, BaseState>(
    (ref) => GuestController(ref: ref));
final guestUserDataStream = StreamProvider.family<UserModel, String>((ref, guestUserId) {
    return FirebaseFirestore.instance.collection(DatabaseConst.users)
    .doc(guestUserId).snapshots().map((event) {
      return UserModel.formSnap(event);
    });
} );
class GuestController extends StateNotifier<BaseState> {
  final Ref? ref;
  GuestController({this.ref}) : super(const InitialState());
  final firestore = FirebaseFirestore.instance;
  getGeustData(String guestUserId) async {
    try {
      state = const LoadingState();
      if (await isNetworkAvabilable()) {
        QuerySnapshot querySnapshot = await firestore
            .collection(DatabaseConst.users)
            .where(DatabaseConst.userId, isEqualTo: guestUserId)
            .get();
        if (querySnapshot.docs.isNotEmpty) {
          state = GuestSuccessState(UserModel.formSnap(querySnapshot.docs[0]));
          print("guest data---");
          UserModel data = UserModel.formSnap(querySnapshot.docs[0]);
          print(UserModel.formSnap(querySnapshot.docs[0]));
          print(data.username);
          print("guest data--- end");
        } else {
          toast("User not found.");
          state = GuestErrorState("User not found.");
        }
      } else {
        toast(DatabaseConst.networkError);
      }
    } catch (e) {
      toast(DatabaseConst.wrong);
    }
  }

  follow(String guestUserId, String authUserId) async {
    try {
      if (await isNetworkAvabilable()) {
        await firestore.collection(DatabaseConst.users).doc(authUserId).update({
          DatabaseConst.following: FieldValue.arrayUnion([authUserId]),
        });
        await firestore
            .collection(DatabaseConst.users)
            .doc(guestUserId)
            .update({
          DatabaseConst.followers: FieldValue.arrayUnion([authUserId]),
        });
      } else {
        toast(DatabaseConst.networkError);
      }
    } catch (e) {
      toast(DatabaseConst.wrong);
    }
  }

  unFollow(String guestUserId, String authUserId) async {
    try {
    
        await firestore.collection(DatabaseConst.users).doc(authUserId).update({
          DatabaseConst.following: FieldValue.arrayRemove([authUserId]),
        });
        await firestore
            .collection(DatabaseConst.users)
            .doc(guestUserId)
            .update({
          DatabaseConst.followers: FieldValue.arrayRemove([authUserId]),
        });
      
    } catch (e) {
      toast(DatabaseConst.wrong);
    }
  }
}
