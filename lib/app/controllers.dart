import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:espw/widgets/bottom_snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// initializing global variable
const String baseUrl = 'espw.my.id';
const String apiBaseUrl = 'api.espw.my.id';

void getDataSiswa({required BuildContext context, required String nis}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final url = Uri.https(apiBaseUrl, '/v3/user');
  final response = await http.post(url, body: json.encode({
    'nis': nis
  }), headers: {
    'Content-Type': 'application/json',
  });

  if(!context.mounted) return;
  context.pop();
  if(response.statusCode == 200){
    if(json.decode(response.body)['isDefaultPassword']){
      prefs.setBool('isDefaultPassword', true);
      return signin(
        context: context,
        nis: nis,
        password: '',
        token: json.decode(response.body)['token']
      );
    }

    return context.goNamed('verify', queryParameters: {
      'token': json.decode(response.body)['token'],
    });
  }

  return showModalBottomSheet(
    context: context,
    builder: (BuildContext context) => Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Image.asset(
                  'assets/image/oops.png',
                  width: 250
                ),
                const Gap(30),
                const Text(
                  'NIS tidak ditemukan!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600
                  ),
                ),
                const Text(
                  'Cek kembali NIS yang anda masukkan dan pastikan NIS sudah sesuai.',
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton(
              onPressed: () => context.pop(),
              child: const Text('Oke'),
            ),
          )
        ],
      )
    )
  );
}

