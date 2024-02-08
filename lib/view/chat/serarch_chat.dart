import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharethought/common_widget/loading/k_circularloading.dart';
import 'package:sharethought/core/base_state/base_state.dart';
import 'package:sharethought/core/controllers/chat/chat_search_controller.dart';
import 'package:sharethought/core/network/database_constant.dart';
import 'package:sharethought/route/route_generator.dart';
import 'package:sharethought/services/navigator_service.dart';
import 'package:sharethought/styles/kcolor.dart';
import 'package:sharethought/styles/ktext_style.dart';

import '../../common_widget/get_time.dart';
import '../../core/controllers/auth/model/usermodel.dart';
import '../../core/controllers/chat/chat_controller.dart';
import '../../route/argument_model_classes.dart';

class SearchChat extends ConsumerStatefulWidget {
  final UserModel userData;

  const SearchChat({super.key, required this.userData});

  @override
  ConsumerState<SearchChat> createState() => _SearchChatState();
}

class _SearchChatState extends ConsumerState<SearchChat> {
  final TextEditingController nameController = TextEditingController();
  late FocusNode _searchFocusNode;
   void initState() {
    super.initState();
    _searchFocusNode = FocusNode();

    // Delay the focusing to ensure that the keyboard is displayed properly
    Future.delayed(Duration(milliseconds: 500), () {
      _searchFocusNode.requestFocus();
    });
  }
  @override
  void dispose() {

    super.dispose();
      _searchFocusNode.dispose();
    nameController.dispose();

  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    // final chatUserListStream = ref.watch(SearchChatUser(nameController.text));
    final chatController = ref.watch(chatProvider);
    final serchatState = ref.watch(searchChatProvider);

    final List<UserModel> userlist =
        serchatState is SearchContactSuccessState ? serchatState.userlist : [];

    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          foregroundColor: Colors.black,
          backgroundColor: Kcolor.transparent,
          title: Text(
            "Chats",
            style: ktextStyle.buttonText24
                .copyWith(color: Colors.black.withOpacity(.8)),
          ),
        ),
        body: SafeArea(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(),
              // Expanded(
              //     child: chatUserListStream.when(data: (chatUsers) {
              //   print("chatuserlist is : ${chatUsers.length}");
              //   return ListView.builder(
              //       shrinkWrap: true,
              //       padding: const EdgeInsets.only(top: 15.0),
              //       itemCount: chatUsers.length,
              //       itemBuilder: (context, index) {
              //         return ChatUserCard(
              //             ref: ref,
              //             userData: widget.userData,
              //             guestUserData: chatUsers[index],
              //             onTap: () {
              //               ref
              //                   .read(chatProvider.notifier)
              //                   .createChatIfNotExist(
              //                       guestUserData: chatUsers[index],
              //                       userData: widget.userData);
              //             });
              //         // return ChatUserCard(ref: ref, chatId: chatUsers[index].chatId, guestUserData: chatUsers[index].guesUserData, userData: chatUsers[index].userData,);
              //       });
              // }, error: (e, s) {
              //   print("chatlist stream error, $e and $s");
              //   return const KcircularLoading();
              // }, loading: () {
              //   return const KcircularLoading();
              // })),

              _buildSearchChatList(serchatState, userlist)
            ],
          ),
        ));
  }

  Widget _buildSearchChatList(
      BaseState serchatState, List<UserModel> userlist) {
    if (serchatState is LoadingState) {
      return const KcircularLoading();
    } else if (searchChatProvider is SearchContactErrorState) {
      return const KcircularLoading();
    } else {
      return ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.only(top: 15.0),
          itemCount: userlist.length,
          itemBuilder: (context, index) {
            return ChatUserCard(
                ref: ref,
                userData: widget.userData,
                guestUserData: userlist[index],
                onTap: () {
                  ref.read(chatProvider.notifier).createChatIfNotExist(
                      guestUserData: userlist[index],
                      userData: widget.userData);
                });
            // return ChatUserCard(ref: ref, chatId: chatUsers[index].chatId, guestUserData: chatUsers[index].guesUserData, userData: chatUsers[index].userData,);
          });
    }
  }
  Widget _buildTextField() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 40.0,
      padding: const EdgeInsets.only(left: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: nameController,
                focusNode: _searchFocusNode,
                onChanged: (value) {
                  ref
                      .read(searchChatProvider.notifier)
                      .searchContact(username: value);
                },
                decoration: const InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                ),
              ),
            ),
            Icon(
              Icons.search,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
  // Widget _buildTextField() {
  //   return Container(
  //     width: MediaQuery.of(context).size.width * 0.8,
  //     height: 40.0,
  //     padding: const EdgeInsets.only(left: 16.0),
  //     decoration: BoxDecoration(
  //       color: Colors.grey[300],
  //       borderRadius: BorderRadius.circular(30.0),
  //     ),
  //     child: Container(
  //       padding: const EdgeInsets.symmetric(horizontal: 16.0),
  //       child: Row(
  //         children: [
  //           Expanded(
  //             child: TextField(
  //               onChanged: (value) {
  //                 print("changnign word: ${value}");
        
  //                 // ref.read(SearchChatUser(value));
  //                 //  ref.read(searchTextFieldControllerProvider).updateSearchQuery(value);
  //                 ref
  //                     .read(searchChatProvider.notifier)
  //                     .searchContact(username: value);
  //               },
  //               decoration: const InputDecoration(
  //                 hintText: 'Search',
  //                 border: InputBorder.none,
  //               ),
  //             ),
  //           ),
  //           Icon(
  //             Icons.search,
  //             color: Colors.white,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  
  // }


}

class ChatUserCard extends StatelessWidget {
  final UserModel userData;
  final UserModel guestUserData;
  final VoidCallback onTap;

  final WidgetRef ref;
  const ChatUserCard(
      {super.key,
      required this.ref,
      required this.userData,
      required this.guestUserData,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    String? lastmessage = null;
    String? time = null;
    return InkWell(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: 4),
        elevation: 0.04,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          contentPadding: const EdgeInsets.only(top: 0, left: 0.0, right: 10.0),
          leading: const CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage(DatabaseConst.personavater),
          ),
          title: Padding(
            padding: const EdgeInsets.only(left: 0.0),
            child: Text(
              guestUserData.username,
              style: ktextStyle.font20
                  .copyWith(color: Colors.black..withOpacity(.8)),
            ),
          ),
          dense: true,
        ),
      ),
    );
  }
}
