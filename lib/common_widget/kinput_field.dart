import 'package:flutter/material.dart';

import '../styles/kcolor.dart';

class KInputField extends StatelessWidget {
  final bool isObscure;
  final TextEditingController controller;
  final String hintText;
  final Icon icon;
  final ValueChanged<String>? onChange;
  final bool isEmail;
  
  final bool onlyNumber;
  const KInputField(
      {super.key,
      required this.hintText,
      required this.icon,
      required this.controller,
      this.isObscure = false,
      this.onChange,
      this.isEmail = false, this.onlyNumber = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if(isObscure)...{
             const ImageIcon(
                AssetImage("assets/images/lock.png"), 
                size: 18.0,
              )
            }, 
            if(!isObscure)...{
              icon
            }, 
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .8,
              child: TextFormField(
                onChanged: onChange,
                obscureText: isObscure,
                controller: controller,
                validator: (value) {
                   if (isEmail) {
                      // Check for email format using a regular expression
                      final emailRegex =
                          RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
                      if (!emailRegex.hasMatch(value ?? '')) {
                        return 'Please enter a valid email address';
                      }
                    }
                  if (value == null || value.isEmpty) {
                    // if (isEmail) {
                    //   // Check for email format using a regular expression
                    //   final emailRegex =
                    //       RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
                    //   if (!emailRegex.hasMatch(value ?? '')) {
                    //     return 'Please enter a valid email address';
                    //   }
                    // }
                    if (isObscure) {
                      return "Please you password";
                    } else {
                      return "please enter username";
                    }
                  }
                  return null;
                },
                keyboardType:onlyNumber? TextInputType.number:null ,
                decoration: InputDecoration(
                  border: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Kcolor.baseGrey)),
                  fillColor: Kcolor.white,
                  hintText: hintText,
                  
                  // contentPadding: const EdgeInsets.only(top: 15),
                ),
              ),
            ),
          ],
        ));
  }
}
