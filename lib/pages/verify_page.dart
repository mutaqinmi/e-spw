import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:espw/app/controllers.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Verify extends StatefulWidget {
  const Verify({super.key, required this.token});
  final String token;

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  final _formFieldKey = GlobalKey<FormFieldState>();
  bool _obscureText = true;
  String _password = '';

  @override
  void dispose() {
    super.dispose();
  }

  void _submit() async {
    if(_formFieldKey.currentState!.validate()){
      _formFieldKey.currentState!.save();
      final verify = JWT.verify(widget.token, SecretKey('espwapp'));
      signin(
        context: context,
        nis: verify.payload['nis'],
        password: _password,
        token: widget.token
      );
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Verifikasi',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600
          ),
        ),
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
                  'Verifikasi akun anda.',
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
                  'Masukkan password untuk melanjutkan.',
                  style: TextStyle(
                    fontSize: 12
                  ),
                )
              ],
            ),
            const Gap(30),
            Form(
              child: TextFormField(
                key: _formFieldKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                obscureText: _obscureText,
                autofocus: true,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                  hintText: 'Password',
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(_obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                    onPressed: () => setState(() {
                      _obscureText = !_obscureText;
                    }),
                  )
                ),
                validator: (value){
                  if(value!.isEmpty){
                    return 'Isi field terlebih dahulu!';
                  }

                  if(value.length <= 4){
                    return 'Password harus diisi minimal 5 karakter';
                  }

                  return null;
                },
                onSaved: (value) => _password = value!,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton(
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  )
                ),
              ),
              child: const Text(
                'Masuk',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () => _submit(),
            ),
          ),
        )
      )
    );
  }
}