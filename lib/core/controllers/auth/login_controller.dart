import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sharethought/constants/shared_pref_data.dart';
import 'package:sharethought/constants/value_constant.dart';
import 'package:sharethought/core/base_state/base_state.dart';
import 'package:sharethought/core/controllers/auth/model/usermodel.dart';
import 'package:sharethought/core/network/database_constant.dart';
import 'package:sharethought/core/network/network_util.dart';
import 'package:sharethought/route/route_generator.dart';
import 'package:sharethought/services/navigator_service.dart';
import 'package:sharethought/view/auth/login/state.dart';

final loginProvider = StateNotifierProvider<LoginController, BaseState>(
    (ref) => LoginController(ref: ref));

class LoginController extends StateNotifier<BaseState> {
  final Ref? ref;
  LoginController({this.ref}) : super(const InitialState());
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<void> login(
      {required String username, required String password}) async {
    state = LoadingState();
    if (await isNetworkAvabilable()) {
      try {
        QuerySnapshot querySnapshot = await firestore
            .collection('users')
            .where(DatabaseConst.username, isEqualTo: username)
            .limit(1)
            .get();
        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
          Map<String, dynamic> userData =
              documentSnapshot.data() as Map<String, dynamic>;
          String storedUsername = userData[DatabaseConst.username];
          String storedPassword = userData[DatabaseConst.password];
          String uid = userData[DatabaseConst.userId];
          print(storedPassword);
          print("========");
          if (userData[DatabaseConst.password] == password) {
            print("usermodel text");
            // print(UserModel.formSnap(userData[0]));
            toast("Login Successfull!");
            await SharedPrefData().setUserId(uid);

            state =
                LoginSuccessState(UserModel.formSnap(querySnapshot.docs[0]));
            NavigatorService.navigateToRouteName(RouteGenerator.home);
          } else {
            toast("Plesase Enter Correct Password");
          }
        } else {
          toast("Plesase Enter Correct Username");
        }
      } catch (e) {
        state = ErrorState();
        toast("Something went wrong!");
      }
    } else {
      state = ErrorState();
      toast("No Internet Connection!");
    }
  }

  Future<UserModel?> getUserData() async {
    try {
      if (await isNetworkAvabilable()) {
        final userid = await SharedPrefData().getUserId();
        print("user id is $userid");
        if (userid.isNotEmpty) {
          print(userid);
        }
        FirebaseFirestore _firestore = FirebaseFirestore.instance;
        QuerySnapshot querySnapshot = await _firestore
            .collection(DatabaseConst.users)
            .where(DatabaseConst.userId, isEqualTo: userid)
            .limit(1)
            .get();
        UserModel usermodel = UserModel.formSnap(querySnapshot.docs[0]);
        return usermodel;
      } else {
       
        toast("Something Went Wrong");
         return null;
      }
    } catch (e) {
      toast("Something Went Wrong");
      throw e;
    }
  }
}
