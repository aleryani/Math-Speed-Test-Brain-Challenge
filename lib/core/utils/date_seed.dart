int dateSeed(DateTime date) {
  final year = date.year;
  final month = date.month;
  final day = date.day;
  return int.parse('${year.toString().padLeft(4, '0')}'
      '${month.toString().padLeft(2, '0')}'
      '${day.toString().padLeft(2, '0')}');
}
