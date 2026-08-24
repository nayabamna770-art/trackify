/// Represents supported currencies for subscription pricing.
///
/// CONCEPT: Using an enum with strict extension methods ensures strong typing
/// across the UI, preventing hardcoded currency symbols or formatting errors.
enum CurrencyType {
  usd,
  eur,
  gbp,
  pkr,
  inr,
}

extension CurrencyTypeX on CurrencyType {
  /// Returns the standard monetary symbol for rendering in UI cards.
  String get symbol {
    switch (this) {
      case CurrencyType.usd:
        return '\$';
      case CurrencyType.eur:
        return '€';
      case CurrencyType.gbp:
        return '£';
      case CurrencyType.pkr:
        return 'Rs ';
      case CurrencyType.inr:
        return '₹';
    }
  }

  /// Displays the official 3-letter currency code (e.g. for selection dropdowns).
  String get code => name.toUpperCase();

  /// Formats a double value with its corresponding currency symbol.
  String format(double amount) {
    return '$symbol${amount.toStringAsFixed(amount.truncateToDouble() == amount ? 0 : 2)}';
  }
}