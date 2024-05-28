import 'dart:convert';

import 'package:espw/app/controllers.dart';
import 'package:flutter/material.dart';

class SetSchedulePage extends StatefulWidget{
  const SetSchedulePage({super.key, required this.idToko});
  final String idToko;

  @override
  State<SetSchedulePage> createState() => _SetSchedulePageState();
}

class _SetSchedulePageState extends State<SetSchedulePage>{
  bool isOpen = false;
  @override
  void initState() {
    super.initState();
    shopById(widget.idToko).then((res) => setState(() {
      isOpen = json.decode(res.body)['data'].first['toko']['is_open'];
    }));
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Atur Jadwal',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600
          ),
        ),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 16),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => setState(() {
            isOpen = !isOpen;
          }),
          child: Card(
            color: Colors.transparent,
            elevation: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Buka sekarang'),
                Switch(
                  value: isOpen,
                  onChanged: (value) => setState(() {
                    isOpen = !isOpen;
                  }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}