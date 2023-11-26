import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sharethought/core/base_state/base_state.dart';
import 'package:sharethought/core/network/database_constant.dart';
import 'package:uuid/uuid.dart';

import '../../constants/value_constant.dart';

  final signUpControllerProvider =
      StateNotifierProvider<SignUpController, BaseState>(
    (ref) {
      return SignUpController(ref: ref);
    },
  );

  class SignUpController extends StateNotifier<BaseState> {
    final Ref? ref;
    SignUpController({this.ref}) : super(const InitialState());
      
    var uuid = Uuid();
    Future<void> signUp(
        {required String username, required String password}) async {

      state = LoadingState();
      try {
        QuerySnapshot usernameCheck = await FirebaseFirestore.instance
            .collection("users")
            .where(DatabaseConst.username, isEqualTo: username)
            .get();
        if (usernameCheck.docs.isEmpty) {
          String uid = uuid.v1();
          await FirebaseFirestore.instance.collection("users").doc(uid).set({
            DatabaseConst.email: '',
            DatabaseConst.password: password,
            DatabaseConst.username: username,
            DatabaseConst.userId: uid,
          }).then((value) {
            state = SuccessState();
          });
        }
      } catch (e) {
        print("data not set $e");
        state = ErrorState();
      }
    }


      Future<bool> checkUsernameAvailability(String username) async {
    QuerySnapshot usernameCheck = await FirebaseFirestore.instance
        .collection("users")
        .where(DatabaseConst.username, isEqualTo: username)
        .get();
    return usernameCheck.docs.isEmpty;
  }
  }






final usernameControllerProvider = Provider<TextEditingController>((ref) {
  return TextEditingController();
});

final usernameAvailabilityProvider = FutureProvider.autoDispose<String>((ref) async {
  final firestore = FirebaseFirestore.instance;
  final username = ref.watch(usernameControllerProvider).text;

   bool isUsernameVaild = false; 


  final querySnapshot = await firestore.collection('users').where('username', isEqualTo: username).get();
  print(querySnapshot.docs.isEmpty);


  if(username.isEmpty){
    return '';
  }else if(username.isNotEmpty && (username.length <4 || !isUsernameValid(username))){
    return "Only can use alphanumeric characters, underscores and greater than 4.";
  }else if(querySnapshot.docs.isEmpty && username.isNotEmpty){
    isUsernameVaild = true; 
    return ValueConstant.usernameAvailable; 
  }else{
    return "username is taken! Please try another.";
  }

});
bool isUsernameValid(String username) {
    RegExp regex = RegExp(r'^[a-zA-Z0-9_]+$');
    return regex.hasMatch(username);
  }






// final usernameAvailabilityProvider = FutureProvider.autoDispose<String>((ref, username) async {
//   if (username.isNotEmpty && _isUsernameValid(username)) {
//     try {
//       final usernameCheck = await FirebaseFirestore.instance
//           .collection("users")
//           .where(DatabaseConst.username, isEqualTo: username)
//           .get();

//       return usernameCheck.docs.isEmpty;
//     } catch (e) {
//       print("Error checking username: $e");
//       return false;
//     }
//   } else {
//     return false;
//   }
// });