import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharethought/core/base_state/base_state.dart';

// author changes 
final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance); 
final authStateProvider = StreamProvider<User?>((ref){
  return ref.watch(firebaseAuthProvider).authStateChanges(); 
}); 

// login and sign up controller
// final authControllerProvider = Provider<AuthController, StateController<BaseState>>((ref) => AuthController())
final authControllerProvider =
    StateNotifierProvider<AuthController, BaseState>(
  (ref) {
    return AuthController(ref: ref);
  },
);
class AuthController extends StateNotifier<BaseState>{
  final Ref? ref; 
  AuthController({this.ref}): super(const InitialState());
  Future<void>login()async{

  }

  Future<void>signIn()async{
    
  }
 
}