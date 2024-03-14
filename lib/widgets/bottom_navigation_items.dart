import 'package:flutter/material.dart';

BottomNavigationBarItem bottomnavitem(IconData icon, IconData activeIcon, String label){
  return BottomNavigationBarItem(
    icon: Icon(
        icon
    ),
    activeIcon: Icon(
        activeIcon
    ),
    label: label,
  );
}