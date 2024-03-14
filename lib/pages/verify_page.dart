import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:e_spw/widgets/dialog.dart';
import 'package:e_spw/widgets/bottom_snack_bar.dart';

class Verify extends StatefulWidget {
  const Verify({super.key});

  @override
  State<Verify> createState() => _VerifyState();
}

void _verify(BuildContext context, TextEditingController data){
  String userPassword = 'ilham123';
  if(data.text == userPassword){
    successSnackBar(
      context,
      const Text('Login berhasil!')
    );
    context.pushNamed('home');
  } else {
    alertSnackBar(
      context,
      const Text('Password salah!')
    );
  }
}

class _VerifyState extends State<Verify> {
  final _password = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose(){
    _password.dispose();
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
                const Text('Masukkan password anda untuk masuk')
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
                  'Verifikasi akun anda',
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
                  'Masukkan password untuk masuk.'
                )
              ],
            ),
            const Gap(50),
            const Row(
              children: [
                Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 14
                  ),
                )
              ],
            ),
            const Gap(5),
            StatefulBuilder(
              builder: (BuildContext context, StateSetter setState){
                return TextFormField(
                  controller: _password,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                      onPressed: (){
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  ),
                );
              },
            ),
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
            onPressed: (){_verify(context, _password);},
          ),
        ),
      ),
    );
  }
}