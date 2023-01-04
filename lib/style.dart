import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'colors.dart';

Widget CalenderStyle(DateTime day, Color color) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 250),
    margin: EdgeInsets.zero,
    decoration: BoxDecoration(
      border: Border.all(
        color: MyColors.secondary1,
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
    decoration: const BoxDecoration(
      color: MyColors.background1,
    ),
    alignment: Alignment.center,
    child: Text(
      date.toString(),
      style: const TextStyle(color: Colors.white, fontSize: 20),
    ),
  );
}

const calenderHeaderStyle = HeaderStyle(
  decoration: BoxDecoration(
      color: MyColors.background1,
      border: Border(bottom: BorderSide(color: MyColors.secondary1, width: 1))),
  headerPadding: EdgeInsets.symmetric(vertical: 0.0),
  titleCentered: true,
  titleTextStyle: TextStyle(color: MyColors.primary1, fontSize: 20),
  leftChevronIcon:
      Icon(Icons.chevron_left, size: 40, color: MyColors.secondary1),
  rightChevronIcon:
      Icon(Icons.chevron_right, size: 40, color: MyColors.secondary1),
  formatButtonVisible: false,
);
