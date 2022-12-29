import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final eventsListProvider =
    ChangeNotifierProvider((ref) => EventsListController());

class EventsListController extends ChangeNotifier {
  Map<DateTime, List> eventsList = {};

  // 予約データ(y-M-d形式の場合)
  // 本来はAPIから届いたデータがこんな感じで返ってくるはず。この形に落とし込む
  List<String> weddingDress = <String>[
    '2022-12-31',
    '2023-01-01',
    '2023-01-05',
    '2023-01-20'
  ];
  List<String> suits = <String>[
    '2022-11-30',
    '2023-01-01',
    '2023-01-06',
    '2023-01-10'
  ];
}
