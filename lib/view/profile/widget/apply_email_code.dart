import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharethought/common_widget/full_width_button.dart';
import 'package:sharethought/common_widget/kinput_field.dart';
import 'package:sharethought/common_widget/loading/k_circularloading.dart';
import 'package:sharethought/core/base_state/base_state.dart';
import 'package:sharethought/core/controllers/auth/verify_email_controller.dart';
import 'package:sharethought/route/route_generator.dart';
import 'package:sharethought/styles/ktext_style.dart';

import '../../../common_widget/common_app_bar.dart';
import '../../../common_widget/full_width_button.dart';

class ApplyEmailCode extends StatefulWidget {
  final String verficatoinCode; 
  const ApplyEmailCode({Key? key, required this.verficatoinCode, }) : super(key: key);

  @override
  _ApplyEmailCodeState createState() => _ApplyEmailCodeState();
}

class _ApplyEmailCodeState extends State<ApplyEmailCode> {
  final TextEditingController _emailCon = TextEditingController();
  final TextEditingController _passwordCon = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:const  CommonAppBar(title: "Add email"),
      body: Consumer(builder: (context, ref, _) {
        final emailProvider = ref.watch(verifyEmailProvier);
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Verification code has been sent in your email.",style: ktextStyle.font18,), 
              const SizedBox(height: 20,), 
              KInputField(
                hintText: "Enter code",
                icon: const Icon(Icons.email_outlined),
                controller: _emailCon,
                isEmail: true,
                onlyNumber: true, 
              ),
              const SizedBox(
                height: 15,
              ),
       
            
              const SizedBox(height: 30),
              if (emailProvider is LoadingState) ...{const KcircularLoading()},
              if (emailProvider is! LoadingState) ...{
                FullWidthButton(
                  text: "Update Email",
                  onTap: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // if (emailProvider !is LoadingState) {
                      //   ref.read(verifyEmailProvier.notifier).addEmail(
                      //       userId: widget.userId, 
                      //       email: _emailCon.text,
                      //       username: widget.username,
                      //       password: _passwordCon.text);
                      // }
                      //  ref.read(verifyEmailProvier.notifier).addEmail(
                      //       userId: widget.userId, 
                      //       email: _emailCon.text,
                      //       username: widget.username,
                      //       password: _passwordCon.text);
                    }

                    // Use the _controller as needed
                  },
                ),
              },
            ],
          ),
        );
      }),
    );
  }
}

