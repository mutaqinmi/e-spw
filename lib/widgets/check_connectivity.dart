import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

void checkConnectivity(BuildContext context) async {
  if(!context.mounted) return;
  StreamBuilder(
    stream: Connectivity().onConnectivityChanged,
    builder: (BuildContext context, AsyncSnapshot response){
      if(!response.hasData){
        showModalBottomSheet(
          isDismissible: false,
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

      return const CircularProgressIndicator();
    }
  );
}