void signin({required BuildContext context, required String nis, required String password, required String token}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  final url = Uri.https(apiBaseUrl, '/v3/user/auth/signin');
  final response = await http.post(url, body: json.encode({
    'nis': nis,
    'password': password,
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  });

  if(response.statusCode == 200){
    prefs.setBool('isAuthenticated', true);
    prefs.setString('token', token);
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    addNotifikasi(
      type: 'Informasi',
      title: 'Ada aktivitas login di perangkat baru',
      description: 'Akun anda telah login melalui perangkat ${androidInfo.model}. Jika ini bukan anda, segera amankan akun anda!'
    );

    if(!context.mounted) return;
    successSnackBar(
      context: context,
      content: 'Login berhasil!'
    );

    return context.goNamed('home');
  } else if (response.statusCode == 401){
    if(!context.mounted) return;
    alertSnackBar(
      context: context,
      content: json.decode(response.body)['message']
    );
  }
}

void signout({required BuildContext context}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final url = Uri.https(apiBaseUrl, '/v3/user/auth/signout');
  final response = await http.post(url, headers: {
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  if(!context.mounted) return;
  if(response.statusCode == 200){
    prefs.clear();
    prefs.setBool('isAuthenticated', false);
    return context.goNamed('signin');
  }
}

void verifyPassword({required BuildContext context, required String password}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final url = Uri.https(apiBaseUrl, '/v3/user/auth/verify');
  final response = await http.post(url, body: json.encode({
    'password': password
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  if(!context.mounted) return;
  if(response.statusCode == 401){
    prefs.clear();
    prefs.setBool('isAuthenticated', false);
    context.goNamed('signin');
  }
  if(response.statusCode == 200){
    successSnackBar(
      context: context,
      content: 'Autentikasi berhasil!'
    );
  }
}

void updateTelepon({required BuildContext context, required String telepon}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final url = Uri.https(apiBaseUrl, '/v3/user/update/telepon');
  final response = await http.patch(url, body: json.encode({
    'telepon': telepon
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  if(!context.mounted) return;
  if(response.statusCode == 401){
    prefs.clear();
    prefs.setBool('isAuthenticated', false);
    context.goNamed('signin');
  }
  if(response.statusCode == 200){
    addNotifikasi(
      type: 'Informasi',
      title: 'Nomor telepon anda diubah!',
      description: 'Nomor telepon anda telah diubah. Jika anda tidak merasa merubah nomor telepon anda, segera amankan akun anda!'
    );
    successSnackBar(
      context: context,
      content: 'Nomor telepon berhasil diubah!'
    );
    return context.goNamed('home');
  }
}

void updatePassword({required BuildContext context, required String password}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final url = Uri.https(apiBaseUrl, '/v3/user/update/password');
  final response = await http.patch(url, body: json.encode({
    'password': password
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  if(!context.mounted) return;
  if(response.statusCode == 401){
    prefs.clear();
    prefs.setBool('isAuthenticated', false);
    context.goNamed('signin');
  }
  if(response.statusCode == 200){
    addNotifikasi(
      type: 'Informasi',
      title: 'Kata sandi anda diubah',
      description: 'Kata sandi anda telah diubah. Jika anda tidak merasa merubah kata sandi anda, segera ubah kata sandi anda kembali!'
    );
    successSnackBar(
      context: context,
      content: 'Password berhasil diubah!'
    );
    return signout(
      context: context
    );
  }
}

Future<http.Response?> getAlamat({required BuildContext context}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final url = Uri.https(apiBaseUrl, '/v3/user/alamat');
  final response = await http.get(url, headers: {
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  if(!context.mounted) return null;
  if(response.statusCode == 401){
    prefs.clear();
    prefs.setBool('isAuthenticated', false);
    context.goNamed('signin');
  }
  if(response.statusCode == 200){
    return response;
  }

  return null;
}

void addAlamat({required BuildContext context, required String address}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final url = Uri.https(apiBaseUrl, '/v3/user/alamat/add');
  final response = await http.post(url, body: json.encode({
    'address': address
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  if(!context.mounted) return;
  if(response.statusCode == 401){
    prefs.clear();
    prefs.setBool('isAuthenticated', false);
    context.goNamed('signin');
  }
  if(response.statusCode == 200){
    context.pop();
    addNotifikasi(
      type: 'Informasi',
      title: 'Alamat baru ditambahkan!',
      description: 'Anda telah menambahkan alamat baru. Jika anda tidak merasa menambahkan alamat baru, segera amankan akun anda!'
    );
    successSnackBar(
      context: context,
      content: 'Alamat berhasil disimpan!'
    );
    return context.goNamed('address');
  }
}

void deleteAlamat({required BuildContext context, required int idAlamat}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final url = Uri.https(apiBaseUrl, '/v3/user/alamat/delete');
  final response = await http.post(url, body: json.encode({
    'id_address': idAlamat
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  if(!context.mounted) return;
  if(response.statusCode == 401){
    prefs.clear();
    prefs.setBool('isAuthenticated', false);
    context.goNamed('signin');
  }
  if(response.statusCode == 200){
    context.goNamed('home');
    successSnackBar(
      context: context,
      content: 'Alamat dihapus!'
    );
  }
}

void updateFotoProfilSiswa({required BuildContext context, required File profilePicture}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final url = Uri.https(apiBaseUrl, '/v3/user/update/profile-picture');
  final request = http.MultipartRequest('POST', url);
  request.headers.addAll({
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });
  request.files.add(http.MultipartFile.fromBytes('profile_picture', File(profilePicture.path).readAsBytesSync(), filename: profilePicture.path));
  final response = await request.send();

  if(!context.mounted) return;
  if(response.statusCode == 401){
    prefs.clear();
    prefs.setBool('isAuthenticated', false);
    context.goNamed('signin');
  }
  if(response.statusCode == 200){
    successSnackBar(
      context: context,
      content: 'Foto profil berhasil diubah!'
    );
    return context.goNamed('home');
  }
}

Future<http.Response?> getDataKelas({required BuildContext context}) async {
  final url = Uri.https(apiBaseUrl, '/v3/kelas');
  final response = await http.get(url);

  if(!context.mounted) return null;
  if(response.statusCode == 200){
    return response;
  }

  return null;
}

Future<http.Response?> getDataToko({required BuildContext context}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final url = Uri.https(apiBaseUrl, '/v3/toko');
  final response = await http.get(url, headers: {
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  if(!context.mounted) return null;
  if(response.statusCode == 401){
    prefs.clear();
    prefs.setBool('isAuthenticated', false);
    context.goNamed('signin');
  }
  if(response.statusCode == 200){
    return response;
  }


  return null;
}

void addToko({required BuildContext context, required String namaToko, required String kelas, required String deskripsiToko, File? bannerToko}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final url = Uri.https(apiBaseUrl, '/v3/toko/create');
  final request = http.MultipartRequest('POST', url);
  request.headers.addAll({
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });
  request.fields['nama_toko'] = namaToko;
  request.fields['id_kelas'] = kelas;
  request.fields['deskripsi_toko'] = deskripsiToko;
  request.files.add(http.MultipartFile.fromBytes('banner_toko', File(bannerToko!.path).readAsBytesSync(), filename: bannerToko.path));
  final response = await request.send();

  if(response.statusCode == 401){
    if(!context.mounted) return;
    prefs.clear();
    prefs.setBool('isAuthenticated', false);
    context.goNamed('signin');
  }
  if(response.statusCode == 200){
    final data = json.decode(await response.stream.bytesToString());
    if(!context.mounted) return;
    context.pop();
    addNotifikasiToko(
      type: 'Informasi',
      title: 'Toko berhasil dibuat!',
      description: 'Selamat datang di eSPW! explore seluruh fitur aplikasi untuk membantu anda mulai berjualan.',
      idToko: data['toko'].first['id_toko']
    );
    successSnackBar(
      context: context,
      content: 'Toko berhasil dibuat!'
    );
    return context.goNamed('add-product-oncreate', queryParameters: {'id_toko': data['toko'].first['id_toko'], 'isRedirect': 'false'});
  }
}

void updateFotoProfilToko({required BuildContext context, required String idToko, required File bannerToko, required String oldImage}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final url = Uri.https(apiBaseUrl, '/v3/toko/update/banner/$idToko');
  final request = http.MultipartRequest('POST', url);
  request.headers.addAll({
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });
  request.fields['old_image'] = oldImage;
  request.files.add(http.MultipartFile.fromBytes('banner_toko', File(bannerToko.path).readAsBytesSync(), filename: bannerToko.path));
  final response = await request.send();

  if(!context.mounted) return;
  if(response.statusCode == 401){
    prefs.clear();
    prefs.setBool('isAuthenticated', false);
    context.goNamed('signin');
  }
  if(response.statusCode == 200){
    successSnackBar(
      context: context,
      content: 'Foto profil berhasil diubah!'
    );
    return context.goNamed('shop-dash', queryParameters: {'id_toko': idToko});
  }
}

void updateDeskripsiToko({required BuildContext context, required String deskripsiToko, required String idToko}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final url = Uri.https(apiBaseUrl, '/v3/toko/update');
  final response = await http.patch(url, body: json.encode({
    'id_toko': idToko,
    'deskripsi_toko': deskripsiToko
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  if(!context.mounted) return;
  if(response.statusCode == 401){
    prefs.clear();
    prefs.setBool('isAuthenticated', false);
    context.goNamed('signin');
  }
  if(response.statusCode == 200){
    addNotifikasiToko(
      type: 'Informasi',
      title: 'Deskripsi toko diubah!',
      description: 'Deskripsi toko anda telah diubah.',
      idToko: idToko
    );
    successSnackBar(
      context: context,
      content: 'Informasi toko berhasil diubah!'
    );
    return context.goNamed('shop-dash', queryParameters: {'id_toko': idToko});
  }
}

void deleteToko({required BuildContext context, required String idToko}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final url = Uri.https(apiBaseUrl, '/v3/toko/delete');
  final response = await http.post(url, body: json.encode({
    'id_toko': idToko
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  if(!context.mounted) return;
  if(response.statusCode == 401){
    prefs.clear();
    prefs.setBool('isAuthenticated', false);
    context.goNamed('signin');
  }
  if(response.statusCode == 200){
    context.goNamed('home');
    successSnackBar(
      context: context,
      content: 'Toko dihapus!'
    );
  }
}

void updateJadwalToko({required BuildContext context, required String idToko, required bool isOpen}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final url = Uri.https(apiBaseUrl, '/v3/toko/update/jadwal');
  final response = await http.post(url, body: json.encode({
    'id_toko': idToko,
    'is_open': isOpen,
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  if(!context.mounted) return;
  if(response.statusCode == 401){
    prefs.clear();
    prefs.setBool('isAuthenticated', false);
    context.goNamed('signin');
  }
  if(response.statusCode == 200){
    successSnackBar(
      context: context,
      content: 'Jadwal toko berhasil diubah'
    );
  }
}

Future<http.Response?> getDataKelompok({required BuildContext context, required String idToko}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final url = Uri.https(apiBaseUrl, '/v3/kelompok/all');
  final response = await http.post(url, body: json.encode({
    'id_toko': idToko
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  if(!context.mounted) return null;
  if(response.statusCode == 401){
    prefs.clear();
    prefs.setBool('isAuthenticated', false);
    context.goNamed('signin');
  }
  if(response.statusCode == 200){
    return response;
  }

  return null;
}

void addToKelompok({required BuildContext context, required String kodeUnik}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final url = Uri.https(apiBaseUrl, '/v3/kelompok/join');
  final response = await http.post(url, body: json.encode({
    'kode_unik': kodeUnik
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  if(!context.mounted) return;
  if(response.statusCode == 401){
    prefs.clear();
    prefs.setBool('isAuthenticated', false);
    context.goNamed('signin');
  }
  if(response.statusCode == 200){
    addNotifikasiToko(
      type: 'Informasi',
      title: 'Seorang anggota bergabung menggunakan kode toko ini!',
      description: 'Anggota baru ditambahkan.',
      idToko: json.decode(response.body)['id_toko']
    );
    successSnackBar(
      context: context,
      content: 'Anda bergabung ke ${json.decode(response.body)['nama_toko']}'
    );
    return context.goNamed('shop-dash', queryParameters: {'id_toko': json.decode(response.body)['id_toko']});
  } else {
    alertSnackBar(
      context: context,
      content: json.decode(response.body)['message']
    );
  }
}

void removeFromKelompok({required BuildContext context, required String idToko}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final url = Uri.https(apiBaseUrl, '/v3/kelompok/delete');
  final response = await http.post(url, body: json.encode({
    'id_toko': idToko
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  if(!context.mounted) return;
  if(response.statusCode == 401){
    prefs.clear();
    prefs.setBool('isAuthenticated', false);
    context.goNamed('signin');
  }
  if(response.statusCode == 200){
    addNotifikasiToko(
      type: 'Informasi',
      title: 'Seorang anggota keluar dari toko ini!',
      description: 'Salah satu anggota toko ini keluar.',
      idToko: idToko
    );
    successSnackBar(
      context: context,
      content: 'Anda keluar dari kelompok'
    );
    return context.goNamed('home');
  }
}

Future<http.Response?> getSelfKelompok({required BuildContext context}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final url = Uri.https(apiBaseUrl, '/v3/kelompok');
  final response = await http.get(url, headers: {
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  if(!context.mounted) return null;
  if(response.statusCode == 401){
    prefs.clear();
    prefs.setBool('isAuthenticated', false);
    context.goNamed('signin');
  }
  if(response.statusCode == 200){
    return response;
  }

  return null;
}

Future<http.Response?> getDataProduk({required BuildContext context}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final url = Uri.https(apiBaseUrl, '/v3/produk');
  final response = await http.get(url, headers: {
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  if(!context.mounted) return null;
  if(response.statusCode == 401){
    prefs.clear();
    prefs.setBool('isAuthenticated', false);
    context.goNamed('signin');
  }
  if(response.statusCode == 200){
    return response;
  }

  return null;
}

Future<http.Response?> getProdukByIdProduk({required BuildContext context, required String idProduk}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final url = Uri.https(apiBaseUrl, '/v3/produk/$idProduk');
  final response = await http.get(url, headers: {
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  if(!context.mounted) return null;
  if(response.statusCode == 401){
    prefs.clear();
    prefs.setBool('isAuthenticated', false);
    context.goNamed('signin');
  }
  if(response.statusCode == 200){
    return response;
  }

  return null;
}

void addProduk({required BuildContext context, required String namaProduk, required String harga, required String stok, String? deskripsiProduk, required String detailProduk, required File? fotoProduk, required String idToko}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final url = Uri.https(apiBaseUrl, '/v3/produk/add');
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

  if(!context.mounted) return;
  if(response.statusCode == 401){
    prefs.clear();
    prefs.setBool('isAuthenticated', false);
    context.goNamed('signin');
  }
  if(response.statusCode == 200){
    context.pop();
    addNotifikasiToko(
      type: 'Informasi',
      title: 'Produk baru berhasil ditambahkan!',
      description: 'Produk $namaProduk baru berhasil ditambahkan! produk akan segera ditampilkan di etalase toko!',
      idToko: idToko
    );
    successSnackBar(
      context: context,
      content: 'Produk berhasil ditambahkan!'
    );
    return context.goNamed('shop-dash', queryParameters: {'id_toko': idToko, 'isRedirect': 'false'});
  }
}

void updateFotoProduk({required BuildContext context, required String idProduk, required File fotoProduk, required String oldImage, required String idToko}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final url = Uri.https(apiBaseUrl, '/v3/produk/update/foto/$idProduk');
  final request = http.MultipartRequest('POST', url);
  request.headers.addAll({
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });
  request.fields['old_image'] = oldImage;
  request.files.add(http.MultipartFile.fromBytes('foto_produk', File(fotoProduk.path).readAsBytesSync(), filename: fotoProduk.path));
  final response = await request.send();

  if(!context.mounted) return;
  if(response.statusCode == 401){
    prefs.clear();
    prefs.setBool('isAuthenticated', false);
    context.goNamed('signin');
  }
  if(response.statusCode == 200){
    successSnackBar(
      context: context,
      content: 'Foto produk berhasil diubah!'
    );
    return context.goNamed('shop-dash', queryParameters: {'id_toko': idToko});
  }
}

void updateProduk({required BuildContext context, required String namaProduk, required String harga, required String stok, required String deskripsiProduk, required String detailProduk, required String idProduk, required String idToko}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final url = Uri.https(apiBaseUrl, '/v3/produk/update');
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
  if(response.statusCode == 401){
    prefs.clear();
    prefs.setBool('isAuthenticated', false);
    context.goNamed('signin');
  }
  if(response.statusCode == 200){
    addNotifikasiToko(
      type: 'Informasi',
      title: 'Informasi produk berhasil diubah!',
      description: 'Informasi produk $namaProduk berhasil diubah!',
      idToko: idToko
    );
    successSnackBar(
      context: context,
      content: 'Informasi produk berhasil diubah!'
    );
    return context.goNamed('shop-dash', queryParameters: {'id_toko': idToko});
  }
}

void removeProduct({required BuildContext context, required String idProduk}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final url = Uri.https(apiBaseUrl, '/v3/produk/delete');
  final response = await http.post(url, body: json.encode({
    'id_produk': idProduk
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  if(!context.mounted) return;
  if(response.statusCode == 401){
    prefs.clear();
    prefs.setBool('isAuthenticated', false);
    context.goNamed('signin');
  }
  if(response.statusCode == 200){
    successSnackBar(
      context: context,
      content: 'Produk berhasil dihapus!'
    );
    return context.goNamed('shop-dash', queryParameters: {'id_toko': prefs.getInt('id_toko').toString()});
  }
}

Future<http.Response?> getTokoByIdToko({required BuildContext context, required String shopId}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final url = Uri.https(apiBaseUrl, '/v3/toko/$shopId');
  final response = await http.get(url, headers: {
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  if(!context.mounted) return null;
  if(response.statusCode == 401){
    prefs.clear();
    prefs.setBool('isAuthenticated', false);
    context.goNamed('signin');
  }
  if(response.statusCode == 200){
    return response;
  }

  return null;
}

Future<http.Response?> search({required BuildContext context, required String query}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final url = Uri.https(apiBaseUrl, '/v3/search');
  final response = await http.post(url, body: json.encode({
    'query': query
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  if(!context.mounted) return null;
  if(response.statusCode == 401){
    prefs.clear();
    prefs.setBool('isAuthenticated', false);
    context.goNamed('signin');
  }
  if(response.statusCode == 200){
    return response;
  }

  return null;
}

Future<http.Response?> addToKeranjang({required BuildContext context, required String idProduk, required int qty, String? catatan}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final url = Uri.https(apiBaseUrl, '/v3/user/keranjang/add');
  final response = await http.post(url, body: json.encode({
    'id': idProduk,
    'qty': qty.toString(),
    'catatan': catatan
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  if(!context.mounted) return null;
  if(response.statusCode == 401){
    prefs.clear();
    prefs.setBool('isAuthenticated', false);
    context.goNamed('signin');
  }
  if(response.statusCode == 200){
    return response;
  }

  return null;
}

Future<http.Response?> getDataKeranjang({required BuildContext context}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final url = Uri.https(apiBaseUrl, '/v3/user/keranjang');
  final response = await http.get(url, headers: {
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  if(!context.mounted) return null;
  if(response.statusCode == 401){
    prefs.clear();
    prefs.setBool('isAuthenticated', false);
    context.goNamed('signin');
  }
  if(response.statusCode == 200){
    return response;
  }

  return null;
}

Future<http.Response?> deleteFromKeranjang({required BuildContext context, required int idKeranjang}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final url = Uri.https(apiBaseUrl, '/v3/user/keranjang/delete');
  final response = await http.delete(url, body: json.encode({
    'id': idKeranjang.toString(),
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  if(!context.mounted) return null;
  if(response.statusCode == 401){
    prefs.clear();
    prefs.setBool('isAuthenticated', false);
    context.goNamed('signin');
  }
  if(response.statusCode == 200){
    return response;
  }

  return null;
}

Future<http.Response?> updateKeranjang({required BuildContext context, required int idKeranjang, required int qty}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final url = Uri.https(apiBaseUrl, '/v3/user/keranjang/update');
  final response = await http.post(url, body: json.encode({
    'id': idKeranjang.toString(),
    'qty': qty.toString(),
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  if(!context.mounted) return null;
  if(response.statusCode == 401){
    prefs.clear();
    prefs.setBool('isAuthenticated', false);
    context.goNamed('signin');
  }
  if(response.statusCode == 200){
    return response;
  }

  return null;
}

Future<http.Response?> getFavorit({required BuildContext context}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final url = Uri.https(apiBaseUrl, '/v3/user/favorit');
  final response = await http.get(url, headers: {
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  if(!context.mounted) return null;
  if(response.statusCode == 401){
    prefs.clear();
    prefs.setBool('isAuthenticated', false);
    context.goNamed('signin');
  }
  if(response.statusCode == 200){
    return response;
  }

  return null;
}

void addToFavorit({required BuildContext context, required String idToko}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final url = Uri.https(apiBaseUrl, '/v3/user/favorit/add');
  final response = await http.post(url, body: json.encode({
    'id_toko': idToko,
  }),headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  if(!context.mounted) return;
  if(response.statusCode == 401){
    prefs.clear();
    prefs.setBool('isAuthenticated', false);
    context.goNamed('signin');
  }
  if(response.statusCode == 200){
    addNotifikasiToko(
      type: 'Informasi',
      title: 'Seseorang menyukai toko anda!',
      description: 'Selamat! Seorang pelanggan menyukai toko anda!',
      idToko: idToko
    );
    successSnackBar(
      context: context,
      content: 'Anda menyukai toko ini'
    );
  }
}

void removeFromFavorite({required BuildContext context, required String idToko}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final url = Uri.https(apiBaseUrl, '/v3/user/favorit/delete');
  final response = await http.post(url, body: json.encode({
    'id_toko': idToko,
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  if(!context.mounted) return;
  if(response.statusCode == 401){
    prefs.clear();
    prefs.setBool('isAuthenticated', false);
    context.goNamed('signin');
  }
  if(response.statusCode == 200){
    successSnackBar(
      context: context,
      content: 'Anda batal menyukai toko ini'
    );
  }
}

Future<http.Response?> getDataPesanan({required BuildContext context, required String statusPesanan}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final url = Uri.https(apiBaseUrl, '/v3/order');
  final response = await http.post(url, body: json.encode({
    'status': statusPesanan
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  if(!context.mounted) return null;
  if(response.statusCode == 401){
    prefs.clear();
    prefs.setBool('isAuthenticated', false);
    context.goNamed('signin');
  }
  if(response.statusCode == 200){
    return response;
  }

  return null;
}

Future<http.Response?> getPesananByToko({required BuildContext context, required String idToko, required String statusPesanan}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final url = Uri.https(apiBaseUrl, '/v3/toko/orders');
  final response = await http.post(url, body: json.encode({
    'id_toko': idToko,
    'status': statusPesanan
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  if(!context.mounted) return null;
  if(response.statusCode == 401){
    prefs.clear();
    prefs.setBool('isAuthenticated', false);
    context.goNamed('signin');
  }
  if(response.statusCode == 200){
    return response;
  }

  return null;
}

Future<http.Response?> createPesanan({required BuildContext context, required String idProduk, required int jumlah, required double totalHarga, String? catatan, required String alamat, required String idToko}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final url = Uri.https(apiBaseUrl, '/v3/order/new');
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

  if(!context.mounted) return null;
  if(response.statusCode == 401){
    prefs.clear();
    prefs.setBool('isAuthenticated', false);
    context.goNamed('signin');
  }
  if(response.statusCode == 200){
    addNotifikasiToko(
      type: 'Informasi',
      title: 'Pesanan baru!',
      description: 'Anda menerima pesanan baru! segera proses pesanan anda!',
      idToko: idToko
    );
    addNotifikasi(
      type: 'Informasi',
      title: 'Pesanan anda sedang diproses!',
      description: 'Mohon untuk menunggu penjual melakukan konfirmasi pada pesanan anda.',
    );
    return response;
  }

  return null;
}

void updateStatusPesanan({required BuildContext context, required String idTransaksi, required String status, String? idToko}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final url = Uri.https(apiBaseUrl, '/v3/order/update');
  final response = await http.patch(url, body: json.encode({
    'id_transaksi': idTransaksi,
    'status': status,
  }),headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  if(!context.mounted) return;
  if(response.statusCode == 401){
    prefs.clear();
    prefs.setBool('isAuthenticated', false);
    context.goNamed('signin');
  }
  if(response.statusCode == 200){
    if(idToko != null){
      if(status == 'Diproses'){
        successSnackBar(
          context: context,
          content: 'Pesanan dikonfirmasi'
        );
        return context.goNamed('order-status', queryParameters: {'id_toko': idToko, 'initial_index': '1'});
      } else if (status == 'Selesai'){
        successSnackBar(
          context: context,
          content: 'Pesanan selesai'
        );
        return context.goNamed('order-status', queryParameters: {'id_toko': idToko, 'initial_index': '2'});
      }
    } else {
      addNotifikasi(
        type: 'Informasi',
        title: 'Pesanan anda selesai!',
        description: 'Mohon untuk mengecek kesesuaian pesanan anda.',
      );
      successSnackBar(
        context: context,
        content: 'Pesanan selesai'
      );
      return context.goNamed('order', queryParameters: {'initial_index': '1'});
    }
  }
}

Future<http.Response?> getUlasan({required BuildContext context}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final url = Uri.https(apiBaseUrl, '/v3/user/rate');
  final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  if(!context.mounted) return null;
  if(response.statusCode == 401){
    prefs.clear();
    prefs.setBool('isAuthenticated', false);
    context.goNamed('signin');
  }
  if(response.statusCode == 200){
    return response;
  }

  return null;
}

Future<http.Response?> getUlasanByToko({required BuildContext context, required String idToko}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final url = Uri.https(apiBaseUrl, '/v3/toko/rate');
  final response = await http.post(url, body: json.encode({
    'id_toko': idToko
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  if(!context.mounted) return null;
  if(response.statusCode == 401){
    prefs.clear();
    prefs.setBool('isAuthenticated', false);
    context.goNamed('signin');
  }
  if(response.statusCode == 200){
    return response;
  }

  return null;
}

void addUlasan({required BuildContext context, required String idProduk, required String idTransaksi, required String ulasan, required String rate, required String idToko}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final url = Uri.https(apiBaseUrl, '/v3/user/rate/add');
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
  if(response.statusCode == 401){
    prefs.clear();
    prefs.setBool('isAuthenticated', false);
    context.goNamed('signin');
  }
  if(response.statusCode == 200){
    addNotifikasiToko(
      type: 'Informasi',
      title: 'Seorang pelanggan menambahkan ulasan baru!',
      description: 'Anda menerima ulasan baru! cek ulasan dan bantu tingkatkan kepuasan pelangganmu!',
      idToko: idToko
    );
    successSnackBar(
      context: context,
      content: 'Berhasil menambahkan ulasan'
    );
    return context.goNamed('home');
  }
}

Future<http.Response?> getDataNotifikasi({required BuildContext context, required String type}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final url = Uri.https(apiBaseUrl, '/v3/user/notifikasi');
  final response = await http.post(url, body: json.encode({
    'type': type,
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  if(!context.mounted) return null;
  if(response.statusCode == 401){
    prefs.clear();
    prefs.setBool('isAuthenticated', false);
    context.goNamed('signin');
  }
  if(response.statusCode == 200){
    return response;
  }

  return null;
}

void addNotifikasi({required String type, required String title, required String description}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final url = Uri.https(apiBaseUrl, '/v3/user/notifikasi/add');
  await http.post(url, body: json.encode({
    'type': type,
    'title': title,
    'description': description
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });
}

Future<http.Response?> getDataNotifikasiToko({required BuildContext context, required String type}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final url = Uri.https(apiBaseUrl, '/v3/toko/notifikasi');
  final response = await http.post(url, body: json.encode({
    'type': type,
  }), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${prefs.getString('token')}'
  });

  if(!context.mounted) return null;
  if(response.statusCode == 401){
    prefs.clear();
    prefs.setBool('isAuthenticated', false);
    context.goNamed('signin');
  }
  if(response.statusCode == 200){
    return response;
  }

  return null;
}

void addNotifikasiToko({required String type, required String title, required String description, required String idToko}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final url = Uri.https(apiBaseUrl, '/v3/toko/notifikasi/add');
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