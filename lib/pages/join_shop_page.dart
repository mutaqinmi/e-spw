import 'package:espw/app/controllers.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pinput/pinput.dart';

class JoinShopPage extends StatefulWidget {
  const JoinShopPage({super.key});

  @override
  State<JoinShopPage> createState() => _JoinShopPageState();
}

class _JoinShopPageState extends State<JoinShopPage>{
  String kodeUnik = '';

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Gabung ke Toko',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  const Text(
                    'Masukkan kode toko untuk bergabung'
                  ),
                  const Gap(20),
                  Form(
                    child: Pinput(
                      length: 4,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      keyboardType: TextInputType.text,
                      onCompleted: (value) => kodeUnik = value,
                    ),
                  )
                ],
              ),
            ),
            const Gap(30),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tips:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey
                  ),
                ),
                Text(
                  '1. Minta teman anda untuk membuka aplikasi eSPW.',
                  style: TextStyle(
                    color: Colors.grey
                  ),
                ),
                Text(
                  '2. Masuk ke menu Profil > Toko. Kemudian pilih toko yang anda ingin gabung',
                  style: TextStyle(
                    color: Colors.grey
                  ),
                ),
                Text(
                  '3. Scroll kebawah kemudian klik Pengaturan Toko',
                  style: TextStyle(
                    color: Colors.grey
                  ),
                ),
                Text(
                  '4. Klik Informasi > Kode Unik',
                  style: TextStyle(
                    color: Colors.grey
                  ),
                ),
              ],
            )
          ],
        )
      ),
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton(
              onPressed: () => joinKelompok(
                context: context,
                kodeUnik: kodeUnik
              ),
              child: const Text('Gabung'),
            ),
          ),
        ),
      ),
    );
  }
}