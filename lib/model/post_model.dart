import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharethought/core/network/database_constant.dart';

class PostModel{

  String description; 
  String postId; 
  String userId; 
  String userName;
  List photoUrlList;  
  String profileUrl;
  List? likes;  
  int commentCount;  
  DateTime publisDate; 

  PostModel(this.description, this.postId, this.userId, this.userName, this.photoUrlList,this.profileUrl,this.likes,this.commentCount,this.publisDate);



  factory PostModel.formSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String,dynamic>; 
    DateTime date = snapshot[DatabaseConst.date]?.toDate();
    return PostModel(
      snapshot[DatabaseConst.description] ?? '',
      snapshot[DatabaseConst.postId] ?? '',
      snapshot[DatabaseConst.userId] ?? '',
      snapshot[DatabaseConst.username] ?? '',
      snapshot[DatabaseConst.photoUrlList] ?? [],
      snapshot[DatabaseConst.photoUrl] ?? '',
      snapshot[DatabaseConst.likes] ?? [],
      snapshot[DatabaseConst.commentCount] ?? [],
      date
      );
  }

}