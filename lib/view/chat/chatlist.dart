import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharethought/common_widget/loading/k_circularloading.dart';
import 'package:sharethought/core/network/database_constant.dart';
import 'package:sharethought/route/route_generator.dart';
import 'package:sharethought/services/navigator_service.dart';
import 'package:sharethought/styles/kcolor.dart';
import 'package:sharethought/styles/ktext_style.dart';

import '../../common_widget/get_time.dart';
import '../../core/controllers/auth/model/usermodel.dart';
import '../../core/controllers/chat/chat_controller.dart';
import '../../route/argument_model_classes.dart';

class ChatListPage extends ConsumerStatefulWidget {
  final UserModel userData;

  const ChatListPage({super.key, required this.userData});

  @override
  ConsumerState<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends ConsumerState<ChatListPage> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final TextEditingController controller = TextEditingController();
    final chatUserListStream =
        ref.watch(chatUserListStreamProvider(widget.userData));
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
              _emptyContainer(context, widget.userData),
              Expanded(
                  child: chatUserListStream.when(data: (chatUsers) {
                print("chatuserlist is : $chatUsers");
                return ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 15.0),
                    itemCount: chatUsers.length,
                    itemBuilder: (context, index) {
                      print(
                          "guset username: ${chatUsers[index].guesUserData.username}");
                      print(
                          "main username: ${chatUsers[index].userData.username}");
                      return ChatUserCard(
                        ref: ref,
                        chatId: chatUsers[index].chatId,
                        guestUserData: chatUsers[index].guesUserData,
                        userData: chatUsers[index].userData,
                      );
                    });
              }, error: (e, s) {
                print("chatlist stream error, $e and $s");
                return const KcircularLoading();
              }, loading: () {
                return const KcircularLoading();
              })),
            ],
          ),
        ));
  }

  Widget _emptyContainer(BuildContext context, UserModel userData) {
    // return InkWell(
    //   onTap: () {
    //     NavigatorService.navigateToRouteName(RouteGenerator.searchChat,
    //         arguments: SearchChatArguments(
    //           userData: userData,
    //         ));
    //   },
    //   child: Container(
    //     height: 40,
    //     width: MediaQuery.of(context).size.width * 0.8,

    //     // padding: const EdgeInsets.only(left: 16.0),
    //     decoration: BoxDecoration(
    //       color: Colors.grey[300],
    //       borderRadius: BorderRadius.circular(30.0),
    //     ),
    //   ),
    // );
  
    return GestureDetector(
      onTap: (){
             NavigatorService.navigateToRouteName(RouteGenerator.searchChat,
            arguments: SearchChatArguments(
              userData: userData,
            ));
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 40.0,
        padding: const EdgeInsets.only(left: 16.0),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             Text("Search"), 

              Icon(
                Icons.search,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  
  
  }
}

class ChatUserCard extends StatelessWidget {
  final UserModel userData;
  final UserModel guestUserData;
  final String chatId;
  final WidgetRef ref;
  const ChatUserCard({
    super.key,
    required this.ref,
    required this.userData,
    required this.guestUserData,
    required this.chatId,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    String? lastmessage = null;
    String? time = null;
    final lastMessageStream = ref.watch(getLastMessageStream(chatId));
    if (lastMessageStream.asData != null) {
      lastmessage = lastMessageStream.asData!.value.text;
      print("lastmessage inside if loop: ${lastmessage}");
      time = getMessageTime(lastMessageStream.asData!.value.messageSentTime);
    }
    // print("lastmesset is ${lastMessageStream.asData!.value.text}");
    return InkWell(
      onTap: () {
        NavigatorService.navigateToRouteName(RouteGenerator.chatPage,
            arguments: ChatArguments(
                chatId: chatId,
                userData: userData,
                guestUserData: guestUserData));
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: 4),

        elevation: 0.04,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          contentPadding: const EdgeInsets.only(top: 0, left: 0.0, right: 10.0),
          // leading: const CircleAvatar(
          //   radius: 40,
          //   backgroundImage: AssetImage(DatabaseConst.personavater),
          // ),
           leading: guestUserData.photourl.isEmpty
                    ? const CircleAvatar(
                        radius: 25.0,
                        backgroundImage: AssetImage(DatabaseConst.personavater),
                      )
                    : CircleAvatar(
                        radius: 25.0,
                        backgroundImage: NetworkImage(guestUserData.photourl),
                      ),
          title: Padding(
            padding: const EdgeInsets.only(left: 0.0),
            child: Text(
              guestUserData.username,
              style: ktextStyle.font20
                  .copyWith(color: Colors.black..withOpacity(.8)),
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(left: 0.0),
            child: Text(
              lastmessage == null ? "" : lastmessage.toString(),
              overflow: TextOverflow.ellipsis,
              style: ktextStyle.font18,
            ),
          ),
          dense: true,
          trailing: Text(time == null ? "" : time.toString()),
        ),
        // trailing: Container(
        //   width: 20,
        //   height: 20,
        //   decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(10),
        //       border: Border.all(
        //           width: 3, color: Colors.blue)),
        //   alignment: Alignment.center,
        //   child: const Icon(Icons.check,
        //       size: 15, color: Colors.greenAccent),
        // ),
        // )
      ),
    );
  }
}
