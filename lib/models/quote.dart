class Quote {
  const Quote({
    required this.text,
    required this.author,
  });

  static const fallback = Quote(
    text: 'Small tasks completed daily create extraordinary results over time.',
    author: 'TaskFlow',
  );

  final String text;
  final String author;

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      text: json['content'] as String? ?? fallback.text,
      author: json['author'] as String? ?? fallback.author,
    );
  }
}
