import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:espw/widgets/animated_text.dart';

class MainPage extends StatelessWidget{
  const MainPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/image/online-shop.png",
          width: 300,
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/icon/espw-colored.png",
                  width: 25,
                ),
                const Gap(10),
                const Row(
                  children: [
                    Text(
                      'Beli ',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                    AnimatedTypeWriterText(
                      texts: ['apa aja', 'makanan', 'minuman'],
                    )
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
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                style: ButtonStyle(
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    )
                  ),
                ),
                child: const Text(
                  "AYO MULAI!",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  ),
                ),
                onPressed: (){
                  context.pushNamed('signin');
                },
              )
            )
          ],
        )
      ),
    );
  }
}