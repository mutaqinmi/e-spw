import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class MainPage extends StatelessWidget{
  const MainPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/image/online-shop.png",
          width: 350,
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

class AnimatedTypeWriterText extends StatelessWidget{
  const AnimatedTypeWriterText({super.key, required this.texts});
  final List<String> texts;

  @override
  Widget build(BuildContext context){
    return AnimatedTextKit(
      animatedTexts: _buildAnimatedTexts(context, texts),
      repeatForever: true,
      pause: const Duration(milliseconds: 1000),
    );
  }

  List<TypewriterAnimatedText> _buildAnimatedTexts(BuildContext context, List<String> texts) {
    final List<String> text = texts;

    return text.map((text) {
      return TypewriterAnimatedText(
        text,
        textStyle: TextStyle(
          fontSize: 35,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).primaryColor,
        ),
        speed: const Duration(milliseconds: 100),
        cursor: '',
        curve: Curves.decelerate,
      );
    }).toList();
  }
}