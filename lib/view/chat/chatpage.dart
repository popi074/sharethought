import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharethought/common_widget/loading/k_circularloading.dart';
import 'package:sharethought/core/base_state/base_state.dart';
import 'package:sharethought/core/network/database_constant.dart';
import 'package:sharethought/styles/kcolor.dart';
import 'package:sharethought/styles/ktext_style.dart';
import 'package:sharethought/view/chat/state.dart';
import '../../core/controllers/auth/login_controller.dart';
import '../../core/controllers/auth/model/usermodel.dart';
import '../../core/controllers/chat/chat_controller.dart';
import '../../model/message_model.dart';
import '../auth/login/state.dart';

class ChatPage extends StatefulWidget {
  final String chatid;
  final UserModel guestUserData;
  final UserModel userData;
  const ChatPage(
      {super.key,
      required this.chatid,
      required this.guestUserData,
      required this.userData});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController textCon = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Consumer(builder: (context, ref, _) {
      final chatState = ref.watch(chatProvider);
      final messageStreamPro = ref.watch(messageStreamProvider(widget.chatid));
    
      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              chatPageAppBar(context),
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: messageStreamPro.when(
                        data: (data) {
                          return ListView.builder(
                            controller: _scrollController,
                            shrinkWrap: true,
                            reverse: true, 
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              if(data[index].senderId != widget.userData.uid && data[index].isSeen == true){
                                   ref.watch(chatProvider.notifier).setChatMessageSeen(data[index].chatId, data[index].messageId);
                              }
                              final previousMessage = index+1==data.length? data[index]: index+1<data.length?data[index+1]:null;
                                final afterMessage = (index - 1)>=0  && (index-1)<=data.length? data[index - 1]: null;

                                print("message:${data[index].text} isSeen:${data[index].isSeen}  isSent:${data[index].isSent}  time:${data[index].messageSentTime} messageid:${data[index].messageId}");
                              if (data[index].senderId == widget.userData.uid) {
                                return userMessage(width,
                                    messageModel: data[index]);
                              } else {
                                return otherUser(width,
                                    messageModel: data[index],previousMessage: previousMessage,afterMessage: afterMessage,userId: widget.userData.uid, guestUserId: widget.guestUserData.uid);
                              }
                            },
                          );
                        },
                        error: (e, s) {
                          return const KcircularLoading();
                        },
                        loading: () {
                          // return const KcircularLoading();
                          return const SizedBox();
                        })),
              ),

//                         Expanded(
//                           child: Padding(
//                               padding:
//                                   const EdgeInsets.only(left: 10, right: 10),
//                               child: StreamBuilder<List<MessageModel>>(
//  stream: ref.watch(messageStreamProvider(chatId)),
//   builder: (context, snapshot) {
//     if (snapshot.connectionState == ConnectionState.waiting) {
//       return const KcircularLoading();
//     } else if (snapshot.hasError) {
//       return const KcircularLoading();
//     } else {
//       List<MessageModel> data = snapshot.data ?? [];
//       return ListView.builder(
//         controller: _scrollController,
//         shrinkWrap: true,
//         itemCount: data.length,
//         itemBuilder: (context, index) {
//           if (data[index].senderId == widget.userData.uid) {
//             return userMessage(width, messageModel: data[index]);
//           } else {
//             return otherUser(width, messageModel: data[index]);
//           }
//         },
//       );
//     }
//   },
// ),
//                               ),
//                         ),

              buildTextField(width, ref, widget.userData, widget.guestUserData)
            ],
          ),
        ),
      );
    });
  }

  Widget buildTextField(double width, WidgetRef ref, UserModel userData, UserModel receiverData) {
    return Padding(
      padding: EdgeInsets.only(
          left: width * .05, right: width * .05, top: 10.0, bottom: 10.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textCon,
              maxLines: 3,
              minLines: 1,
              style: ktextStyle.smallTextBold
                  .copyWith(color: Colors.black.withOpacity(.5)),
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(
                      left: 10, right: 10, top: 0, bottom: 0),
                  filled: true,
                  fillColor: Colors.grey[300],
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(25.0),
                  )),
            ),
          ),
          const SizedBox(width: 10),
          Consumer(builder: (context, ref, _) {
            return IconButton(
                onPressed: () {
                  if (textCon.text.isNotEmpty) {
                    ref.read(chatProvider.notifier).sendMessage(
                        text: textCon.text,
                        chatId: widget.chatid,
                        senderId: userData.uid , 
                        receiverId: receiverData.uid, 
                        messageReply: null, 
                        replayTo: null
                        );
                        textCon.clear();
                  }
                },
                icon: Icon(Icons.send));
          })
        ],
      ),
    );
  }

  Widget chatPageAppBar(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context)
                .pop(); // This will pop the current route and go back
          },
        ),
        Expanded(
          child: ListTile(
            // contentPadding: const EdgeInsets.only(left: 16.0, top: 5.0),
            leading: widget.guestUserData.photourl.isNotEmpty
                ? CircleAvatar(
                    radius: 30.0,
                    backgroundImage:
                        NetworkImage(widget.guestUserData.photourl))
                : const CircleAvatar(
                    radius: 30.0,
                    backgroundImage: AssetImage(DatabaseConst.personavater),
                  ),
            title: Text(widget.guestUserData.username.toString() ?? ""),
            // subtitle: Text("10 minutes ago"),
            trailing: const Icon(
              Icons.info_outline,
              size: 25,
              color: Colors.blueAccent,
            ),
          ),
        )
      ],
    );
  }

  Widget otherUser(double width, {required MessageModel messageModel , 
   MessageModel? previousMessage,
   MessageModel? afterMessage, 
  required String userId, 
  required String guestUserId
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const CircleAvatar(
            radius: 10,
            backgroundImage: AssetImage(DatabaseConst.personavater),
          ),
          const SizedBox(width: 5),
          SizedBox(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: width * 0.7,
              ),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                // color: const Color.fromARGB(255, 230, 229, 229),
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 81, 49, 207), 
                    Color.fromARGB(255, 206, 55, 106), 
                  ]
                ),
                borderRadius: BorderRadius.only(
                  topLeft: previousMessage != null && previousMessage.senderId == guestUserId ? const Radius.circular(5.0) :const Radius.circular(15),  
                  topRight: const Radius.circular(15), 
                  bottomLeft: afterMessage !=null && afterMessage.senderId == guestUserId? const Radius.circular(5.0) :const Radius.circular(15), 
                  bottomRight: const Radius.circular(15), 
                 
                  
                ),
              ),
              child: Text(
                messageModel.text,
                style: ktextStyle.font20
                  .copyWith(color: Colors.white.withOpacity(1)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget userMessage(double width, {required MessageModel messageModel}) {
    print("inside userdata isSent: ${messageModel.isSent}");
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: width * .7,
          padding: const EdgeInsets.only(top: 15, left: 15, right: 10),
          alignment: Alignment.centerRight,
          child: Text(
            messageModel.text,
            textAlign: TextAlign.right,
            style:ktextStyle.font20
              .copyWith(color: Colors.black..withOpacity(.5)),
          ),
        ),
        Container(
          width: 15,
          height: 15,
          padding: const EdgeInsets.only(bottom: 15.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color:messageModel.isSent? Colors.blue : Colors.transparent,
              border: Border.all(width: 2, color: Colors.blueAccent)),
          alignment: Alignment.center,
          child: const Icon(Icons.check, size: 11, color: Colors.white),
        ),
      ],
    );
  }
}
