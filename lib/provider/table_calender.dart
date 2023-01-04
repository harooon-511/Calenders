import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final eventsListProvider =
    ChangeNotifierProvider((ref) => EventsListController());

class EventsListController extends ChangeNotifier {
  Map<DateTime, List> eventsList = {};

  // 予約データ(y-M-d形式の場合)
  // 本来はAPIから届いたデータがこんな感じで返ってくるはず。この形に落とし込む

  List<String> cross = <String>[
    '2023-01-05',
    '2023-01-20',
    '2023-01-21',
    '2023-01-22'
  ];
  List<String> triangle = <String>[
    '2023-01-04',
    '2023-01-05',
    '2023-01-06',
    '2023-01-07',
    '2023-01-10'
  ];
}
