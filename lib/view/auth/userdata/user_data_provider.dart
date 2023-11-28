import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharethought/constants/shared_pref_data.dart';
import 'package:sharethought/core/controllers/auth/model/usermodel.dart';

import '../../../core/network/database_constant.dart';



final getUserProvider = FutureProvider<String>((ref)async{
    // final userid = await SharedPrefData().getUserId();
    // if(userid.isNotEmpty){
    //   print(userid);
    // }
    // FirebaseFirestore _firestore = FirebaseFirestore.instance; 
    // QuerySnapshot querySnapshot =  await _firestore.collection(DatabaseConst.users).where(DatabaseConst.userId , isEqualTo: userid).limit(1).get();
    // DocumentSnapshot documentSnapshot = querySnapshot.docs[0]; 
    // UserModel userModel = UserModel.formSnap(documentSnapshot); 
    // print(userModel.username);
    // print(userModel);
    // return userModel;
    return "hi";
});




// final commentIdProvider = Provider<String>((ref) {
//   // Replace with your logic to get the comment ID
//   return 'your_dynamic_post_id';
// });

// final commentsProvider = FutureProvider<List<Comment>, String>((ref, id) async {
//   final firestore = ref.read(firebaseProvider);
//   final querySnapshot = await firestore.collection('comments').where('postId', isEqualTo: id).get();

//   // Convert QuerySnapshot to a List<Comment>
//   return querySnapshot.docs.map((doc) => Comment.fromMap(doc.data())).toList();
// });

// void fetchData() {
//   final container = ProviderContainer();
  
//   // Retrieve the comment ID
//   final commentId = container.read(commentIdProvider);

//   // Retrieve the data using the comment ID
//   final comments = container.read(commentsProvider(commentId));

//   // Now, you can work with the comments data
//   comments.when(
//     data: (commentsData) {
//       // Handle the list of comments
//       print(commentsData);
//     },
//     loading: () {
//       // Handle loading state
//       print('Loading...');
//     },
//     error: (error, stackTrace) {
//       // Handle error state
//       print('Error: $error');
//     },
//   );
// }