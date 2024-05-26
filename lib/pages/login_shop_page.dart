import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class LoginShopPage extends StatelessWidget{
  const LoginShopPage({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Column(
                children: [
                  Text(
                    'Ciptakan Usahamu!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  Gap(10),
                  Text(
                    'Jangan ragu untuk memulainya karena sukses tidak perlu menunggu tua, kalau bisa sukses usia muda, kenapa harus ditunda?',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Image.asset(
                'assets/image/create-shop-page.png',
                width: 350,
              )
            ],
          ),
        )
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: () => context.pushNamed('create-shop', queryParameters: {'isRedirect': 'false'}),
                child: const Text('Buat Toko Sekarang!'),
              ),
            ),
            const Gap(10),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () => context.pushNamed('join-shop', queryParameters: {'isRedirect': 'false'}),
                child: const Text('Gabung ke Toko'),
              ),
            )
          ],
        ),
      )
    );
  }
}