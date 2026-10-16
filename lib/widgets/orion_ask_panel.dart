import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/journal_entry.dart';
import '../models/orion_answer.dart';

class OrionAskPanel extends StatefulWidget {
  const OrionAskPanel({
    required this.cards,
    this.requiresAd = false,
    this.onRequestAd,
    this.onSaved,
    super.key,
  });

  final List<OrionQuestionCard> cards;
  final bool requiresAd;
  final Future<bool> Function()? onRequestAd;
  final Future<void> Function(OrionQa qa)? onSaved;

  @override
  State<OrionAskPanel> createState() => _OrionAskPanelState();
}

class _OrionAskPanelState extends State<OrionAskPanel> {
  final _controller = TextEditingController();
  final List<OrionQa> _qa = [];
  late bool _unlocked = !widget.requiresAd;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _unlock() async {
    final allowed = await widget.onRequestAd?.call() ?? true;
    if (allowed && mounted) setState(() => _unlocked = true);
  }

  Future<void> _ask(String lang) async {
    final question = _controller.text.trim();
    if (question.isEmpty) return;
    final qa = OrionQa(
      question: question,
      answer: OrionAnswerCatalog.answer(question, widget.cards, lang),
      createdAt: DateTime.now(),
    );
    setState(() {
      _qa.insert(0, qa);
      _controller.clear();
    });
    await widget.onSaved?.call(qa);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const gold = TextStyle(
      color: Color(0xFFD4AF59),
      fontWeight: FontWeight.w700,
      letterSpacing: 1.2,
    );
    if (!_unlocked) {
      return Container(
        key: const Key('orion-ask-locked'),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF211839),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFD4AF59).withValues(alpha: .55),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.spreadAskTitle, style: gold),
            const SizedBox(height: 8),
            Text(l10n.orionAskLockedBody, style: const TextStyle(height: 1.4)),
            const SizedBox(height: 12),
            FilledButton.icon(
              key: const Key('orion-ask-unlock'),
              onPressed: _unlock,
              icon: const Icon(Icons.play_circle_outline),
              label: Text(l10n.spreadAiWatchAd),
            ),
          ],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.spreadAskTitle, style: gold),
        const SizedBox(height: 8),
        TextField(
          key: const Key('spread-ai-question'),
          controller: _controller,
          minLines: 2,
          maxLines: 4,
          maxLength: 300,
          decoration: InputDecoration(hintText: l10n.spreadAskHint),
        ),
        FilledButton.icon(
          key: const Key('spread-ai-ask'),
          onPressed: () => _ask(l10n.localeName),
          icon: const Icon(Icons.auto_awesome),
          label: Text(l10n.spreadAskAction),
        ),
        const SizedBox(height: 12),
        for (final qa in _qa)
          Container(
            key: const Key('spread-ai-answer'),
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF211839),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  qa.question,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Color(0xFFB9AFBE),
                  ),
                ),
                const SizedBox(height: 8),
                Text(qa.answer, style: const TextStyle(height: 1.45)),
                const SizedBox(height: 8),
                Text(
                  l10n.orionSavedToJournal,
                  style: const TextStyle(
                    color: Color(0xFFB9AFBE),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
