import 'package:sharethought/core/base_state/base_state.dart';

class ChatEventSuccessState extends SuccessState{}
class CreateNewChatState extends SuccessState{
  final String text ; 
  CreateNewChatState(this.text);
}
class ChatEventErrorState extends ErrorState{
  final String errorText ; 
  ChatEventErrorState(this.errorText);
}