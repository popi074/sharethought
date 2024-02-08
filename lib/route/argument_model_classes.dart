import '../core/controllers/auth/model/usermodel.dart';
import '../model/post_model.dart';

class CommentSectionArguments {
  final PostModel postModel;
  final UserModel userData;

  CommentSectionArguments({required this.postModel, required this.userData});
}

class ChatArguments{
  final String chatId; 
  final UserModel guestUserData; 
  final UserModel userData; 
  ChatArguments({required this.chatId, required  this.guestUserData, required this.userData});
}
class ChatUserArguments{

  final UserModel userData; 
  ChatUserArguments({ required this.userData});
}
class SearchChatArguments{

  final UserModel userData; 
  SearchChatArguments({ required this.userData});
}
class AddEmailArguments{

  final String email; 
  final String password; 
  final String username;
  AddEmailArguments({required this.email,required this.password,required this.username,  });
}