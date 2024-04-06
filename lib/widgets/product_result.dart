import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class ProductResult extends StatelessWidget{
  const ProductResult({super.key, required this.imageURL, required this.shopName, required this.productName, required this.soldTotal, required this.price, required this.rating, this.onTap});
  final String imageURL;
  final String shopName;
  final String productName;
  final int soldTotal;
  final int price;
  final double rating;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context){
    NumberFormat formatter = NumberFormat("###,###.##", "id_ID");

    return SafeArea(
      top: false,
      bottom: false,
      minimum: const EdgeInsets.only(left: 16, right: 16, top: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    imageURL,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    shopName,
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    productName,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16,
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
                              ),
                              const Gap(20),
                              Text(
                                'Rp. ${formatter.format(price)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(10),
                        Row(
                          children: [
                            Icon(Icons.star_outline, color: Theme.of(context).primaryColor),
                            Text(rating.toString())
                          ],
                        )
                      ],
                    )
                  ),
                )
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