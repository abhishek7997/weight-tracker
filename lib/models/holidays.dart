class Holidays {
  final Map<DateTime, List> _holidays = {
    DateTime(2020, 1, 1): ['New Year\'s Day'],
  };

  Map<DateTime, List> getHolidays() {
    return _holidays;
  }
}
