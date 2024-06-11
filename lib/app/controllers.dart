import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:espw/widgets/bottom_snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// initializing global variable
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
const String baseUrl = 'espw.my.id';
const String apiBaseUrl = 'api.espw.my.id';

void login(BuildContext context, String nis) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(apiBaseUrl, '/api/v2/user/auth/login');
  final response = await http.post(url, body: json.encode({
    'nis': int.parse(nis)
  }), headers: {
    'Content-Type': 'application/json',
  });

  if(!context.mounted) return;
  if(response.statusCode == 200){
    context.pop();
    prefs.setInt('nis', json.decode(response.body)['data']['siswa']['nis']);
    prefs.setString('nama', json.decode(response.body)['data']['siswa']['nama']);
    prefs.setString('kelas', json.decode(response.body)['data']['kelas']['kelas']);
    prefs.setString('telepon', json.decode(response.body)['data']['siswa']['telepon']);
    prefs.setString('foto_profil', json.decode(response.body)['data']['siswa']['foto_profil']);
    context.goNamed('verify', queryParameters: {
      'token': json.decode(response.body)['token'],
    });
  } else {
    context.goNamed('login-failed');
  }
}

void logout(BuildContext context) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(apiBaseUrl, '/api/v2/user/auth/logout');
  final response = await http.post(url, headers: {
    'Authorization': 'Bearer ${prefs.getString('token')}'
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
  final url = Uri.https(apiBaseUrl, '/api/v2/user/update/telepon/${prefs.getInt('nis')}');
  final response = await http.patch(url, body: json.encode({
    'telepon': telepon
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
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
  final url = Uri.https(apiBaseUrl, '/api/v2/user/update/password/${prefs.getInt('nis')}');
  final response = await http.patch(url, body: json.encode({
    'password': newPassword
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  if(!context.mounted) return;
  if(response.statusCode == 200){
    createNotification(
      type: 'Informasi',
      title: 'Kata sandi anda diubah',
      description: 'Kata sandi anda telah dirubah. Jika anda tidak merasa merubah kata sandi anda, segera ubah kata sandi anda kembali!'
    );
    logout(context);
    successSnackBar(
      context: context,
      content: 'Password berhasil diubah!'
    );
  }
}

Future<http.Response> getAddress() async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(apiBaseUrl, '/api/v2/user/alamat/${prefs.getInt('nis')}');
  final response = await http.get(url, headers: {
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  return response;
}

void addAddress({required BuildContext context, required String address}) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(apiBaseUrl, '/api/v2/user/alamat/add/${prefs.getInt('nis')}');
  final response = await http.post(url, body: json.encode({
    'address': address
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  if(!context.mounted) return;
  if(response.statusCode == 200){
    context.pop();
    context.goNamed('address');
    successSnackBar(
      context: context,
      content: 'Alamat berhasil disimpan!'
    );
  }
}

void deleteAddress({required BuildContext context, required int idAddress}) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(apiBaseUrl, '/api/v2/user/alamat/delete/${prefs.getInt('nis')}');
  final response = await http.post(url, body: json.encode({
    'id_address': idAddress
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
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
  final url = Uri.https(apiBaseUrl, '/api/v2/user/update/profile-picture/${prefs.getInt('nis')}');
  final request = http.MultipartRequest('POST', url);
  request.headers.addAll({
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });
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
  final url = Uri.https(apiBaseUrl, '/api/v2/kelas');
  final response = await http.get(url);

  return response;
}

Future<http.Response> shop() async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(apiBaseUrl, '/api/v2/toko');
  final response = await http.get(url, headers: {
    'Authorization': 'Bearer ${prefs.getString('token')}'
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
  final url = Uri.https(apiBaseUrl, '/api/v2/toko/create');
  final request = http.MultipartRequest('POST', url);
  request.headers.addAll({
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });
  request.fields['nama_toko'] = namaToko;
  request.fields['id_kelas'] = kelas;
  request.fields['deskripsi_toko'] = deskripsiToko;
  request.files.add(http.MultipartFile.fromBytes('banner_toko', File(bannerToko!.path).readAsBytesSync(), filename: bannerToko.path));

  final response = await request.send();

  if(response.statusCode == 200){
    final data = json.decode(await response.stream.bytesToString());
    if(!context.mounted) return;
    context.pop();
    context.goNamed('add-product-oncreate', queryParameters: {'id_toko': data['toko'].first['id_toko'], 'isRedirect': 'false'});
    successSnackBar(
      context: context,
      content: 'Toko berhasil dibuat!'
    );
  }
}

void updateShopBanner({required BuildContext context, required String idToko, required File bannerToko, required String oldImage}) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(apiBaseUrl, '/api/v2/toko/update/banner/$idToko');
  final request = http.MultipartRequest('POST', url);
  request.headers.addAll({
    'Authorization': 'Bearer ${prefs.getString('token')}'
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
  final url = Uri.https(apiBaseUrl, '/api/v2/toko/update');
  final response = await http.patch(url, body: json.encode({
    'id_toko': idToko,
    'deskripsi_toko': deskripsiToko
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
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
  final url = Uri.https(apiBaseUrl, '/api/v2/toko/delete');
  final response = await http.post(url, body: json.encode({
    'id_toko': idToko
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
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
  final url = Uri.https(apiBaseUrl, '/api/v2/toko/update/jadwal');
  final response = await http.post(url, body: json.encode({
    'id_toko': idToko,
    'is_open': isOpen,
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
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
  final url = Uri.https(apiBaseUrl, '/api/v2/kelompok/all');
  final response = await http.post(url, body: json.encode({
    'id_toko': idToko
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  return response;
}

void joinKelompok({required BuildContext context, required String kodeUnik}) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(apiBaseUrl, '/api/v2/kelompok/join');
  final response = await http.post(url, body: json.encode({
    'kode_unik': kodeUnik
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
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
  final url = Uri.https(apiBaseUrl, '/api/v2/kelompok/delete');
  final response = await http.post(url, body: json.encode({
    'id_toko': idToko
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
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
  final url = Uri.https(apiBaseUrl, '/api/v2/kelompok');
  final response = await http.get(url, headers: {
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  return response;
}

Future<http.Response> products() async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(apiBaseUrl, '/api/v2/produk');
  final response = await http.get(url, headers: {
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  return response;
}

Future<http.Response> productById(idProduk) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(apiBaseUrl, '/api/v2/produk/$idProduk');
  final response = await http.get(url, headers: {
    'Authorization': 'Bearer ${prefs.getString('token')}'
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
  final url = Uri.https(apiBaseUrl, '/api/v2/produk/add');
  final request = http.MultipartRequest('POST', url);
  request.headers.addAll({
    'Authorization': 'Bearer ${prefs.getString('token')}'
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
    context.pop();
    context.goNamed('shop-dash', queryParameters: {'id_toko': idToko, 'isRedirect': 'false'});
    successSnackBar(
      context: context,
      content: 'Produk berhasil ditambahkan!'
    );
  }
}

void updateFotoProduk({required BuildContext context, required String idProduk, required File fotoProduk, required String oldImage, required String idToko}) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(apiBaseUrl, '/api/v2/produk/update/foto/$idProduk');
  final request = http.MultipartRequest('POST', url);
  request.headers.addAll({
    'Authorization': 'Bearer ${prefs.getString('token')}'
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
  final url = Uri.https(apiBaseUrl, '/api/v2/produk/update');
  final response = await http.patch(url, body: json.encode({
    'id_produk': idProduk,
    'nama_produk': namaProduk,
    'harga': harga,
    'stok': stok,
    'deskripsi_produk': deskripsiProduk,
    'detail_produk': detailProduk
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
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
  final url = Uri.https(apiBaseUrl, '/api/v2/produk/delete');
  final response = await http.post(url, body: json.encode({
    'id_produk': idProduk
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
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
  final url = Uri.https(apiBaseUrl, '/api/v2/toko/$shopId');
  final response = await http.get(url, headers: {
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  return response;
}

Future<http.Response> search(String query) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(apiBaseUrl, '/api/v2/search');
  final response = await http.post(url, body: json.encode({
    'query': query
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  return response;
}

Future<http.Response> addToCart({required String idProduk, required int qty, String? catatan}) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(apiBaseUrl, '/api/v2/user/keranjang/add');
  final response = await http.post(url, body: json.encode({
    'id': idProduk,
    'qty': qty.toString(),
    'catatan': catatan
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  return response;
}

Future<http.Response> carts() async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(apiBaseUrl, '/api/v2/user/keranjang');
  final response = await http.get(url, headers: {
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  return response;
}

Future<http.Response> deleteCart(int idKeranjang) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(apiBaseUrl, '/api/v2/user/keranjang/delete');
  final response = await http.delete(url, body: json.encode({
    'id': idKeranjang.toString(),
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  return response;
}

Future<http.Response> updateCart(int idKeranjang, int qty) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(apiBaseUrl, '/api/v2/user/keranjang/update');
  final response = await http.post(url, body: json.encode({
    'id': idKeranjang.toString(),
    'qty': qty.toString(),
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  return response;
}

Future<http.Response> getFavorite() async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(apiBaseUrl, '/api/v2/user/favorit/${prefs.getInt('nis')}');
  final response = await http.get(url, headers: {
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  return response;
}

void addToFavorite({required BuildContext context, required String idToko}) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(apiBaseUrl, '/api/v2/user/favorit/add/${prefs.getInt('nis')}');
  final response = await http.post(url, body: json.encode({
    'id_toko': idToko,
  }),headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  if(!context.mounted) return;
  if(response.statusCode == 200){
    successSnackBar(
      context: context,
      content: 'Anda menyukai toko ini'
    );
  }
}

void deleteFromFavorite({required BuildContext context, required String idToko}) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(apiBaseUrl, '/api/v2/user/favorit/delete/${prefs.getInt('nis')}');
  final response = await http.post(url, body: json.encode({
    'id_toko': idToko,
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  if(!context.mounted) return;
  if(response.statusCode == 200){
    successSnackBar(
      context: context,
      content: 'Anda batal menyukai toko ini'
    );
  }
}

Future<http.Response> orders({required String statusPesanan}) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(apiBaseUrl, '/api/v2/order');
  final response = http.post(url, body: json.encode({
    'status': statusPesanan
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  return response;
}

Future<http.Response> ordersByShop({required String idToko, required String statusPesanan}) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(apiBaseUrl, '/api/v2/toko/orders');
  final response = http.post(url, body: json.encode({
    'id_toko': idToko,
    'status': statusPesanan
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  return response;
}

Future<http.Response> createOrder({required String idProduk, required int jumlah, required double totalHarga, String? catatan, required String alamat}) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(apiBaseUrl, '/api/v2/order/new');
  final response = await http.post(url, body: json.encode({
    'id_produk': idProduk,
    'jumlah': jumlah,
    'total_harga': totalHarga,
    'catatan': catatan,
    'alamat': alamat
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  return response;
}

void updateStatusPesanan({required BuildContext context, required String idTransaksi, required String status, String? idToko}) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(apiBaseUrl, '/api/v2/order/update');
  final response = await http.patch(url, body: json.encode({
    'id_transaksi': idTransaksi,
    'status': status,
  }),headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  if(!context.mounted) return;
  if(response.statusCode == 200){
    if(idToko != null){
      if(status == 'Diproses'){
        context.goNamed('order-status', queryParameters: {'id_toko': idToko, 'initial_index': '1'});
        successSnackBar(
          context: context,
          content: 'Pesanan dikonfirmasi'
        );
      } else if (status == 'Selesai'){
        context.goNamed('order-status', queryParameters: {'id_toko': idToko, 'initial_index': '2'});
        successSnackBar(
          context: context,
          content: 'Pesanan selesai'
        );
      }
    } else {
      context.goNamed('order', queryParameters: {'initial_index': '1'});
      successSnackBar(
        context: context,
        content: 'Pesanan selesai'
      );
    }
  }
}

Future<http.Response> getRate() async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(apiBaseUrl, '/api/v2/user/rate/${prefs.getInt('nis')}');
  final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  return response;
}

Future<http.Response> getRateByShop({required String idToko}) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(apiBaseUrl, '/api/v2/toko/rate');
  final response = await http.post(url, body: json.encode({
    'id_toko': idToko
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  return response;
}

Future<http.Response> getRateByShopLimited({required String idToko}) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(apiBaseUrl, '/api/v2/toko/rate-limited');
  final response = await http.post(url, body: json.encode({
    'id_toko': idToko
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  return response;
}

void rateProduct({required BuildContext context, required String idProduk, required String idTransaksi, required String ulasan, required String rate, required String idToko}) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(apiBaseUrl, '/api/v2/user/rate/add/${prefs.getInt('nis')}');
  final response = await http.post(url, body: json.encode({
    'id_produk': idProduk,
    'id_transaksi': idTransaksi,
    'ulasan': ulasan,
    'rating': rate,
    'id_toko': idToko
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  if(!context.mounted) return;
  if(response.statusCode == 200){
    context.goNamed('home');
    successSnackBar(
      context: context,
      content: 'Berhasil menambahkan ulasan'
    );
  }
}

Future<http.Response> getNotification({required String type}) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(apiBaseUrl, '/api/v2/user/notifikasi');
  final response = await http.post(url, body: json.encode({
    'type': type,
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  return response;
}

void createNotification({required String type, required String title, required String description}) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(apiBaseUrl, '/api/v2/user/notifikasi/add');
  await http.post(url, body: json.encode({
    'type': type,
    'title': title,
    'description': description
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });
}

Future<http.Response> getTokoNotification({required String type}) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(apiBaseUrl, '/api/v2/toko/notifikasi');
  final response = await http.post(url, body: json.encode({
    'type': type,
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  return response;
}

void createTokoNotification({required String type, required String title, required String description, required String idToko}) async {
  final SharedPreferences prefs = await _prefs;
  final url = Uri.https(apiBaseUrl, '/api/v2/toko/notifikasi/add');
  await http.post(url, body: json.encode({
    'id_toko': idToko,
    'type': type,
    'title': title,
    'description': description
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });
}