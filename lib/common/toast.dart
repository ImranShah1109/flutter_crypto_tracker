import 'package:flutter/material.dart';


class Toast {
  const Toast({ Key? key, this.message, this.duration });
  final message;
  final duration;

  Widget ToastBar(){
    double length = message.length > 20 ? message.length * 10 : message.length * 16;
    return
      SnackBar(
        content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(child: Text(message)),
              ],
            ),
        duration: Duration(seconds: duration),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50)
        ),
        elevation: 15,
        width: length,
        behavior: SnackBarBehavior.floating,
    );
  }
}