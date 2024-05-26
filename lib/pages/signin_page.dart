import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:espw/app/controllers.dart';

class SignInPage extends StatefulWidget{
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage>{
  Widget _buttonChild = const Text(
    "AYO MULAI!",
    style: TextStyle(
      fontWeight: FontWeight.w600,
      letterSpacing: 2,
    ),
  );
  final _signInKey = GlobalKey<FormFieldState>();
  String _nis = '';

  void _submit(){
    if(_signInKey.currentState!.validate()){
      _signInKey.currentState!.save();
      setState(() {
        _buttonChild = const SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        );
      });
      signIn(context, _nis);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SingleChildScrollView(
        padding: MediaQuery.of(context).viewInsets,
        reverse: true,
        child: SafeArea(
          minimum: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 10),
                      child: Image.asset(
                        "assets/image/login-page.png",
                        width: 300,
                      ),
                    )
                  ),
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
              const Gap(50),
              Form(
                child: TextFormField(
                  key: _signInKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    hintText: 'Nomor Induk Siswa (NIS)',
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                  ),
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Isi NIS terlebih dahulu!';
                    }

                    return null;
                  },
                  onSaved: (value){_nis = value!;}
                ),
              ),
              const Gap(10),
              SizedBox(
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
                  child: _buttonChild,
                  onPressed: () => _submit(),
                )
              )
            ],
          )
        ),
      )
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