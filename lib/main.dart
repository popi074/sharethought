import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharethought/constants/shared_pref_data.dart';
// import 'package:sharethought/core/network/da tabase_constant.dart';
import 'package:sharethought/route/route_generator.dart';
import 'package:sharethought/services/navigator_service.dart';
import 'package:sharethought/styles/kcolor.dart';
import 'package:sharethought/view/auth/login/login.dart';
import 'package:sharethought/view/auth/signup/signup.dart';
import 'package:sharethought/view/chat/chatlist.dart';
import 'package:sharethought/view/chat/chatpage.dart';
import 'package:sharethought/view/home/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sharethought/view/spalash/spalash_page.dart'; 
import 'common_widget/loading/k_post_shimmer.dart';
import 'every_test/addposttest.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp(); 
  runApp(const ProviderScope(child:  MyApp()));
}




class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Kcolor.secondary,
        // accentColor: Kcolor.white, 
        fontFamily: 'Arimo', 
        textTheme: TextTheme(
          bodyText1: TextStyle(), 
        ), 
        backgroundColor: Kcolor.white,
      ),
      onGenerateRoute: RouteGenerator.generateRoute,
      navigatorKey: NavigatorService.navigatorKey,
      // home: AddPostPageTest(),
      home: const SpalashScreen() 
      // home: ChatListPage()
      // home: ChatPage()
    );
  }
}


