import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:espw/widgets/bottom_snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// initializing global variable
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
const String baseUrl = 'lucky-premium-redfish.ngrok-free.app';

Future<http.Response> postData(String apiURL, Map body) async {
  final url = Uri.https(baseUrl, apiURL);
  var response = await http.post(url, body: body, headers: {
    'Content-Type': 'application/x-www-form-urlencoded'
  });

  return response;
}

Future<http.Response> getData(String apiURL) async {
  final url = Uri.https(baseUrl, apiURL);
  var response = await http.get(url);

  return response;
}

void signIn(BuildContext context, String nis) async {
  final SharedPreferences prefs = await _prefs;
  final response = await postData('/api/login', {
    'nis': nis
  });

  if(!context.mounted) return;
  if(response.statusCode == 200){
    prefs.setInt('nis', json.decode(response.body)['data']['nis']);
    prefs.setString('nama', json.decode(response.body)['data']['nama_siswa']);
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
  // final url = Uri.http(baseUrl, '/api/logout');
  // var response = await http.post(url, body: {
  //   'token': prefs.getString('token')
  // }, headers: {
  //   'Content-Type': 'application/x-www-form-urlencoded'
  // });

  final response = await postData('/api/logout', {
    'token': prefs.getString('token')
  });

  if(response.statusCode == 200){
    if(!context.mounted) return;
    prefs.clear();
    prefs.setBool('isAuthenticated', false);
    context.goNamed('signin');
  }
}

Future<http.Response> shop() async {
  final response = await getData('/api/shop');
  return response;
}

Future<http.Response> products() async {
  final response = await getData('/api/products');
  return response;
}

Future<http.Response> shopById(String? shopId) async {
  final response = await getData('/api/shop/$shopId');
  return response;
}

Future<http.Response> search(String query) async {
  final response = await postData('/api/search', {
    'query': query
  });
  return response;
}

Future<http.Response> addToCart(String idProduk, int qty) async {
  final SharedPreferences prefs = await _prefs;
  final response = await postData('/api/add-to-cart', {
    'id': idProduk,
    'qty': qty.toString(),
    'token': prefs.getString('token')
  });
  return response;
}

Future<http.Response> carts() async {
  final SharedPreferences prefs = await _prefs;
  final token = prefs.getString('token');
  final response = await postData('/api/cart', {
    'token': token
  });
  return response;
}

Future<http.Response> deleteCart(int idKeranjang) async {
  final SharedPreferences prefs = await _prefs;
  final token = prefs.getString('token');
  final response = await postData('/api/cart/delete', {
    'id': idKeranjang.toString(),
    'token': token
  });
  return response;
}

Future<http.Response> updateCart(int idKeranjang, int qty) async {
  final SharedPreferences prefs = await _prefs;
  final token = prefs.getString('token');
  final response = await postData('/api/cart/update', {
    'id': idKeranjang.toString(),
    'qty': qty.toString(),
    'token': token
  });
  return response;
}