import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget{
  const ProfilePicture({super.key, required this.imageURL, this.onTap});
  final String imageURL;
  final void Function()? onTap;

  Widget _isContainProfilePicture(){
    if(imageURL.isNotEmpty){
      return CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(imageURL),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset('assets/image/profile.png', width: 40, height: 40, fit: BoxFit.cover),
      );
    }
  }

  @override
  Widget build(BuildContext context){
    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: GestureDetector(
        onTap: onTap,
        child: _isContainProfilePicture(),
      ),
    );
  }
}