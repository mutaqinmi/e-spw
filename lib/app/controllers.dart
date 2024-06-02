import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:espw/widgets/bottom_snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// initializing global variable
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
// const String baseUrl = 'lucky-premium-redfish.ngrok-free.app';
const String baseUrl = 'espw.my.id';

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
    prefs.setString('telepon', json.decode(response.body)['data']['siswa']['telepon']);
    prefs.setString('foto_profil', json.decode(response.body)['data']['siswa']['foto_profil']);
    context.pushNamed('verify', queryParameters: {
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

void updateTelepon({required BuildContext context, required String telepon}) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(baseUrl, '/api/user/${prefs.getInt('nis')}/update-telepon');
  final response = await http.patch(url, body: json.encode({
    'telepon': telepon
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.get('token')}'
  });

  if(!context.mounted) return;
  if(response.statusCode == 200){
    prefs.setString('telepon', telepon);
    context.goNamed('home');
    successSnackBar(
      context: context,
      content: 'Nomor telepon berhasil diubah!'
    );
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
    logout(context);
    successSnackBar(
      context: context,
      content: 'Password berhasil diubah!'
    );
  }
}

Future<http.Response> getAddress() async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(baseUrl, '/api/user/${prefs.getInt('nis')}/address');
  final response = await http.get(url, headers: {
    'Authorization': 'Bearer ${prefs.get('token')}'
  });

  return response;
}

void addAddress({required BuildContext context, required String address}) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(baseUrl, '/api/user/${prefs.getInt('nis')}/add-address');
  final response = await http.post(url, body: json.encode({
    'address': address
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.get('token')}'
  });

  if(!context.mounted) return;
  if(response.statusCode == 200){
    context.goNamed('address');
    successSnackBar(
      context: context,
      content: 'Alamat berhasil disimpan!'
    );
  }
}

void deleteAddress({required BuildContext context, required int idAddress}) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(baseUrl, '/api/user/${prefs.getInt('nis')}/delete-address');
  final response = await http.post(url, body: json.encode({
    'id_address': idAddress
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.get('token')}'
  });

  if(!context.mounted) return;
  if(response.statusCode == 200){
    context.goNamed('home');
    successSnackBar(
      context: context,
      content: 'Alamat dihapus!'
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
    context.goNamed('home');
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
  request.files.add(http.MultipartFile.fromBytes('banner_toko', File(bannerToko!.path).readAsBytesSync(), filename: bannerToko.path));

  final response = await request.send();

  if(response.statusCode == 200){
    final data = json.decode(await response.stream.bytesToString());
    if(!context.mounted) return;
    context.goNamed('add-product-oncreate', queryParameters: {'id_toko': data['toko'].first['id_toko'], 'isRedirect': 'false'});
    successSnackBar(
      context: context,
      content: 'Toko berhasil dibuat!'
    );
  }
}

void updateShopBanner({required BuildContext context, required String idToko, required File bannerToko, required String oldImage}) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(baseUrl, '/api/shop/$idToko/update-profile-picture');
  final request = http.MultipartRequest('POST', url);
  request.headers.addAll({
    'Authorization': 'Bearer ${prefs.get('token')}'
  });
  request.fields['old_image'] = oldImage;
  request.files.add(http.MultipartFile.fromBytes('banner_toko', File(bannerToko.path).readAsBytesSync(), filename: bannerToko.path));
  final response = await request.send();
  if(response.statusCode == 200){
    if(!context.mounted) return;
    context.goNamed('shop-dash', queryParameters: {'id_toko': idToko});
    successSnackBar(
      context: context,
      content: 'Foto profil berhasil diubah!'
    );
  }
}

void updateShop({required BuildContext context, required String deskripsiToko, required String idToko}) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(baseUrl, '/api/shop/update');
  final response = await http.patch(url, body: json.encode({
    'id_toko': idToko,
    'deskripsi_toko': deskripsiToko
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.get('token')}'
  });

  if(!context.mounted) return;
  if(response.statusCode == 200){
    context.goNamed('shop-dash', queryParameters: {'id_toko': idToko});
    successSnackBar(
      context: context,
      content: 'Informasi toko berhasil diubah!'
    );
  }
}

