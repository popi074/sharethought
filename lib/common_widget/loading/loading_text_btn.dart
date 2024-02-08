
import 'package:flutter/material.dart';

import '../../styles/kcolor.dart';
import '../../styles/ktext_style.dart';

class LoadingTextBtn extends StatelessWidget {
  const LoadingTextBtn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 15,
            height: 15,
            child: const CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor:
                  AlwaysStoppedAnimation<Color>(Kcolor.white),
            ),
          ),
          Text(
          "loading",
            style: ktextStyle.font18.copyWith(color: Colors.white..withOpacity(.9)),
          ),
        ],
      );
  }
}
