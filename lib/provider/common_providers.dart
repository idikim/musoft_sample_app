import 'package:flutter_riverpod/flutter_riverpod.dart';

final penaltyViewModeProvider = StateProvider<bool>((ref) => true);
final selectedMonthProvider = StateProvider<int>((ref) => DateTime.now().month);