void deleteShop({required BuildContext context, required String idToko}) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(baseUrl, '/api/shop/delete');
  final response = await http.post(url, body: json.encode({
    'id_toko': idToko
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.get('token')}'
  });

  if(!context.mounted) return;
  if(response.statusCode == 200){
    context.goNamed('home');
    successSnackBar(
      context: context,
      content: 'Toko dihapus!'
    );
  }
}

void updateJadwal({required BuildContext context, required String idToko, required bool isOpen}) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(baseUrl, '/api/shop/update-jadwal');
  final response = await http.post(url, body: json.encode({
    'id_toko': idToko,
    'is_open': isOpen,
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.get('token')}'
  });

  if(!context.mounted) return;
  if(response.statusCode == 200){
    successSnackBar(
      context: context,
      content: 'Jadwal toko berhasil diubah'
    );
  }
}

Future<http.Response> getAllDataKelompok(String idToko) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(baseUrl, '/api/kelompok/all');
  final response = await http.post(url, body: json.encode({
    'id_toko': idToko
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.get('token')}'
  });

  return response;
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
      content: json.decode(response.body)['message']
    );
  }
}

void removeFromKelompok({required BuildContext context, required String idToko}) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(baseUrl, '/api/kelompok/remove');
  final response = await http.post(url, body: json.encode({
    'id_toko': idToko
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.get('token')}'
  });

  if(!context.mounted) return;
  if(response.statusCode == 200){
    context.goNamed('home');
    successSnackBar(
      context: context,
      content: 'Anda keluar dari kelompok'
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

Future<http.Response> productById(idProduk) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(baseUrl, '/api/products/$idProduk');
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
    context.goNamed('shop-dash', queryParameters: {'id_toko': idToko, 'isRedirect': 'false'});
    successSnackBar(
      context: context,
      content: 'Produk berhasil ditambahkan!'
    );
  }
}

void updateFotoProduk({required BuildContext context, required String idProduk, required File fotoProduk, required String oldImage, required String idToko}) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(baseUrl, '/api/products/$idProduk/update-profile-picture');
  final request = http.MultipartRequest('POST', url);
  request.headers.addAll({
    'Authorization': 'Bearer ${prefs.get('token')}'
  });
  request.fields['old_image'] = oldImage;
  request.files.add(http.MultipartFile.fromBytes('foto_produk', File(fotoProduk.path).readAsBytesSync(), filename: fotoProduk.path));
  final response = await request.send();
  if(response.statusCode == 200){
    if(!context.mounted) return;
    context.goNamed('shop-dash', queryParameters: {'id_toko': idToko});
    successSnackBar(
      context: context,
      content: 'Foto produk berhasil diubah!'
    );
  }
}

void updateProduk({required BuildContext context, required String namaProduk, required String harga, required String stok, required String deskripsiProduk, required String detailProduk, required String idProduk, required String idToko}) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(baseUrl, '/api/products/update');
  final response = await http.patch(url, body: json.encode({
    'id_produk': idProduk,
    'nama_produk': namaProduk,
    'harga': harga,
    'stok': stok,
    'deskripsi_produk': deskripsiProduk,
    'detail_produk': detailProduk
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.get('token')}'
  });

  if(!context.mounted) return;
  if(response.statusCode == 200){
    context.goNamed('shop-dash', queryParameters: {'id_toko': idToko});
    successSnackBar(
      context: context,
      content: 'Informasi produk berhasil diubah!'
    );
  }
}

void removeProduct({required BuildContext context, required String idProduk}) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(baseUrl, '/api/products/delete');
  final response = await http.post(url, body: json.encode({
    'id_produk': idProduk
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.get('token')}'
  });

  if(!context.mounted) return;
  if(response.statusCode == 200){
    context.goNamed('shop-dash', queryParameters: {'id_toko': prefs.getInt('id_toko').toString()});
    successSnackBar(
      context: context,
      content: 'Produk berhasil dihapus!'
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