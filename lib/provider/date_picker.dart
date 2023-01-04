import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final focusOnDayProvider =
    ChangeNotifierProvider((ref) => selectedDayController());

class selectedDayController extends ChangeNotifier {
  DateTime? selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  DateTime? rangeStart = null;
  DateTime? rangeEnd = null;
  List pickedDateList = [];

  void updateSelectedDay(DateTime? value) {
    selectedDay = value;
    notifyListeners();
  }

  void updateFocusedDay(DateTime value) {
    focusedDay = value;
    notifyListeners();
  }

  void updateRangeStart(DateTime? value) {
    rangeStart = value;
    notifyListeners();
  }

  void updateRangeEnd(DateTime? value) {
    rangeEnd = value;
    notifyListeners();
  }

  void generatePickedDateList(List list) {
    pickedDateList = [];
    pickedDateList.addAll(list);
    notifyListeners();
  }
}
