import 'package:e_spw/widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:e_spw/app/controllers.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _nis = TextEditingController();

  @override
  void dispose(){
    _nis.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            context.pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        actions: [
          IconButton(
            onPressed: (){
              confirmDialog(
                context,
                const Text(
                  'NIS atau Nomor Induk Siswa merupakan nomor induk yang dikeluarkan oleh satuan pendidikan sebagai nomor identifikasi pelajar. Biasanya, NIS terdiri dari 8 digit angka dan tertera dalam absensi siswa'
                ),
              );
            },
            icon: const Icon(Icons.help_outline),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const Gap(30),
            const Row(
              children: [
                Text(
                  'Selamat datang di E - SPW!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600
                  ),
                ),
              ],
            ),
            const Row(
              children: [
                Text(
                  'Masuk untuk melanjutkan.'
                )
              ],
            ),
            const Gap(50),
            const Row(
              children: [
                Text(
                  'NIS (Nomor Induk Siswa)',
                  style: TextStyle(
                    fontSize: 14
                  ),
                )
              ],
            ),
            const Gap(5),
            TextFormField(
              controller: _nis,
              keyboardType: TextInputType.datetime,
              decoration: const InputDecoration(
                hintText: 'NIS (Nomor Induk Siswa)',
                prefixIcon: Icon(Icons.pin_outlined),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: FilledButton(
            style: ButtonStyle(
              shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )
              ),
              backgroundColor: MaterialStatePropertyAll(Theme.of(context).primaryColor),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Masuk',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                )
              ],
            ),
            onPressed: (){signUp(context, _nis);},
          ),
        ),
      ),
    );
  }
}