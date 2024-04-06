import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

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