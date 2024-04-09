import 'package:flutter/material.dart';

infoSnackBar({required BuildContext context, required String content}){
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    )
  );
}

successSnackBar({required BuildContext context, required String content}){
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
      backgroundColor: Colors.green,
    )
  );
}

alertSnackBar({required BuildContext context, required String content}){
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
      backgroundColor: Colors.red,
    )
  );
}