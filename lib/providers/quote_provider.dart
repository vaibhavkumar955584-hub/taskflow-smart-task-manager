import 'package:flutter/foundation.dart';

import '../models/quote.dart';
import '../services/quote_service.dart';

class QuoteProvider extends ChangeNotifier {
  QuoteProvider(this._quoteService);

  final QuoteService _quoteService;

  Quote _quote = Quote.fallback;
  bool _isLoading = false;
  String? _error;

  Quote get quote => _quote;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadQuote() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _quote = await _quoteService.fetchQuote();
      _error = null;
    } catch (error) {
      _quote = Quote.fallback;
      _error = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
