import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:e_spw/widgets/animated_texts.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/image/login-image.png",
          width: 250,
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Image.asset(
                      "assets/icon/espw-colored.png",
                      width: 25,
                    )
                  ],
                ),
                const Gap(10),
                Row(
                  children: [
                    const Text(
                      'Beli ',
                      style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w700
                      ),
                    ),
                    animatedText(context, ['apa aja', 'makanan', 'minuman']),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'bisa ',
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
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const Text(
                      '!',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                  ],
                ),
                const Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Dapatkan produk yang kamu inginkan, dengan kemudahan berbelanja online hanya di E-SPW!",
                      )
                    ),
                  ],
                ),
              ],
            ),
            const Gap(30),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width - 36,
                  height: 50,
                  child: FilledButton(
                    style: ButtonStyle(
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        )
                      ),
                      backgroundColor: MaterialStatePropertyAll(Theme.of(context).primaryColor)
                    ),
                    child: const Text(
                      "AYO MULAI!",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                      ),
                    ),
                    onPressed: (){
                      context.pushNamed('signup');
                    },
                  )
                )
              ],
            ),
            const Gap(10),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: TextButton(
                style: const ButtonStyle(
                  overlayColor: MaterialStatePropertyAll(Colors.transparent),
                ),
                child: const Text('Saya sudah memiliki akun'),
                onPressed: (){
                  context.pushNamed('signin');
                },
              ),
            )
          ],
        )
      ),
    );
  }
}