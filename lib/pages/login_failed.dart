import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class LoginFailed extends StatelessWidget{
  const LoginFailed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error,
              size: 50,
              color: Colors.red,
            ),
            const Gap(10),
            const Text(
              'Login Gagal!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700
              ),
            ),
            const Gap(10),
            const Text(
              'NIS salah / tidak ditemukan!',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400
              ),
            ),
            const Gap(20),
            TextButton(
              onPressed: (){
                context.goNamed('signin');
              },
              child: const Text('Kembali')
            )
          ],
        ),
      ),
    );
  }
}