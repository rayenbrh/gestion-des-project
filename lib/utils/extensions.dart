import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

/// String extensions
extension StringExtensions on String {
  /// Capitalize first letter
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// Check if string is a valid email
  bool get isValidEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  /// Check if string is a valid phone number (French format)
  bool get isValidPhoneNumber {
    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
    return phoneRegex.hasMatch(replaceAll(RegExp(r'[\s-]'), ''));
  }
}

/// DateTime extensions
extension DateTimeExtensions on DateTime {
  /// Format date to dd/MM/yyyy
  String toDateString() {
    return DateFormat('dd/MM/yyyy').format(this);
  }

  /// Format date to dd/MM/yyyy HH:mm
  String toDateTimeString() {
    return DateFormat('dd/MM/yyyy HH:mm').format(this);
  }

  /// Format time to HH:mm
  String toTimeString() {
    return DateFormat('HH:mm').format(this);
  }

  /// Format date to readable string (ex: "Aujourd'hui", "Hier", "15 Nov 2025")
  String toReadableDate() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCheck = DateTime(year, month, day);

    if (dateToCheck == today) {
      return "Aujourd'hui";
    } else if (dateToCheck == yesterday) {
      return 'Hier';
    } else if (year == now.year) {
      return DateFormat('d MMM', 'fr_FR').format(this);
    } else {
      return DateFormat('d MMM yyyy', 'fr_FR').format(this);
    }
  }

  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if date is this week
  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 7));
    return isAfter(startOfWeek) && isBefore(endOfWeek);
  }

  /// Get start of day
  DateTime get startOfDay {
    return DateTime(year, month, day);
  }

  /// Get end of day
  DateTime get endOfDay {
    return DateTime(year, month, day, 23, 59, 59, 999);
  }

  /// Calculate difference in days
  int differenceInDays(DateTime other) {
    final difference = startOfDay.difference(other.startOfDay);
    return difference.inDays;
  }
}

/// BuildContext extensions
extension BuildContextExtensions on BuildContext {
  /// Get theme
  ThemeData get theme => Theme.of(this);

  /// Get text theme
  TextTheme get textTheme => theme.textTheme;

  /// Get color scheme
  ColorScheme get colorScheme => theme.colorScheme;

  /// Get screen size
  Size get screenSize => MediaQuery.of(this).size;

  /// Get screen width
  double get screenWidth => screenSize.width;

  /// Get screen height
  double get screenHeight => screenSize.height;

  /// Check if screen is mobile
  bool get isMobile => screenWidth < 600;

  /// Check if screen is tablet
  bool get isTablet => screenWidth >= 600 && screenWidth < 1200;

  /// Check if screen is desktop
  bool get isDesktop => screenWidth >= 1200;

  /// Show snackbar
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? colorScheme.error : null,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Show error snackbar
  void showErrorSnackBar(String message) {
    showSnackBar(message, isError: true);
  }

  /// Show success snackbar
  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

/// List extensions
extension ListExtensions<T> on List<T> {
  /// Safely get element at index
  T? getOrNull(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }

  /// Check if list is null or empty
  bool get isNullOrEmpty => isEmpty;

  /// Check if list is not null and not empty
  bool get isNotNullOrEmpty => isNotEmpty;
}

/// Double extensions
extension DoubleExtensions on double {
  /// Format as currency (€)
  String toCurrency() {
    return NumberFormat.currency(
      locale: 'fr_FR',
      symbol: '€',
      decimalDigits: 2,
    ).format(this);
  }

  /// Format as percentage
  String toPercentage({int decimals = 0}) {
    return '${toStringAsFixed(decimals)}%';
  }

  /// Round to decimals
  double roundToDecimals(int decimals) {
    final mod = 10.0 * decimals;
    return ((this * mod).round().toDouble() / mod);
  }
}

/// Duration extensions
extension DurationExtensions on Duration {
  /// Format duration to readable string (ex: "2h 30min")
  String toReadableString() {
    final hours = inHours;
    final minutes = inMinutes.remainder(60);

    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}min';
    } else if (hours > 0) {
      return '${hours}h';
    } else if (minutes > 0) {
      return '${minutes}min';
    } else {
      return '0min';
    }
  }

  /// Convert hours to work days
  double toWorkDays({double hoursPerDay = 7.0}) {
    return inHours / hoursPerDay;
  }
}
