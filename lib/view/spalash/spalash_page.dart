import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharethought/view/auth/userdata/user_data_provider.dart';
import 'package:sharethought/view/home/home_page.dart';

import '../../common_widget/loading/k_circularloading.dart';
import '../../constants/shared_pref_data.dart';
import '../../constants/value_constant.dart';
import '../../core/controllers/auth/login_controller.dart';
import '../auth/login/login.dart';
import 'package:lottie/lottie.dart';

class SpalashScreen extends StatefulWidget {
  const SpalashScreen({super.key});

  @override
  State<SpalashScreen> createState() => _SpalashScreenState();
}

class _SpalashScreenState extends State<SpalashScreen> {

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {

      Future<bool> checkLoginStatus() async {
  final token = await SharedPrefData().getUserId();
  print("splash id : $token");

  // Create a Completer to handle the delayed return
  Completer<bool> completer = Completer<bool>();

  Future.delayed(const Duration(seconds: 3), () {
    if (token == null || token.isEmpty) {
      print("false get user id");
      completer.complete(false);
    } else {
      print("true get user id");
      ref.read(loginProvider.notifier).getUserData();
      completer.complete(true);
    }
  });

  // Return the Future from the Completer
  return completer.future;
}
      return FutureBuilder(
        future: checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return  Scaffold(
              // body:  Center(child: KcircularLoading())
              body:Center(
                child: Lottie.asset(
                  "assets/images/splash_animation.json", 
                ),
              )
              
              );
          } else {
            // print(snapshot.data!);
            //  ref.read(loginProvider.notifier).getUserData();
            // return snapshot.data != null ? HomePage() : Login();
            if( snapshot.data == false){
              return const Login();
            }else{
              return const HomePage();
            }
          }
        },
      );
    });
  }


}
