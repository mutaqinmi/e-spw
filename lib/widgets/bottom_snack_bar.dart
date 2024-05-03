import 'package:flutter/material.dart';

infoSnackBar({required BuildContext context, required String content}){
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
      behavior: SnackBarBehavior.floating,
    )
  );
}

successSnackBar({required BuildContext context, required String content}){
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
    )
  );
}

alertSnackBar({required BuildContext context, required String content}){
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
    )
  );
}