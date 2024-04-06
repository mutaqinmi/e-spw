import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:espw/app/controllers.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _signInKey = GlobalKey<FormFieldState>();
  String _nis = '';

  void _submit(){
    if(_signInKey.currentState!.validate()){
      _signInKey.currentState!.save();
      signIn(context, _nis);
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Masuk',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600
          ),
        ),
        actions: [
          IconButton(
            onPressed: (){},
            icon: const Icon(Icons.help_outline),
          )
        ],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Gap(10),
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
                  'Masuk untuk melanjutkan.',
                  style: TextStyle(
                    fontSize: 12
                  ),
                )
              ],
            ),
            const Gap(30),
            Form(
              child: TextFormField(
                key: _signInKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                autofocus: true,
                keyboardType: TextInputType.datetime,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  hintText: 'Nomor Induk Siswa (NIS)',
                  labelText: 'Nomor Induk Siswa (NIS)',
                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                ),
                validator: (value){
                  if(value!.isEmpty){
                    return 'Isi form terlebih dahulu!';
                  }

                  return null;
                },
                onSaved: (value){_nis = value!;},
              ),
            ),
            const Gap(30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                style: ButtonStyle(
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
                  ),
                ),
                child: const Text(
                  'Selanjutnya',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: (){_submit();},
              ),
            ),
          ],
        ),
      )
    );
  }
}