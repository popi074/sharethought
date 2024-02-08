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

final chatProvider = StateNotifierProvider<ChatController, BaseState>((ref) {
  return ChatController(ref: ref);
});

class ChatController extends StateNotifier<BaseState> {
  final Ref? ref;
  ChatController({this.ref}) : super(const InitialState());

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void createChatIfNotExist({
    otherUserId,
    required UserModel guestUserData,
    required UserModel userData,
  }) async {
    final String chatId = generateChatId(userData.uid, guestUserData.uid);
    try {
      final query = await firestore
          .collection(DatabaseConst.chat)
          .where(DatabaseConst.participents, arrayContains: [userData.uid])
          .where(DatabaseConst.chatId, isEqualTo: chatId)
          .limit(1)
          .get();
      if (query.docs.isNotEmpty) {
        NavigatorService.navigateToRouteName(RouteGenerator.chatPage,
            arguments: ChatArguments(
                chatId: chatId,
                guestUserData: guestUserData,
                userData: userData));
        print("doc is not empty");
      } else {
        await firestore.collection(DatabaseConst.chat).doc(chatId).set({
          DatabaseConst.participents: [userData.uid, guestUserData.uid],
          DatabaseConst.chatId: chatId,
        }).then((value) {
          NavigatorService.navigateToRouteName(RouteGenerator.chatPage,
              arguments: ChatArguments(
                  chatId: chatId,
                  guestUserData: guestUserData,
                  userData: userData));
        });
        print("doc is  empty");
      }
    } catch (e) {
      toast("Something went wrong");
    }
  }

  String generateChatId(String userid, String guestUserId) {
    String concatenatedIds = userid.compareTo(guestUserId) < 0
        ? "$userid$guestUserId"
        : "$guestUserId$userid";

    var bytes = utf8.encode(concatenatedIds);
    var hash = sha1.convert(bytes);
    return hash.toString();
  }

  // sendMessage({required text, required chatId, required senderId}) async {
  //   try {
  //     firestore
  //         .collection(DatabaseConst.chat)
  //         .doc(chatId)
  //         .collection(DatabaseConst.messageCollection)
  //         .add({
  //       DatabaseConst.senderId: senderId,
  //       DatabaseConst.messageText: text,
  //       DatabaseConst.chatId: chatId,
  //       DatabaseConst.isSeen: false,
  //       DatabaseConst.isActive: false,
  //       DatabaseConst.isSent: true,
  //       DatabaseConst.messageTime: DateTime.now()
  //     }).then((newChatRef) {
  //       newChatRef.update({
  //         DatabaseConst.messageId: newChatRef.id,
  //         DatabaseConst.isSent: true,
  //       });
  //       print("message sent");
  //     }).onError((error, stackTrace) {
  //       print("message not sent");
  //     });
  //   } catch (error) {
  //     state = ChatEventErrorState("Something went wrong");
  //     toast("Something went wrong");
  //   }
  // }

  Future<void> sendMessage({
    required String text,
    required String chatId,
    required String senderId,
    required String receiverId,
    required messageReply,
    required replayTo,
  }) async {
    late DocumentReference newChatRef;

    try {
      newChatRef = await firestore
          .collection(DatabaseConst.chat)
          .doc(chatId)
          .collection(DatabaseConst.messageCollection)
          .add({
        DatabaseConst.senderId: senderId,
        DatabaseConst.reveiverId: receiverId,
        DatabaseConst.messageReply: messageReply ?? '',
        DatabaseConst.replyTo: replayTo ?? '',
        DatabaseConst.messageText: text,
        DatabaseConst.chatId: chatId,
        DatabaseConst.isSeen: false,
        DatabaseConst.isActive: false,
        DatabaseConst.isSent: false, // Set initially as false
        DatabaseConst.messageTime: DateTime.now(),
      });

      await newChatRef.update({
        DatabaseConst.messageId: newChatRef.id,
        DatabaseConst.isSent: true,
      });

      print("Message sent successfully");
    } catch (error, stackTrace) {
      print("Error sending message: $error");
      print("Stack trace: $stackTrace");

      // Handle the error and update the isSent field to false
      await newChatRef.update({
        DatabaseConst.isSent: false,
      });

      print("Message not sent");
      // You can handle the error or update UI accordingly
    }
  }

  Future<void> setChatMessageSeen(String chatId, String messageId) async {
    await FirebaseFirestore.instance
        .collection(DatabaseConst.chat)
        .doc(chatId)
        .collection(DatabaseConst.messageCollection)
        .doc(messageId)
        .update({
      DatabaseConst.isSeen: true,
    });
  }
} //ChatController

