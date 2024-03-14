import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

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

AnimatedTextKit animatedText(BuildContext context, List<String> texts){
  return AnimatedTextKit(
    animatedTexts: _buildAnimatedTexts(context, texts),
    repeatForever: true,
    pause: const Duration(milliseconds: 1000),
  );
}