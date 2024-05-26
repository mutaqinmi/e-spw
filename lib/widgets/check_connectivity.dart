import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:gap/gap.dart';

void checkConnectivity(BuildContext context) async {
  final List<ConnectivityResult> connectivity = await Connectivity().checkConnectivity();
  if(connectivity.contains(ConnectivityResult.mobile) || connectivity.contains(ConnectivityResult.wifi)){
    return null;
  }

  if(!context.mounted) return;
  return showModalBottomSheet(
    context: context,
    builder: (BuildContext context) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off_outlined,
              size: 200,
            ),
            Gap(10),
            Text(
              'Tidak ada koneksi internet!',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20
              ),
            ),
            Gap(5),
            Text(
              'Periksa koneksi internet anda dan coba lagi!'
            ),
          ],
        ),
      ),
    )
  );
}