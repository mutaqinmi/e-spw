import 'package:espw/app/controllers.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ChangePassword extends StatefulWidget{
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword>{
  bool _buttonClick = false;
  final _passwordKey = GlobalKey<FormFieldState>();
  final _confirmPasswordKey = GlobalKey<FormFieldState>();
  bool _obscureTextNewPassword = true;
  bool _obscureTextConfirmPassword = true;
  String _password = '';
  String _confirmPassword = '';

  void _submit(){
    if(_passwordKey.currentState!.validate()){
      _passwordKey.currentState!.save();
      if(_confirmPasswordKey.currentState!.validate()){
        _confirmPasswordKey.currentState!.save();
        setState(() {
          _buttonClick = true;
        });
        changePassword(context, _confirmPassword);
      }
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ubah Kata Sandi',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  Text(
                    'Ubah kata sandi anda untuk keamanan akun.'
                  )
                ],
              ),
              const Gap(10),
              TextFormField(
                key: _passwordKey,
                obscureText: _obscureTextNewPassword,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                  hintText: 'Masukkan kata sandi baru',
                  label: const Text('Masukkan kata sandi baru'),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureTextNewPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                    onPressed: () => setState(() {
                      _obscureTextNewPassword = !_obscureTextNewPassword;
                    }),
                  ),
                ),
                validator: (value){
                  if(value!.isEmpty){
                    return 'Masukkan password terlebih dahulu!';
                  }

                  return null;
                },
                onSaved: (value) => _password = value!,
              ),
              const Gap(30),
              const Text(
                'Konfirmasi kata sandi anda.'
              ),
              const Gap(10),
              TextFormField(
                key: _confirmPasswordKey,
                obscureText: _obscureTextConfirmPassword,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                  hintText: 'Konfirmasi kata sandi baru',
                  label: const Text('Konfirmasi kata sandi baru'),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureTextConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                    onPressed: () => setState(() {
                      _obscureTextConfirmPassword = !_obscureTextConfirmPassword;
                    }),
                  )
                ),
                validator: (value){
                  if(value!.isEmpty){
                    return 'Konfirmasi password terlebih dahulu!';
                  }

                  if(value != _password){
                    return 'Password tidak sesuai';
                  }

                  return null;
                },
                onSaved: (value) => _confirmPassword = value!,
              ),
            ],
          ),
        )
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
              child: _buttonClick ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ) : const Text(
                'Ubah Kata Sandi',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () => _submit(),
            ),
          ),
        )
      ),
    );
  }
}