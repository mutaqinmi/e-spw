import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ShopCard extends StatelessWidget{
  const ShopCard({super.key, required this.imageURL, required this.className, required this.shopName, required this.rating, this.onTap});
  final String imageURL;
  final String className;
  final String shopName;
  final double rating;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        child: SizedBox(
          width: 150,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                child: Image.network(
                  imageURL,
                  width: double.infinity,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      className,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      shopName,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    const Gap(15),
                    Row(
                      children: [
                        Icon(Icons.star_outline, color: Theme.of(context).primaryColor,),
                        const Gap(5),
                        Text(rating.toString())
                      ],
                    ),
                  ],
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}