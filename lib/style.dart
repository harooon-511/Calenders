import 'package:flutter/material.dart';

Widget CalenderStyle(DateTime day, Color color) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 250),
    margin: EdgeInsets.zero,
    decoration: BoxDecoration(
      border: Border.all(
        color: Colors.grey[400]!,
        width: 0.5,
      ),
    ),
    alignment: Alignment.center,
    child: Text(
      day.day.toString(),
      style: TextStyle(color: color),
    ),
  );
}

Widget DowStyle(String date) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 250),
    margin: EdgeInsets.zero,
    decoration: BoxDecoration(color: Colors.grey[600]),
    alignment: Alignment.center,
    // 高さの設定方法がわからない
    height: 40,
    child: Text(
      date.toString(),
      style: const TextStyle(
        color: Colors.white,
      ),
    ),
  );
}
