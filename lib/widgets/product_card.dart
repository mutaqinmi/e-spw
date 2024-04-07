import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class ProductCard extends StatelessWidget{
  const ProductCard({super.key, required this.imageURL, required this.productName, required this.description, required this.soldTotal, required this.price, required this.rating, this.onTap});
  final String imageURL;
  final String productName;
  final String description;
  final int soldTotal;
  final int price;
  final double rating;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context){
    NumberFormat formatter = NumberFormat("###,###.##", "id_ID");

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(left: 16, right: 16, top: 5),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 4,
          child: Column(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: imageURL,
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.white
                      ),
                      child: Row(
                        children: [
                          Text(rating.toString()),
                          Icon(Icons.star_rate_rounded, color: Theme.of(context).primaryColor,),
                        ],
                      )
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            productName,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                          Text(
                            description,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Rp. ${formatter.format(price)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                        Text(
                          'Terjual $soldTotal',
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}