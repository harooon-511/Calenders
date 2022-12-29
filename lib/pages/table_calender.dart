import 'dart:collection';

import 'package:calender/provider/table_calender.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class TableCalenderPage extends ConsumerWidget {
  const TableCalenderPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 実際はList Itemなどで作成し、APIから選択して持ってきたアイテムの予約データのみを取ってこれる
    // (フィルタリングはrepositoryで行う)
    var _eventsList = ref.watch(eventsListProvider).eventsList;

    List weddingDress = ref.read(eventsListProvider).weddingDress;
    List suits = ref.read(eventsListProvider).suits;

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

    for (var i = 0; i < weddingDress.length; i++) {
      final element = getDatetime(weddingDress[i]);
      ref.watch(eventsListProvider).eventsList[element] = ['試着'];
    }
    for (var i = 0; i < suits.length; i++) {
      final element = getDatetime(suits[i]);
      ref.watch(eventsListProvider).eventsList[element] = ['試着'];
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
            const Text('Welcome!'),
            TableCalendar(
              locale: 'ja_JP',
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: DateTime.now(),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
              ),
              eventLoader: getEventForDay,
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (events.isNotEmpty && date.isAfter(DateTime.now())) {
                    return _buildEventsMarker(date, events);
                  } else if (events.isEmpty && date.isAfter(DateTime.now())) {
                    return _buildNonEventsMarker(date, events);
                  }
                  return const Text('done');
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget _buildEventsMarker(DateTime date, List events) {
  return Positioned(
    right: 12,
    bottom: 10,
    child: Container(
      width: 32.0,
      height: 32.0,
      child: const Center(
        child: Icon(
          Icons.close,
          color: Colors.blue,
          size: 36.0,
        ),
      ),
    ),
  );
}

Widget _buildNonEventsMarker(DateTime date, List events) {
  return Positioned(
    right: 12,
    bottom: 10,
    child: Container(
      // duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.red,
          width: 2,
        ),
      ),
      width: 32.0,
      height: 32.0,
    ),
  );
}
