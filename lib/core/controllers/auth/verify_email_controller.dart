import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sharethought/core/base_state/base_state.dart';
// import 'package:mailer/mailer.dart';
// import 'package:mailer/smtp_server/gmail.dart';
import 'package:sharethought/core/network/database_constant.dart';
import 'package:sharethought/core/network/network_util.dart';
// email sender

import 'package:email_sender/email_sender.dart';
// import 'package:mailer/mailer.dart';
// import 'package:mailer/smtp_server.dart';
// import 'package:email_sender/email_sender.dart';

// smtp
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
final verifyEmailProvier =
    StateNotifierProvider<EmailController, BaseState>((ref) {
  return EmailController(ref: ref);
});

class EmailController extends StateNotifier<BaseState> {
  final Ref? ref;
  EmailController({this.ref}) : super(const InitialState());
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addEmail({
    required String email,
    required String username,
    required String password,
    required String userId,
  }) async {
    // state = const LoadingState();
    if (await isNetworkAvabilable()) {
      try {
        // Check if the email is already used
        QuerySnapshot querySnapshot = await firestore
            .collection('users')
            .where(DatabaseConst.email, isEqualTo: email)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          state = ErrorState();
          print("This email is used");
          toast("This email is already used.");
        } else {
          print("this email not used");
          // var userData = querySnapshot.docs.first.data();
          // DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
          print("after getting doc $querySnapshot");

              final verificationCode = generateVerificationCode();
            await firestore.collection("verifyemail").doc(userId).set({
              DatabaseConst.verificationCode: verificationCode,
              DatabaseConst.isEmailVerified: false,
              DatabaseConst.verificationTimestamp: FieldValue.serverTimestamp(),
            }).then((value) {
             print("isnide then "); 
            }).catchError((e){
              print("error is firebase: $e"); 
            });
            print("verification function code =="); 
            await sendVerificationEmail(email, verificationCode);
             print("verification function code =="); 
          print("Verification code sent to $email");
          // state = const LoadingState();
        }
      } catch (e) {
        print("Error adding email: $e");
        // state = const ErrorState();
      }
    }
  }

  String generateVerificationCode() {
    // Implement your logic to generate a verification code
    // You may use a library or create your own logic
    return "123456"; // Replace with your code generation logic
  }



// Future<void> sendVerificationEmail(
//   String userEmail,
//   String verificationCode,
// ) async {

// }
Future<void> sendVerificationEmail(String email, String verificationCode) async {
  final smtpServer = gmail('Popiislam074@gmail.com', 'popiislam1999');

  // Create a message
  final message = Message()
    ..from = Address('Popiislam074@gmail.com', 'POPI ISLAM')
    ..recipients.add(email)
    ..subject = 'Email Verification'
    ..text = 'Your verification code is: $verificationCode';

  try {
    // Send the message
    final sendReport = await send(message, smtpServer);
      
    // Check if the email was sent successfully
    if(sendReport != null){
      print("send report not null : ${sendReport}"); 
    }else{
      print("send report  null : ${sendReport}"); 
    }
  }catch(e){
    print("send report error : ${e}"); 
  }
}



}