final messageStreamProvider =
    StreamProvider.family<List<MessageModel>, String>((ref, chatId) {
  final query = FirebaseFirestore.instance
      .collection(DatabaseConst.chat)
      .doc(chatId)
      .collection(DatabaseConst.messageCollection)
      .orderBy(DatabaseConst.messageTime, descending: true)
      .limit(100);
  print("inside messageStreamProvdier");
  final stream = query.snapshots().map((snapshot) {
    print("snapshot is ${snapshot.docs.length}");
    return snapshot.docs.map((e) {
      return MessageModel.formSnap(e);
    }).toList();
  });

  return stream;
});

final loadMoreProvider =
    FutureProvider.family<List<MessageModel>, String>((ref, chatId) async {
  final asyncValue = ref.watch(messageStreamProvider(chatId));
  final lastMessageList = asyncValue.maybeWhen(
    data: (data) => data,
    orElse: () => null,
  );

  if (lastMessageList != null && lastMessageList.isNotEmpty) {
    final lastMessage = lastMessageList.last;

    final querySnapshot = await FirebaseFirestore.instance
        .collection(DatabaseConst.chat)
        .doc(chatId)
        .collection(DatabaseConst.messageCollection)
        .orderBy('timestamp', descending: true)
        .startAfter([lastMessage.messageSentTime])
        .limit(100)
        .get();

    final newMessages =
        querySnapshot.docs.map((doc) => MessageModel.formSnap(doc)).toList();
    // Return the messages or update the state as needed
    return [...lastMessageList, ...newMessages];
  }

  return []; // Return an empty list if no more messages to load
});

final chatUserListStreamProvider =
    StreamProvider.family<List<ChatlistModel>, UserModel>((ref, userData) {
  return FirebaseFirestore.instance
      .collection(DatabaseConst.chat)
      .where(DatabaseConst.participents, arrayContains: userData.uid)
      .snapshots()
      .map((snapshot) {
    List<ChatlistModel> chatList = [];

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      print("inside for loop");
      List<String> participentsIds =
          List<String>.from(doc[DatabaseConst.participents] ?? []);
      participentsIds.remove(userData.uid);

      if (participentsIds[0].isNotEmpty) {
        String otherUserId = participentsIds[0];
        print("otheruser id in stream is : $otherUserId");
        // fetch user data
        final userStream = ref.watch(userDataStreamProvider(otherUserId));
        if (userStream.asData != null) {
          ChatlistModel singleChatData = ChatlistModel(
              userData: userData,
              guesUserData: userStream.asData!.value,
              chatId: doc.get(DatabaseConst.chatId));
          chatList.add(singleChatData);
        }
      }
    }
    return chatList;
  });
});


// final chatUserListBySearchStreamProvider =
//     StreamProvider.family<List<UserModel>, String>((ref, userName) {
//       List<UserModel> guestUserList = []; 
//   return FirebaseFirestore.instance
//       .collection(DatabaseConst.users)
//       .snapshots()
//       .map((snapshot) {
//     List<ChatlistModel> chatList = [];
//     List<UserModel> guestUserList = [];
//     snapshot.docs.map((e) {
//       UserModel users = UserModel.formSnap(e); 
//       print("usermodel guest is : ${users}"); 
//       return UserModel.formSnap(e);
//     });
//     return guestUserList;
//   });
// });
// final SearchChatUser = StreamProvider.family<List<UserModel>, String>((ref, userName){
//   return FirebaseFirestore.instance.collection('users').where(DatabaseConst.username,isEqualTo: userName)
//     .snapshots().map((snapshot) {
//       return snapshot.docs.map((e) => UserModel.formSnap(e)).toList(); 
//     });
// });

// serach chat using if condition 

// final SearchChatUser =
//     StreamProvider.family<List<UserModel>, String>((ref, userName) {
//   if (userName.isEmpty) {
//     // Return an empty stream if the search query is empty
//     return Stream.value([]);
//   }
//   return FirebaseFirestore.instance
//       .collection('users')
//       .where(DatabaseConst.username, isEqualTo: userName)
//       .snapshots()
//       .map((snapshot) {
//     return snapshot.docs.map((e) => UserModel.formSnap(e)).toList();
//   });
// });

// using debunce to search 
// final searchQueryProvider = Provider<String>((ref) {
//   // Initial value for the debounce logic
//   return '';
// });

// final SearchChatUser = StreamProvider.family<List<UserModel>, String>((ref, userName) {
//   if (userName.isEmpty) {
//     return Stream.value([]); // Return an empty stream if the search query is empty
//   }

//   // Update the debounce logic to use Provider
//   ref.read(searchQueryProvider).value = userName;

//   // You can adjust the duration based on your requirements
//   return Future.delayed(const Duration(milliseconds: 500), () {
//     return FirebaseFirestore.instance
//       .collection('users')
//       .where(DatabaseConst.username, isGreaterThanOrEqualTo: userName)
//       .where(DatabaseConst.username, isLessThan: userName + 'z') // Adjust this to fit your needs
//       .get()
//       .then((snapshot) {
//         return snapshot.docs.map((e) => UserModel.formSnap(e)).toList();
//       });
//   }).asStream();
// });


