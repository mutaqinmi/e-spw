import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:e_spw/widgets/bottom_snack_bar.dart';

void signIn(BuildContext context, TextEditingController data){
  String userNIS = '12225173';
  if(data.text == userNIS){
    context.pushNamed('verify');
  } else {
    alertSnackBar(
        context,
        const Text('NIS salah / tidak ditemukan!')
    );
  }
}

void signUp(BuildContext context, TextEditingController data){
  String userNIS = '12225173';
  if(data.text == userNIS){
    successSnackBar(
        context,
        const Text('Login berhasil!')
    );
    context.goNamed('home');
  } else {
    alertSnackBar(
        context,
        const Text('NIS salah / tidak ditemukan!')
    );
  }
}

void verify(BuildContext context, TextEditingController data){
  String userPassword = 'ilham123';
  if(data.text == userPassword){
    successSnackBar(
        context,
        const Text('Login berhasil!')
    );
    context.goNamed('home');
  } else {
    alertSnackBar(
        context,
        const Text('Password salah!')
    );
  }
}