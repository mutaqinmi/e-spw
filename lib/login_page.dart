import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:gap/gap.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});
  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  final nisController = TextEditingController();
  final passwordController = TextEditingController();
  final List<String> texts = <String>[
    "apa aja",
    "makanan",
    "minuman",
  ];

  @override
  void dispose(){
    nisController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Center(
              child: Container(
                margin: const EdgeInsets.only(top: 100, bottom: 50),
                child: Image.asset(
                  "assets/image/login-image.png",
                  width: 250,
                  height: 250,
                ),
              )
          ),
          Column(
            children: [
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 30, top: 20),
                    child: Image.asset(
                      "assets/image/espw-colored.png",
                      width: 25,
                      height: 25,
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 30, top: 10),
                    child: Row(
                      children: <Widget>[
                        const Text(
                          "Beli ",
                          style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.w700
                          ),
                        ),
                        AnimatedTextKit(
                          animatedTexts: _buildAnimatedTexts(context),
                          repeatForever: true,
                          pause: const Duration(milliseconds: 1000),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 30),
                    child: Row(
                      children: [
                        const Text(
                          "bisa ",
                          style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.w700
                          ),
                        ),
                        Text(
                          "dimana aja",
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const Text(
                          "!",
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        child: const Text(
                          "Dapatkan produk yang kamu inginkan, dengan kemudahan berbelanja online hanya di E-SPW!",
                        ),
                      )
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width - 50,
                height: 50,
                child: FilledButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )
                      ),
                      backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.primary)
                  ),
                  child: const Text(
                    "AYO MULAI!",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                    ),
                  ),
                  onPressed: (){_loginSheet(context);},
                )
            )
          ],
        ),
      ),
    );
  }

  _loginSheet(context) {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10))
        ),
        showDragHandle: true,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context){
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              width: MediaQuery.of(context).size.width,
              height: 250,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nisController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'NIS (Nomor Induk Siswa)',
                      hintText: 'Masukkan NIS',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ),
                  const Gap(20),
                  StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState){
                      return TextFormField(
                        controller: passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'Password',
                            hintText: 'Masukkan password',
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
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
                  const Gap(50),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 50,
                      height: 50,
                      child: FilledButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                )
                            ),
                            backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.primary)
                        ),
                        child: const Text(
                          "LOGIN",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2,
                          ),
                        ),
                        onPressed: (){
                          showDialog(
                              context: context,
                              builder: (context) {
                                return const AlertDialog(
                                    content: Text(
                                      'Success!',
                                    )
                                );
                              }
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }
    );
  }

  List<TypewriterAnimatedText> _buildAnimatedTexts(context) {
    return texts.map((text) {
      return TypewriterAnimatedText(
        text,
        textStyle: TextStyle(
          fontSize: 35,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.primary,
        ),
        speed: const Duration(milliseconds: 100),
        cursor: '',
        curve: Curves.decelerate,
      );
    }).toList();
  }
}