//       return snapshot.docs.map((e) => PostModel.formSnap(e)).toList();
//   });

// });





// again  
final debounceDelayProvider = Provider<int>((ref) {
  // Set the delay for the debounce logic
  return 500; // Adjust this to fit your needs
});

// final searchQueryProvider = Provider<String>((ref) {
//   // Initial value for the search query
//   return '';
// });
// // final searchQueryProvider = StateProvider<String, String>((ref) {
// //   return '';
// // }, name: 'searchQueryProvider');

// final debouncedQueryProvider = FutureProvider<String>((ref) async {
//   final delay = ref.watch(debounceDelayProvider);
//   final query = ref.watch(searchQueryProvider);

//   // You can adjust the duration based on your requirements
//   await Future<void>.delayed(Duration(milliseconds: delay));

//   return query;
// });
// final SearchChatUser = StreamProvider.family<List<UserModel>, String>((ref, userName) {
//   if (userName.isEmpty) {
//     return Stream.value([]); // Return an empty stream if the search query is empty
//   }

//   // You can access the debounced query like this
//   final debouncedQuery = ref.watch(debouncedQueryProvider);

//   // You can adjust the duration based on your requirements
//   return Future.delayed(const Duration(milliseconds: 500), () async {
//     final snapshot = await FirebaseFirestore.instance
//       .collection('users')
//       .where(DatabaseConst.username, isGreaterThanOrEqualTo: debouncedQuery.value)
//       .where(DatabaseConst.username, isLessThan: '${debouncedQuery.value}z') // Use string interpolation
//       .get();

//     return snapshot.docs.map((e) => UserModel.formSnap(e)).toList();
//   }).asStream();
// });
// ===== worked ==== 
// final SearchChatUser = StreamProvider.family<List<UserModel>, String>((ref, userName) async* {
//   print("user is texst kkk:: ${userName}");
//   if (userName.isEmpty) {
//     yield []; // Return an empty list if the search query is empty
//     return;
//   }

//   // Debounce logic
//   // await Future<void>.delayed(const Duration(milliseconds: 500));

//   final snapshot = await FirebaseFirestore.instance
//     .collection('users')
//     .where(DatabaseConst.username, isGreaterThanOrEqualTo: userName)
//     .where(DatabaseConst.username, isLessThan: '${userName}z') // Use string interpolation
//     .get();
//     print("snapshot of serach is : ${snapshot.docs.length}");
//     print("snapshot lenght is: ${snapshot.docs.length}");
//     snapshot.docs.map((e) {
//       print("print data is : ${e}"); 
//     });

//   yield snapshot.docs.map((e) => UserModel.formSnap(e)).toList();
// });
// ==== worked end ===


// anothe process =====
class SearchTextFieldController extends StateNotifier<String> {
  SearchTextFieldController() : super('');

  void updateSearchQuery(String query) {
    state = query;
     print("stae is ${state}");
  }
 
}

final searchTextFieldControllerProvider = Provider<SearchTextFieldController>((ref) {
  return SearchTextFieldController();
});

final SearchChatUser = StreamProvider.family<List<UserModel>, String>((ref, userName) async* {
  final searchQuery = ref.watch(searchTextFieldControllerProvider);

  if (searchQuery.state.isEmpty) {
    yield []; // Return an empty list if the search query is empty
    return;
  }
  print("get search query is : ${searchQuery.state}");

  // Debounce logic
  // await Future<void>.delayed(const Duration(milliseconds: 500));

  final snapshot = await FirebaseFirestore.instance
    .collection('users')
    .where(DatabaseConst.username, isGreaterThanOrEqualTo: searchQuery.state)
    .where(DatabaseConst.username, isLessThan: '${searchQuery.state}z') // Use string interpolation
    .get();

  yield snapshot.docs.map((e) => UserModel.formSnap(e)).toList();
});

//another proces end =====

final userDataStreamProvider =
    StreamProvider.family<UserModel, String>((ref, userId) {
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .snapshots()
      .map((snapshot) {
    return UserModel.formSnap(snapshot);
  });
});

final getLastMessageStream =
    StreamProvider.family<MessageModel, String>((ref, chatId) {
  return FirebaseFirestore.instance
      .collection(DatabaseConst.chat)
      .doc(chatId)
      .collection(DatabaseConst.messageCollection)
      .orderBy(DatabaseConst.messageTime, descending: true)
      .limit(1)
      .snapshots()
      .map((snapshot) {
    return MessageModel.formSnap(snapshot.docs[0]);
  });
});
