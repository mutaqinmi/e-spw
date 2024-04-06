import 'package:flutter/material.dart';

infoSnackBar({required BuildContext context, required String content}){
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
    )
  );
}

successSnackBar({required BuildContext context, required String content}){
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
    )
  );
}

alertSnackBar({required BuildContext context, required String content}){
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
    )
  );
}