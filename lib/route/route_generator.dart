import 'package:flutter/material.dart';
import 'package:sharethought/common_widget/comment_section.dart';
import 'package:sharethought/model/post_model.dart';
import 'package:sharethought/view/auth/login/login.dart';
import 'package:sharethought/view/auth/signup/signup.dart';
import 'package:sharethought/view/chat/chatlist.dart';
import 'package:sharethought/view/chat/chatpage.dart';
import 'package:sharethought/view/chat/serarch_chat.dart';
import 'package:sharethought/view/home/home_page.dart';
import 'package:sharethought/view/profile/profile_page.dart';
import 'package:sharethought/view/profile/widget/add_email.dart';
import 'package:sharethought/view/profile/widget/apply_email_code.dart';

import '../view/guestprofile/guest_profile.dart';
import 'argument_model_classes.dart';

class RouteGenerator {
  static const String addEmail = "/addemail";
  static const String searchChat = "/searchChat";
  static const String applyEmailCode = "/applyEmailCode";
  static const String login = "/login";
  static const String signup = "/signup";
  static const String home = "/home";
  static const String guestProfile = "/guestprofile";
  static const String chatListPage = "/chatListPage";
  static const String chatPage = "/chatPage";
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => Login());

      // sign up
      case signup:
        return MaterialPageRoute(builder: (_) => SignUp());
      case "/commentsection":
        return MaterialPageRoute(builder: (_) {
          final argument = args as CommentSectionArguments;
          // return CommentSection(postModel: settings.arguments as PostModel, userData: null,);
          return CommentSection(
              postModel: argument.postModel, userData: argument.userData);
        });
      case addEmail:
        final argumnet = args as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => AddEmail(
                  username: argumnet['username'],
                  userId: argumnet['userid'],
                ));
      case applyEmailCode:
        final argumnet = args as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) =>
                ApplyEmailCode(verficatoinCode: argumnet['username']));
      case home:
        return MaterialPageRoute(builder: (_) => HomePage());
      case guestProfile:
        return MaterialPageRoute(builder: (_) => GuestProfile());
      case chatListPage:
        final argument = args as ChatUserArguments;
        return MaterialPageRoute(
            builder: (_) => ChatListPage(
                  userData: argument.userData,
                ));
      case searchChat:
        final argument = args as SearchChatArguments;
        return MaterialPageRoute(
            builder: (_) => SearchChat(
                  userData: argument.userData,
                ));
      case chatPage:
        final argument = args as ChatArguments;
        return MaterialPageRoute(
            builder: (_) => ChatPage(
                  chatid: argument.chatId,
                  guestUserData: argument.guestUserData,
                  userData: argument.userData,
                ));

      default:
        return MaterialPageRoute(builder: (_) => Login());
    }
  }




}
