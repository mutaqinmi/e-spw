import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:espw/widgets/bottom_snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// initializing global variable
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
const String baseUrl = 'lucky-premium-redfish.ngrok-free.app';

void signIn(BuildContext context, String nis) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(baseUrl, '/api/login');
  final response = await http.post(url, body: json.encode({
    'nis': int.parse(nis)
  }), headers: {
    'Content-Type': 'application/json',
  });

  if(!context.mounted) return;
  if(response.statusCode == 200){
    prefs.setInt('nis', json.decode(response.body)['data']['siswa']['nis']);
    prefs.setString('nama', json.decode(response.body)['data']['siswa']['nama']);
    prefs.setString('kelas', json.decode(response.body)['data']['kelas']['kelas']);
    prefs.setString('password', json.decode(response.body)['data']['siswa']['password']);
    prefs.setString('telepon', json.decode(response.body)['data']['siswa']['telepon']);
    prefs.setString('foto_profil', json.decode(response.body)['data']['siswa']['foto_profil']);
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
  final url = Uri.https(baseUrl, '/api/logout');
  final response = await http.post(url, headers: {
    'Authorization': 'Bearer ${prefs.get('token')}'
  });

  if(response.statusCode == 200){
    if(!context.mounted) return;
    prefs.clear();
    prefs.setBool('isAuthenticated', false);
    context.goNamed('signin');
  }
}

Future<http.Response> kelas() async {
  final url = Uri.https(baseUrl, '/api/kelas');
  final response = await http.get(url);

  return response;
}

Future<http.Response> shop() async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(baseUrl, '/api/shop');
  final response = await http.get(url, headers: {
    'Authorization': 'Bearer ${prefs.get('token')}'
  });

  return response;
}

void createShop(BuildContext context, String namaToko, String kelas, String deskripsiToko, String kategoriToko) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(baseUrl, '/api/shop/create');
  final response = await http.post(url, body: json.encode({
    "nama_toko": namaToko,
    "id_kelas": kelas,
    "deskripsi_toko": deskripsiToko,
    "kategori_toko": kategoriToko
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.get('token')}'
  });

  if(!context.mounted) return;
  if(response.statusCode == 200){
    context.goNamed('login-shop');
    successSnackBar(
      context: context,
      content: 'Toko berhasil dibuat!'
    );
  }
}

Future<http.Response> kelompok() async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(baseUrl, '/api/kelompok');
  final response = await http.get(url, headers: {
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  return response;
}

Future<http.Response> products() async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(baseUrl, '/api/products');
  final response = await http.get(url, headers: {
    'Authorization': 'Bearer ${prefs.get('token')}'
  });

  return response;
}

Future<http.Response> shopById(String? shopId) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(baseUrl, '/api/shop/$shopId');
  final response = await http.get(url, headers: {
    'Authorization': 'Bearer ${prefs.get('token')}'
  });

  return response;
}

Future<http.Response> search(String query) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(baseUrl, '/api/search');
  final response = await http.post(url, body: json.encode({
    'query': query
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.get('token')}'
  });

  return response;
}

Future<http.Response> addToCart(String idProduk, int qty) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(baseUrl, '/api/add-to-cart');
  final response = await http.post(url, body: json.encode({
    'id': idProduk,
    'qty': qty.toString(),
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.get('token')}'
  });

  return response;
}

Future<http.Response> carts() async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(baseUrl, '/api/cart');
  final response = await http.get(url, headers: {
    'Authorization': 'Bearer ${prefs.get('token')}'
  });

  return response;
}

Future<http.Response> deleteCart(int idKeranjang) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(baseUrl, '/api/cart/delete');
  final response = await http.delete(url, body: json.encode({
    'id': idKeranjang.toString(),
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.get('token')}'
  });

  return response;
}

Future<http.Response> updateCart(int idKeranjang, int qty) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(baseUrl, '/api/cart/update');
  final response = await http.post(url, body: json.encode({
    'id': idKeranjang.toString(),
    'qty': qty.toString(),
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.get('token')}'
  });

  return response;
}