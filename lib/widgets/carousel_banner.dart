import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Carousel extends StatelessWidget{
  const Carousel({super.key, required this.banner});
  final List<Widget> banner;

  @override
  Widget build(BuildContext context){
    return CarouselSlider(
      items: banner,
      options: CarouselOptions(
        viewportFraction: 1,
        autoPlay: true,
      ),
    );
  }
}