import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class ToastService {
  static Future<ToastFuture> toast(
      BuildContext context, String text, Color color) async {
    return showToast(text,
        context: context,
        textStyle: const TextStyle(fontSize: 16, color: Colors.white),
        textPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        backgroundColor:
        color == Colors.white ? Colors.red.withOpacity(0.3) : color,
        animation: StyledToastAnimation.slideFromLeft,
        reverseAnimation: StyledToastAnimation.slideFromLeft,
        position: StyledToastPosition.bottom,
        animDuration: const Duration(milliseconds: 300),
        duration: const Duration(seconds: 3),
        curve: Curves.easeIn,
        reverseCurve: Curves.linear,
        borderRadius: BorderRadius.circular(16));
  }
}