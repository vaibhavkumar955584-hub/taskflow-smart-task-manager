import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/quote_provider.dart';

class QuotePanel extends StatefulWidget {
  const QuotePanel({super.key});

  @override
  State<QuotePanel> createState() => _QuotePanelState();
}

class _QuotePanelState extends State<QuotePanel> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuoteProvider>().loadQuote();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuoteProvider>(
      builder: (context, quoteState, _) {
        final quote = quoteState.quote;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: quoteState.isLoading
                  ? const SizedBox(
                      height: 76,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : Column(
                      key: ValueKey(quote.text),
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.auto_awesome_outlined),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Daily spark',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            IconButton(
                              tooltip: 'Refresh quote',
                              onPressed: quoteState.loadQuote,
                              icon: const Icon(Icons.refresh_rounded),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '"${quote.text}"',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '- ${quote.author}',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}
