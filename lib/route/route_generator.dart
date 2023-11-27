

import 'package:flutter/material.dart';
import 'package:sharethought/common_widget/comment_section.dart';
import 'package:sharethought/view/auth/login/login.dart';
import 'package:sharethought/view/auth/signup/signup.dart';
import 'package:sharethought/view/home/home_page.dart';
import 'package:sharethought/view/profile/profile_page.dart';
import 'package:sharethought/view/profile/widget/add_email.dart';

class RouteGenerator{
  static const String addEmail = "/addemail";
  static const String login = "/login";
  static const String signup = "/signup";
  static const String home = "/home";
  static Route<dynamic> generateRoute(RouteSettings settings){
    final args = settings.arguments; 
    switch(settings.name){
      
      case login : 
        return MaterialPageRoute(builder: (_)=> Login());

      // sign up 
      case signup : 
        return MaterialPageRoute(builder: (_)=> SignUp());
      case "/commentsection":
        return MaterialPageRoute(builder: (_) =>CommentSection()); 
      case addEmail:
        return MaterialPageRoute(builder: (_) =>AddEmail());
      case home:
        return MaterialPageRoute(builder: (_) =>HomePage());

      
       default: 
        return  MaterialPageRoute(builder: (_)=> Login());
    }
  }


}