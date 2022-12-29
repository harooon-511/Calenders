import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final startDateProvider = StateProvider<String>((ref) => 'start');
final endDateProvider = StateProvider<String>((ref) => 'end');
