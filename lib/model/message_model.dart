import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharethought/core/network/database_constant.dart';

class MessageModel{

  
  String text; 
  String chatId;
  String senderId; 
  String receiverId; 
  String messageReply; 
  String replayTo;
  bool isSeen; 
  bool isActive = false;
  bool isSent = true;
  String messageId;   
  DateTime messageSentTime ; 
  MessageModel(this.text,this.chatId ,this.receiverId,this.messageReply,this.replayTo, this.senderId, this.isSeen, this.isActive,this.isSent, this.messageId,this.messageSentTime);



  factory MessageModel.formSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String,dynamic>; 
    DateTime date = snapshot[DatabaseConst.messageTime]?.toDate();
    return MessageModel(
      snapshot[DatabaseConst.messageText] ?? '',
      snapshot[DatabaseConst.chatId] ?? '',
      snapshot[DatabaseConst.reveiverId] ?? '',
      snapshot[DatabaseConst.messageReply] ?? '',
      snapshot[DatabaseConst.replyTo] ?? '',

      snapshot[DatabaseConst.senderId] ?? '',
      snapshot[DatabaseConst.isSeen] ?? false,
      snapshot[DatabaseConst.isActive] ?? '',
      snapshot[DatabaseConst.isSent] ?? false,
      snapshot[DatabaseConst.messageId] ?? '',
      date
      );
  }

}