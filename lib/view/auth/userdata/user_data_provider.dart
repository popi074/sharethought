import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharethought/constants/shared_pref_data.dart';
import 'package:sharethought/core/controllers/auth/model/usermodel.dart';

import '../../../core/controllers/auth/login_controller.dart';
import '../../../core/network/database_constant.dart';
import '../../../core/network/network_util.dart';


final userStream = StreamProvider.family<UserModel,String>((ref, userId) {
  return FirebaseFirestore.instance.collection(DatabaseConst.users)
  .where(DatabaseConst.userId,isEqualTo: userId).snapshots().map((snapshot) {
    print("----");
    print(UserModel.formSnap(snapshot.docs[0]));
     print("----");
    return UserModel.formSnap(snapshot.docs[0]);
  });
});