import 'package:flutter/material.dart';
import 'package:sharethought/view/home/home_page.dart';

import '../../constants/shared_pref_data.dart';
import '../../constants/value_constant.dart';
import '../auth/login/login.dart';

class SpalashScreen extends StatefulWidget {
  const SpalashScreen({super.key});

  @override
  State<SpalashScreen> createState() => _SpalashScreenState();
}

class _SpalashScreenState extends State<SpalashScreen> {

  Future<bool> checkLoginStatus() async {
    final token = await SharedPrefData().getUserId();
    if (token == null || token.isEmpty) {
      return false; 
    } else {
     return true; 
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkLoginStatus(),
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return const  Center(child:CircularProgressIndicator()); 
        }else{
          return snapshot.data == true ? HomePage(): Login();
        }
      },
    );

  }

}
