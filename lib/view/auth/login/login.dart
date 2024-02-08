import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharethought/common_widget/full_width_button.dart';
import 'package:sharethought/core/base_state/base_state.dart';
import 'package:sharethought/styles/kcolor.dart';
import 'package:sharethought/styles/ksize.dart';
import 'package:sharethought/styles/ktext_style.dart';

import '../../../common_widget/dialog/dialog_helper.dart';
import '../../../common_widget/kinput_field.dart';
import '../../../common_widget/ksmall_button.dart';
import '../../../common_widget/loading/k_circularloading.dart';
import '../../../core/controllers/auth/login_controller.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> with SingleTickerProviderStateMixin {
  final TextEditingController usernameCon = TextEditingController();
  final TextEditingController passwordCon = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  @override
  void dispose() {
    super.dispose();
    usernameCon.dispose();
    passwordCon.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * .6;
      final loginState=  ref.watch(loginProvider);
    return Scaffold(
        body:  SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding:const EdgeInsets.only(left: 20, right: 20),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                            padding:
                                EdgeInsets.only(top: Ksize.getWidth(context, 80))),
                        Text(
                          "Welcome to Sharethought",
                          textAlign: TextAlign.center,
                          style: ktextStyle.headline.copyWith(color:Kcolor.secondary.withOpacity(1)),
                        ),
                        Padding(
                            padding:
                                EdgeInsets.only(top: Ksize.getWidth(context, 20))),
                        KInputField(
                          hintText: "Username",
                          icon: Icon(Icons.person_outline_outlined),
                          controller: usernameCon,
                        ),
                        SizedBox(
                          height: Ksize.getHeight(context, 10),
                        ),
                        KInputField(
                          hintText: "Password",
                          icon: Icon(Icons.wifi_password_outlined),
                          controller: passwordCon,
                          isObscure: true,
                        ),
                        SizedBox(
                          height: Ksize.getHeight(context, 30),
                        ),
                        if(loginState is LoadingState)...{
                         const KcircularLoading()
                        }, 
                        if(loginState is! LoadingState)...{
                           FullWidthButton(
                            text: "Login",
                            onTap: () {
                              
                              if (formKey.currentState?.validate() ?? false ) {
                                if(loginState is! LoadingState){
                                  ref.read(loginProvider.notifier).login(username: usernameCon.text, password: passwordCon.text);
                                }
                                // if(loginState is LoadingState){
                                //   Dialogs.showProgressBar(context,);
                                // }
                                
                              }
                              print("controller data");
                              print(usernameCon.text);
                              print(passwordCon.text);
                            }),
                        }
                       ,
                        SizedBox(
                          height: Ksize.getHeight(context, 20),
                        ),
                  
                        RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: "You Don't have any account?",
                                style: ktextStyle.mediumText.copyWith(color: Colors.black)),
                            TextSpan(
                                text: " Sign Up",
                                // style: TextStyle(color:Colors.black), 
                                style: ktextStyle.mediumText.copyWith(color: Colors.black),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushNamed(context, "/signup");
                                  })
                          ]),
                        )
                      ],
                    ),
                  ),
                ))
      
        );
  }
}

class BgCurve extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Kcolor.secondary
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(0, size.height) // Starting point at bottom-left
      ..quadraticBezierTo(
        size.width / 3, // Control point x for the first curve
        size.height / 2, // Control point y for the first curve
        size.width / 2, // End point x for the first curve
        size.height / 2, // End point y for the first curve
      )
      ..quadraticBezierTo(
        3 * size.width / 2, // Control point x for the second curve
        size.height / 4, // Control point y for the second curve
        size.width, // End point x for the second curve
        size.height, // End point y for the second curve
      );
    // final path = Path()
    //   ..moveTo(size.height/2,10)
    //   ..lineTo(1, 20)
    //   ..lineTo(21, -1)
    //   ..close();
    // ..quadraticBezierTo(
    //   size.width / 2, // control point x
    //   size.height,    // control point y
    //   size.width,      // end point x
    //   size.height / 2, // end point y
    // );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }
}
