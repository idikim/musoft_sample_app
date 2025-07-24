import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedMonthProvider = StateProvider<int>((ref) => DateTime.now().month);