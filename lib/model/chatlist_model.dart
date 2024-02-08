import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharethought/core/controllers/auth/model/usermodel.dart';
import 'package:sharethought/core/network/database_constant.dart';

class ChatlistModel{

  
  UserModel guesUserData; 
  UserModel userData; 
  String chatId;  
 
  ChatlistModel({required this.guesUserData, required this.userData,required this.chatId});

}