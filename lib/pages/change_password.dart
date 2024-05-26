import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ChangePassword extends StatefulWidget{
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword>{
  bool _obscureTextNewPassword = true;
  bool _obscureTextConfirmPassword = true;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ubah Kata Sandi',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600
          ),
        ),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          child: Column(
            children: [
              const Gap(10),
              TextFormField(
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
                  )
                ),
              ),
              const Gap(10),
              TextFormField(
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
              child: const Text(
                'Ubah Kata Sandi',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: (){},
            ),
          ),
        )
      ),
    );
  }
}