import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:espw/widgets/bottom_snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

String userNIS = '12225173';
String userPassword = '12345';

final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

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

void verify(BuildContext context, String password) async {
  final SharedPreferences prefs = await _prefs;

  if(!context.mounted) return;
  final redirected = context.goNamed('home');
  if(password == userPassword){
    prefs.setBool('isAuthenticated', true);
    successSnackBar(
      context: context,
      content: 'Login berhasil!'
    );

    redirected;
  } else {
    alertSnackBar(
      context: context,
      content: 'Password salah!'
    );
  }
}

void logout(BuildContext context) async {
  final SharedPreferences prefs = await _prefs;

  if(!context.mounted) return;
  final redirected = context.goNamed('signin');
  prefs.setBool('isAuthenticated', false);
  redirected;
}