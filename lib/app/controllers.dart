import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:espw/widgets/bottom_snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// initializing global variable
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
const String _baseUrl = '192.168.115.242:8000';

void signIn(BuildContext context, String nis) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.http(_baseUrl, '/api/login');
  var response = await http.post(url, body: {
    'nis': nis
  }, headers: {
    'Content-Type': 'application/x-www-form-urlencoded'
  });

  if(!context.mounted) return;
  if(response.statusCode == 200){
    prefs.setInt('nis', json.decode(response.body)['data']['nis']);
    prefs.setString('nama', json.decode(response.body)['data']['nama']);
    prefs.setString('kelas', json.decode(response.body)['data']['kelas']);
    prefs.setString('password', json.decode(response.body)['data']['password']);
    prefs.setString('telepon', json.decode(response.body)['data']['telepon']);
    prefs.setString('foto_profil', json.decode(response.body)['data']['foto_profil']);
    prefs.setString('token', json.decode(response.body)['token']);

    context.pushNamed('verify');
  } else {
    context.pushNamed('login-failed');
  }
}

void verify(BuildContext context, String passwordText) async {
  final SharedPreferences prefs = await _prefs;
  final String? password = prefs.getString('password');

  if(!context.mounted) return;
  if(passwordText == password){
    prefs.setBool('isAuthenticated', true);
    successSnackBar(
      context: context,
      content: 'Login berhasil!'
    );

    context.goNamed('home');
  } else {
    alertSnackBar(
      context: context,
      content: 'Password salah!'
    );
  }
}

void logout(BuildContext context) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.http(_baseUrl, '/api/logout');
  var response = await http.post(url, body: {
    'token': prefs.getString('token')
  }, headers: {
    'Content-Type': 'application/x-www-form-urlencoded'
  });

  if(response.statusCode == 200){
    if(!context.mounted) return;
    prefs.clear();
    prefs.setBool('isAuthenticated', false);
    context.goNamed('signin');
  }
}