import 'package:flutter/material.dart';


class Toast {
  const Toast({ Key? key, this.message, this.duration });
  final message;
  final duration;

  Widget ToastBar(){
    return
      SnackBar(
        content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(message),
              ],
            ),
        duration: Duration(seconds: duration),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50)
        ),
        elevation: 15,
        width: 300,
        behavior: SnackBarBehavior.floating,
    );
  }
}