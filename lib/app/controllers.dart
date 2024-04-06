import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:espw/widgets/bottom_snack_bar.dart';
import 'package:espw/app/routes.dart';

String userNIS = '12225173';
String userPassword = '12345';

void signIn(BuildContext context, String nis){
  if(nis == userNIS){
    context.pushNamed('verify');
  } else {
    alertSnackBar(
      context: context,
      content: 'NIS salah / tidak ditemukan!'
    );
  }
}

void verify(BuildContext context, String password){
  if(password == userPassword){
    isAuthenticated = true;
    context.goNamed('home');
    successSnackBar(
      context: context,
      content: 'Login berhasil!'
    );
  } else {
    alertSnackBar(
      context: context,
      content: 'Password salah!'
    );
  }
}