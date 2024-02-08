import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sharethought/core/base_state/base_state.dart';
import 'package:sharethought/core/controllers/auth/model/usermodel.dart';
import 'package:sharethought/core/network/database_constant.dart';
import 'package:sharethought/route/route_generator.dart';
import 'package:sharethought/view/chat/chatpage.dart';
import 'package:crypto/crypto.dart';

import '../../../model/chatlist_model.dart';
import '../../../model/message_model.dart';
import '../../../route/argument_model_classes.dart';
import '../../../services/navigator_service.dart';
import '../../../view/chat/state.dart';

final searchChatProvider = StateNotifierProvider<ChatSearch, BaseState>((ref) {
  return ChatSearch(ref: ref);
});

class ChatSearch extends StateNotifier<BaseState> {
  final Ref? ref;
  ChatSearch({this.ref}) : super(const InitialState());
  List<UserModel> userList = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  // NavigatorService.navigateToRouteName(RouteGenerator.chatPage,arguments: ChatArguments(chatId: chatId,userData: userData,guestUserData: guestUserData));
  void searchContact({
    required String username,
  }) async {
    print("search chat word in method: ${username}");
    try {
      state = const LoadingState();

      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where(DatabaseConst.username, isGreaterThanOrEqualTo: username)
          .where(DatabaseConst.username,
              isLessThan: '${username}z') // Use string interpolation
          .get();

      userList.clear();

      snapshot.docs.forEach((e) {
        print("inside model loop : ${e.data()}");
        userList.add(UserModel.formSnap(e));
      });
      state = SearchContactSuccessState(userlist: userList);
      print("user list is in mentod : $userList");
    } catch (e) {
      print("search chat error");
      state = SearchContactErrorState();
      toast("Something went wrong");
    }
  }
} //ChatSearch

class SearchContactSuccessState extends SuccessState {
  final List<UserModel> userlist;
  SearchContactSuccessState({required this.userlist});
}

class SearchContactErrorState extends ErrorState {}
