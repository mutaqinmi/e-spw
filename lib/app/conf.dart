import 'package:e_spw/app/themes.dart';
import 'package:flutter/material.dart';
import 'package:e_spw/app/routes.dart';

class App extends StatelessWidget{
  const App({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp.router(
      routerConfig: routes,
      theme: themes,
      debugShowCheckedModeBanner: false,
    );
  }
}