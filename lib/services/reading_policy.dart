import 'dart:math';

import '../app_config.dart';

int dailyCardIndex(DateTime date, int deckLength) =>
    Random(DateTime.utc(date.year, date.month, date.day).millisecondsSinceEpoch)
        .nextInt(deckLength);

DateTime calendarDay(DateTime date) =>
    DateTime(date.year, date.month, date.day);

/// Only a development preview. Never persist this as a purchased entitlement.
class ReadingPolicy {
  const ReadingPolicy({this.premium = AppConfig.premiumEnabled});
  final bool premium;
  bool get canRedraw => premium;
}
