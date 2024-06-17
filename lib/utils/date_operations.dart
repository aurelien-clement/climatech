
// utils/date_operations.dart

/// Adds a full day to the given date, preventing hour offset due to time changes.
DateTime addDay(DateTime srcDate, int amount) {
  return srcDate.add(Duration(days: amount)).toUtc().toLocal().subtract(
    srcDate.toUtc().toLocal().difference(DateTime(srcDate.year, srcDate.month, srcDate.day))
  );
}

/// Subtracts a full day from the given date, preventing hour offset due to time changes.
DateTime subDay(DateTime srcDate, int amount) {
  return srcDate.subtract(Duration(days: amount)).toUtc().toLocal().subtract(
    srcDate.toUtc().toLocal().difference(DateTime(srcDate.year, srcDate.month, srcDate.day))
  );
}
