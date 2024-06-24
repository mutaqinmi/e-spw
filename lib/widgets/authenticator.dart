import 'package:espw/app/controllers.dart';
import 'package:espw/widgets/bottom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

Future<bool?> authenticator({required BuildContext context}) async {
  final formFieldKey = GlobalKey<FormFieldState>();
  bool obscureText = true;
  String password = '';

  return await showModalBottomSheet<bool>(
    isScrollControlled: true,
    showDragHandle: true,
    context: context,
    builder: (BuildContext context){
      return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 18),
            child: Column(
              children: [
                Column(
                  children: [
                    const Text(
                      'Verifikasi',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    const Text(
                      'Verifikasi akun anda terlebih dahulu.',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    const Gap(20),
                    StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) => Form(
                        child: TextFormField(
                          key: formFieldKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          obscureText: obscureText,
                          autofocus: true,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                            hintText: 'Password',
                            labelText: 'Password',
                            suffixIcon: IconButton(
                              icon: Icon(obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                              onPressed: () => setState(() {
                                obscureText = !obscureText;
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
                          onSaved: (value){password = value!;},
                        ),
                      ),
                    )
                  ],
                ),
                const Gap(20),
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FilledButton(
                        onPressed: <bool>() {
                          if(formFieldKey.currentState!.validate()){
                            formFieldKey.currentState!.save();
                            authenticate(password: password).then((res){
                              if(res.statusCode == 200){
                                successSnackBar(
                                  context: context,
                                  content: 'Autentikasi berhasil!'
                                );
                                context.pop(true);
                              }

                              context.pop(false);
                            });
                          }
                        },
                        child: const Text('Verifikasi'),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      );
    }
  );
}