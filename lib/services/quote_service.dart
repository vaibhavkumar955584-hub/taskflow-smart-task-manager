import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/quote.dart';

class QuoteService {
  QuoteService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static final Uri _quoteUri = Uri.parse('https://api.quotable.io/random');

  Future<Quote> fetchQuote() async {
    try {
      final response = await _client.get(_quoteUri).timeout(
            const Duration(seconds: 12),
          );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('Quote service returned ${response.statusCode}.');
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return Quote.fromJson(body);
    } on Exception catch (error) {
      throw Exception('Failed to fetch quote: ${error.toString()}');
    }
  }
}
