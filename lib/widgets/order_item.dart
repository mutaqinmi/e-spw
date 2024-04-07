import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class OrderItem extends StatelessWidget{
  const OrderItem({super.key, required this.shopName, required this.productImage, required this.productName, required this.date, required this.priceTotal, required this.qty, required this.isFinished});
  final String shopName;
  final String productImage;
  final String productName;
  final String date;
  final int priceTotal;
  final int qty;
  final bool isFinished;

  Widget _isFinished(bool isFinished){
    if(isFinished){
      return Wrap(
        spacing: 10,
        children: [
          SizedBox(
            width: 135,
            child: OutlinedButton(
              onPressed: (){},
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Beli lagi'),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 110,
            child: FilledButton(
              onPressed: (){},
              child: const Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 5,
                children: [
                  Icon(Icons.star_rate_rounded),
                  Text('Rate'),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return SizedBox(
      width: 170,
      child: FilledButton(
        onPressed: (){},
        child: const Wrap(
          spacing: 5,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(Icons.chat_outlined),
            Text('Chat penjual'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    final formatter = NumberFormat('###,###.###', 'id_ID');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Wrap(
                  spacing: 5,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Icon(Icons.storefront),
                    Text(shopName),
                  ],
                ),
                Text(
                  date
                )
              ],
            )
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: productImage,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        productName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      Text(
                        'Rp. ${formatter.format(priceTotal)}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'x$qty',
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _isFinished(isFinished)
            ],
          ),
          const Gap(20)
        ],
      ),
    );
  }
}