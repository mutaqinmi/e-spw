import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class OrderCreatedPage extends StatelessWidget{
  const OrderCreatedPage({super.key});

  @override
  Widget build(BuildContext context){
    Future.delayed(const Duration(seconds: 3), (){
      context.goNamed('order', queryParameters: {'initial_index': '0'});
    });
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: const SafeArea(
        top: false,
        minimum: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.verified_outlined,
                size: 80,
                color: Colors.white,
              ),
              Gap(20),
              Text(
                'Pesanan berhasil dipesan!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.white
                ),
              ),
              Text(
                'Pesanan anda akan segera dikonfirmasi oleh penjual, mohon untuk menunggu beberapa saat.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white
                ),
              )
            ]
          )
        ),
      )
    );
  }
}