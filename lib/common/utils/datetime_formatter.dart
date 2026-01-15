import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

String formatDateTime(String rawDate, BuildContext context) {
  final dateTime = DateTime.parse(rawDate).toLocal();
  final locale = Localizations.localeOf(context).toString();
  final formatter = DateFormat.yMd(locale).add_Hm();
  return formatter.format(dateTime);
}
