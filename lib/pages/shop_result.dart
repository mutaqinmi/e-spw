import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ShopResult extends StatelessWidget{
  const ShopResult({super.key, required this.imageURL, required this.className, required this.shopName, this.onTap});
  final String imageURL;
  final String className;
  final String shopName;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context){
    return SafeArea(
      top: false,
      bottom: false,
      minimum: const EdgeInsets.only(left: 16, right: 16, top: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(
                    imageURL
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shopName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      Text(className)
                    ],
                  )
                ),
              ],
            ),
          ),
          const Gap(10),
          const Divider(
            thickness: 0.2,
          )
        ],
      )
    );
  }
}