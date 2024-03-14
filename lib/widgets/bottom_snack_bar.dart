import 'package:flutter/material.dart';

infoSnackBar(BuildContext context, Widget content){
  return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: content,
      )
  );
}

successSnackBar(BuildContext context, Widget content){
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: content,
      backgroundColor: Colors.green,
    )
  );
}

alertSnackBar(BuildContext context, Widget content){
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: content,
      backgroundColor: Colors.red,
    )
  );
}