import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

confirmDialog(BuildContext context, Widget content, [Widget? title]){
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: title,
      content: content,
      actionsPadding: const EdgeInsets.all(10),
      actions: [
        TextButton(
          onPressed: (){
            context.pop();
          },
          child: const Text('OK'),
        )
      ],
    )
  );
}

deleteDialog(BuildContext context, Widget content, void Function()? action, [Widget? title]){
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: title,
        titleTextStyle: const TextStyle(
          color: Colors.red,
          fontSize: 25,
        ),
        content: content,
        actionsPadding: const EdgeInsets.all(10),
        actions: [
          TextButton(
            onPressed: (){
              context.pop();
            },
            style: const ButtonStyle(
              foregroundColor: MaterialStatePropertyAll(Colors.grey),
            ),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: action,
            style: const ButtonStyle(
              foregroundColor: MaterialStatePropertyAll(Colors.red),
            ),
            child: const Text('Hapus'),
          )
        ],
      )
  );
}