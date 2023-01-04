import 'dart:collection';

// import 'package:calender/colors.dart';
import 'package:calender/provider/date_picker.dart';
import 'package:calender/provider/table_calender.dart';
import 'package:calender/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../style.dart';

class TableCalenderPage extends ConsumerWidget {
  const TableCalenderPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusOnDay = ref.watch(focusOnDayProvider);
    var _calendarFormat = CalendarFormat.month;
    // 実際はList Itemなどで作成し、APIから選択して持ってきたアイテムの予約データのみを取ってこれる
    // (フィルタリングはrepositoryで行う)
    var _eventsList = ref.watch(eventsListProvider).eventsList;

    List cross = ref.read(eventsListProvider).cross;
    List triangle = ref.read(eventsListProvider).triangle;

    // String→DateTime変換
    final _dateFormatter = DateFormat('y-M-d');
    DateTime getDatetime(String datetimeStr) {
      DateTime? result = DateTime.now();
      try {
        result = _dateFormatter.parseStrict(datetimeStr);
      } on Exception catch (e) {
        debugPrint(e.toString());
        result = null; // 変換に失敗した場合の処理
      }
      return result!;
    }

    for (var i = 0; i < triangle.length; i++) {
      final element = getDatetime(triangle[i]);
      ref.watch(eventsListProvider).eventsList[element] = ['triangle'];
    }
    for (var i = 0; i < cross.length; i++) {
      final element = getDatetime(cross[i]);
      ref.watch(eventsListProvider).eventsList[element] = ['cross'];
    }

    // DateTime型から20210930の8桁のint型へ変換
    int getHashCode(DateTime key) {
      return key.day * 1000000 + key.month * 10000 + key.year;
    }

    final _events = LinkedHashMap<DateTime, List>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(_eventsList);

    List getEventForDay(DateTime day) {
      return _events[day] ?? [];
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calender'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('アイテム詳細マスタ/マル&三角&バツ'),
            // Expanded(child:
            SizedBox(
              height: 420,
              width: 350,
              child: TableCalendar(
                locale: 'ja_JP',
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: focusOnDay.focusedDay,
                headerStyle: calenderHeaderStyle,
                daysOfWeekHeight: 50,
                rowHeight: 50,
                eventLoader: getEventForDay,
                calendarFormat: _calendarFormat,
                startingDayOfWeek: StartingDayOfWeek.monday,
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
                  }
                },
                onPageChanged: focusOnDay.updateFocusedDay,
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    if (day.isBefore(DateTime.now())) {
                      return DefaultPastStyle(day, Colors.black87);
                    } else {
                      return DefaultStyle(day, Colors.black87);
                    }
                  },
                  markerBuilder: (context, date, events) {
                    if (events.isNotEmpty) {
                      if (events[0] == 'cross') {
                        if (date.isAfter(DateTime.now()) ||
                            // 日付のみの比較
                            date.difference(DateTime.now()).inDays == 0 &&
                                DateTime.now().day == DateTime.now().day) {
                          return _buildBookedMarker(date, events);
                        } else {
                          return const Text(' ');
                        }
                      } else if (events[0] == 'triangle') {
                        if (date.isAfter(DateTime.now()) ||
                            // 日付のみの比較
                            date.difference(DateTime.now()).inDays == 0 &&
                                DateTime.now().day == DateTime.now().day) {
                          return _buildDifferentSizeMarker(date, events);
                        } else {
                          return const Text(' ');
                        }
                      }
                    } else if (events.isEmpty) {
                      if (date.isAfter(DateTime.now()) ||
                          // 日付のみの比較
                          date.difference(DateTime.now()).inDays == 0 &&
                              DateTime.now().day == DateTime.now().day) {
                        return _buildAvairableMarker(date, events);
                      } else {
                        return const Text(' ');
                      }
                    }
                    return const Text(' ');
                  },
                  selectedBuilder: (context, day, focusedDay) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: EdgeInsets.zero,
                      decoration: const BoxDecoration(
                        color: Color(0xffFFA800),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        day.day.toString(),
                        style: const TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                    );
                  },
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
                onPressed: () => context.go(Routes.datePicker),
                child: const Text('Choose date'))
          ],
        ),
      ),
    );
  }
}

Widget _buildBookedMarker(DateTime date, List events) {
  return Positioned(
    child: Container(
      child: const Center(
        child: Icon(
          Icons.close,
          // color: MyColors.secondary2,
          color: Colors.blue,
          size: 50.0,
        ),
      ),
    ),
  );
}

Widget _buildAvairableMarker(DateTime date, List events) {
  return Positioned(
    child: Container(
      child: const Center(
        child: Icon(
          Icons.radio_button_unchecked,
          color: Color(0xffFF6E6E),
          size: 50.0,
        ),
      ),
    ),
  );
}

Widget _buildDifferentSizeMarker(DateTime date, List events) {
  return Positioned(
    child: Container(
      child: const Center(
        child: Icon(
          Icons.change_history,
          color: Color(0xff70707080),
          size: 50.0,
        ),
      ),
    ),
  );
}

Widget Reputation(DateTime date, Widget widget) {
  if (date.isAfter(DateTime.now()) ||
      // 日付のみの比較
      date.difference(DateTime.now()).inDays == 0 &&
          DateTime.now().day == DateTime.now().day) {
    return widget;
  } else {
    return const Text(' ');
  }
}
