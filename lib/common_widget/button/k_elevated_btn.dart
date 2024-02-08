import 'package:flutter/Material.dart';

import '../../styles/kcolor.dart';
import '../../styles/ktext_style.dart';

class KelevatedButton extends StatelessWidget {
  const KelevatedButton({
    super.key, required this.onPressed, required this.text,
  });

  final VoidCallback onPressed;
  final String text ;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(

        padding:const  EdgeInsets.symmetric(horizontal: 30,vertical: 8),
        textStyle: ktextStyle.font18..copyWith(color: Colors.white..withOpacity(.9)), 
      ),
      child: Text(text),
    );
  }
}
