import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharethought/route/route_generator.dart';
import 'package:sharethought/styles/kcolor.dart';
import 'package:sharethought/view/auth/login.dart';
import 'package:sharethought/view/auth/signup.dart';
import 'package:sharethought/view/home/home_page.dart';
import 'package:firebase_core/firebase_core.dart'; 

import 'every_test/addposttest.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp(); 
  runApp(ProviderScope(child:  MyApp()));
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
        accentColor: Kcolor.white, 
        fontFamily: 'Arimo', 
        textTheme: TextTheme(
          bodyText1: TextStyle(), 
          
        ),
        backgroundColor: Kcolor.white,
      ),
      onGenerateRoute: RouteGenerator.generateRoute,
      // home: AddPostPageTest(),
      home: SignUp(),
    );
  }
}
