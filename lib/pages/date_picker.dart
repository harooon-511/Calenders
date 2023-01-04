import 'package:calender/provider/date_picker.dart';
import 'package:calender/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../style.dart';

class DatePickerPage extends ConsumerWidget {
  const DatePickerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusOnDay = ref.watch(focusOnDayProvider);

    var _calendarFormat = CalendarFormat.month;
    var _rangeSelectionMode = RangeSelectionMode.toggledOn;
    debugPrint('スタート');
    debugPrint(focusOnDay.rangeStart.toString());
    debugPrint('終わり');
    debugPrint(focusOnDay.rangeEnd.toString());
    debugPrint('セレクト');
    debugPrint(focusOnDay.focusedDay.toString());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calender'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('日付選択'),
            ChosenDateText(focusOnDay),
            // Expanded(child:
            SizedBox(
              height: 400,
              width: 350,
              child: TableCalendar(
                locale: 'ja_JP',
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: focusOnDay.focusedDay,
                headerStyle: calenderHeaderStyle,
                daysOfWeekHeight: 50,
                rowHeight: 50,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) {
                  return isSameDay(
                    day,
                    focusOnDay.selectedDay,
                  );
                },
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(focusOnDay.selectedDay, selectedDay)) {
                    focusOnDay.updateSelectedDay(selectedDay);
                    focusOnDay.updateFocusedDay(selectedDay);
                    focusOnDay.updateRangeStart(null);
                    focusOnDay.updateRangeEnd(null);
                    _rangeSelectionMode = RangeSelectionMode.toggledOff;
                  }
                },
                rangeSelectionMode: _rangeSelectionMode,
                rangeStartDay: focusOnDay.rangeStart,
                rangeEndDay: focusOnDay.rangeEnd,
                onRangeSelected: (start, end, focusedDay) {
                  focusOnDay.updateRangeStart(start);
                  focusOnDay.updateRangeEnd(end);
                  _rangeSelectionMode = RangeSelectionMode.toggledOn;
                },
                onPageChanged: focusOnDay.updateFocusedDay,
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    if (day.isBefore(DateTime.now())) {
                      return DefaultPastStyle(day, Colors.black87);
                    } else {
                      return DefaultStyle(day, Colors.black87);
                    }
                  },
                  // todayBuilder: (context, day, focusedDay) {
                  //   return AnimatedContainer(
                  //     duration: const Duration(milliseconds: 250),
                  //     margin: EdgeInsets.zero,
                  //     decoration: BoxDecoration(
                  //       border: Border.all(
                  //         color: Colors.orange,
                  //       ),
                  //     ),
                  //     alignment: Alignment.center,
                  //     child: Text(
                  //       day.day.toString(),
                  //       style: const TextStyle(
                  //         color: Colors.black87,
                  //       ),
                  //     ),
                  //   );
                  // },
                  dowBuilder: (context, day) {
                    final locale = Localizations.localeOf(context).languageCode;
                    final dowText = const DaysOfWeekStyle()
                            .dowTextFormatter
                            ?.call(day, locale) ??
                        DateFormat.E(locale).format(day);

                    return DowStyle(dowText);
                  },
                  disabledBuilder: (context, day, focusedDay) {
                    return DefaultPastStyle(day, Colors.grey);
                  },
                  // 前の月末で今月に出てきてる日付とか
                  outsideBuilder: (context, day, focusedDay) {
                    return DefaultPastStyle(day, Colors.grey);
                  },
                ),
              ),
            ),
            // ),
            ElevatedButton(
                onPressed: () => context.go(Routes.tableCalender),
                child: const Text('Check Avalability'))
          ],
        ),
      ),
    );
  }
}

// ignore: avoid_annotating_with_dynamic
Widget ChosenDateText(dynamic focusOnDay) {
  final format = DateFormat('y/M/d');
  if (focusOnDay.rangeStart != null) {
    if (focusOnDay.rangeEnd != null) {
      final daysLength =
          focusOnDay.rangeEnd.difference(focusOnDay.rangeStart).inDays + 1;
      final dateList = List<DateTime>.generate(
          daysLength, (i) => focusOnDay.rangeStart.add(Duration(days: i)));
      focusOnDay.generatePickedDateList(dateList);
      return Column(
        children: [
          Text(
              // ignore: lines_longer_than_80_chars
              '${format.format(focusOnDay.rangeStart).toString()} 〜 ${format.format(focusOnDay.rangeEnd).toString()}'),
          // 選択した範囲のdatetimeを全て取り出してリストに格納した
          Text(focusOnDay.pickedDateList.toString())
        ],
      );
    } else {
      final day = <DateTime>[focusOnDay.rangeStart];
      focusOnDay.generatePickedDateList(day);
      return Column(
        children: [
          Text('${format.format(focusOnDay.rangeStart).toString()}'),
          Text(focusOnDay.pickedDateList.toString())
        ],
      );
    }
  } else {
    return const Text('日付を選択してください');
  }
}
