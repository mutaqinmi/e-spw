import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:espw/widgets/bottom_snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// initializing global variable
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
const String baseUrl = 'lucky-premium-redfish.ngrok-free.app';
// const String baseUrl = 'espw.my.id';

void signIn(BuildContext context, String nis) async {
  final url = Uri.https(baseUrl, '/api/login');
  final response = await http.post(url, body: json.encode({
    'nis': int.parse(nis)
  }), headers: {
    'Content-Type': 'application/json',
  });

  if(!context.mounted) return;
  if(response.statusCode == 200){
    context.pushNamed('verify', queryParameters: {
      'nis': json.decode(response.body)['data']['siswa']['nis'].toString(),
      'nama': json.decode(response.body)['data']['siswa']['nama'],
      'kelas': json.decode(response.body)['data']['kelas']['kelas'],
      'password': json.decode(response.body)['data']['siswa']['password'],
      'telepon': json.decode(response.body)['data']['siswa']['telepon'],
      'foto_profil': json.decode(response.body)['data']['siswa']['foto_profil'],
      'token': json.decode(response.body)['token'],
    });
  } else {
    context.pushNamed('login-failed');
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

void changePassword(BuildContext context, String newPassword) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(baseUrl, '/api/user/${prefs.getInt('nis')}/change-password');
  final response = await http.patch(url, body: json.encode({
    'password': newPassword
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.get('token')}'
  });

  if(!context.mounted) return;
  if(response.statusCode == 200){
    prefs.setString('password', newPassword);
    context.goNamed('profile', queryParameters: {'user_id': prefs.getInt('nis').toString()});
    successSnackBar(
      context: context,
      content: 'Password berhasil diubah!'
    );
  }
}

void updateProfilePicture({required BuildContext context, required File profilePicture}) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(baseUrl, '/api/user/${prefs.getInt('nis')}/update-profile-picture');
  final request = http.MultipartRequest('POST', url);
  request.headers.addAll({
    'Authorization': 'Bearer ${prefs.get('token')}'
  });
  request.fields['old_image'] = prefs.getString('foto_profil') ?? '';
  request.files.add(http.MultipartFile.fromBytes('profile_picture', File(profilePicture.path).readAsBytesSync(), filename: profilePicture.path));
  final response = await request.send();
  if(response.statusCode == 200){
    final data = json.decode(await response.stream.bytesToString());
    prefs.setString('foto_profil', data['siswa'].first['foto_profil']);
    if(!context.mounted) return;
    context.goNamed('profile', queryParameters: {'user_id': prefs.getInt('nis').toString()});
    successSnackBar(
      context: context,
      content: 'Foto profil berhasil diubah!'
    );
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

void createShop(
    {required BuildContext context,
    required String namaToko,
    required String kelas,
    required String deskripsiToko,
    required String kategoriToko,
    File? bannerToko}) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(baseUrl, '/api/shop/create');
  final request = http.MultipartRequest('POST', url);
  request.headers.addAll({
    'Authorization': 'Bearer ${prefs.get('token')}'
  });
  request.fields['nama_toko'] = namaToko;
  request.fields['id_kelas'] = kelas;
  request.fields['deskripsi_toko'] = deskripsiToko;
  request.fields['kategori_toko'] = kategoriToko;
  request.files.add(http.MultipartFile.fromBytes('banner_toko', File(bannerToko!.path).readAsBytesSync(), filename: bannerToko.path));

  final response = await request.send();

  if(response.statusCode == 200){
    final data = json.decode(await response.stream.bytesToString());
    if(!context.mounted) return;
    context.pushNamed('add-product-oncreate', queryParameters: {'id_toko': data['toko'].first['id_toko'], 'isRedirect': 'false'});
  }
}

void joinKelompok({required BuildContext context, required String kodeUnik}) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(baseUrl, '/api/kelompok/join');
  final response = await http.post(url, body: json.encode({
    'kode_unik': kodeUnik
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.get('token')}'
  });

  if(!context.mounted) return;
  if(response.statusCode == 200){
    context.goNamed('shop-dash', queryParameters: {'id_toko': json.decode(response.body)['id_toko']});
    successSnackBar(
      context: context,
      content: 'Anda bergabung ke ${json.decode(response.body)['nama_toko']}'
    );
  } else {
    alertSnackBar(
      context: context,
      content: 'Anda sudah bergabung'
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

void addProduct(
    {required BuildContext context,
    required String namaProduk,
    required String harga,
    required String stok,
    String? deskripsiProduk,
    required String detailProduk,
    required File? fotoProduk,
    required String idToko,
    required bool isCreate}) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(baseUrl, '/api/products/add');
  final request = http.MultipartRequest('POST', url);
  request.headers.addAll({
    'Authorization': 'Bearer ${prefs.get('token')}'
  });
  request.fields['nama_produk'] = namaProduk;
  request.fields['harga'] = harga;
  request.fields['stok'] = stok;
  request.fields['deskripsi_produk'] = deskripsiProduk!;
  request.fields['detail_produk'] = detailProduk;
  request.fields['id_toko'] = idToko;
  request.files.add(http.MultipartFile.fromBytes('foto_produk', File(fotoProduk!.path).readAsBytesSync(), filename: fotoProduk.path));

  final response = await request.send();

  if(response.statusCode == 200){
    if(!context.mounted) return;
    if(!isCreate){
      context.goNamed('shop-dash', queryParameters: {'id_toko': idToko, 'isRedirect': 'false'});
      successSnackBar(
        context: context,
        content: 'Produk berhasil ditambahkan!'
      );

      return;
    }

    context.goNamed('login-shop');
    successSnackBar(
      context: context,
      content: 'Toko berhasil dibuat!'
    );
  }
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