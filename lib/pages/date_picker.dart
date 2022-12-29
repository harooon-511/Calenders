import 'package:calender/provider/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../routes.dart';

class DatePickerPage extends ConsumerWidget {
  const DatePickerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startDate = ref.watch<String>(startDateProvider);
    final endDate = ref.watch<String>(endDateProvider);

    void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
      final format = DateFormat('y年M月d日');
      ref
          .read(startDateProvider.notifier)
          .update((state) => format.format(args.value.startDate));
      ref
          .read(endDateProvider.notifier)
          .update((state) => format.format(args.value.endDate));
      debugPrint(startDate);
      debugPrint(endDate);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calender'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('${startDate} to ${endDate}'),
            SfDateRangePicker(
              view: DateRangePickerView.year,
              onSelectionChanged: _onSelectionChanged,
              selectionMode: DateRangePickerSelectionMode.range,
            ),
            ElevatedButton(
                onPressed: () => context.go(Routes.tableCalender),
                child: const Text('Check Availability')),
          ],
        ),
      ),
    );
  }
}
