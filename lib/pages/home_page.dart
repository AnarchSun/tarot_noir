import 'dart:async';

import 'package:flutter/material.dart';

import '../controllers/tarot_controller.dart';
import '../l10n/app_localizations.dart';
import '../repositories/local_repository.dart';
import 'reading_page.dart';
import 'journal_page.dart';
import 'premium_page.dart';

class TarotNoirHome extends StatefulWidget {
  const TarotNoirHome({super.key, this.controller});
  final TarotController? controller;
  @override
  State<TarotNoirHome> createState() => _TarotNoirHomeState();
}

class _TarotNoirHomeState extends State<TarotNoirHome>
    with WidgetsBindingObserver {
  int _tab = 0;
  late final TarotController _controller;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ??
        TarotController(repository: PreferencesLocalRepository());
    WidgetsBinding.instance.addObserver(this);
    unawaited(_controller.initialize());
    _scheduleMidnight();
  }

  void _scheduleMidnight() {
    _timer?.cancel();
    final now = _controller.clock();
    _timer = Timer(
      DateTime(now.year, now.month, now.day + 1).difference(now),
      () async {
        await _controller.refreshDay();
        if (mounted) _scheduleMidnight();
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_controller.refreshDay());
      _scheduleMidnight();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _controller,
    builder: (context, _) {
      final l10n = AppLocalizations.of(context)!;
      if (!_controller.ready) {
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: _controller.storageError
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(l10n.storageLoadError),
                        ),
                        FilledButton(
                          onPressed: _controller.busy
                              ? null
                              : _controller.initialize,
                          child: Text(l10n.retry),
                        ),
                      ],
                    )
                  : const CircularProgressIndicator(),
            ),
          ),
        );
      }
      final state = _controller.state;
      final pages = [
        ReadingPage(
          card: state.card,
          onDraw: _controller.draw,
          premium: _controller.policy.premium,
          busy: _controller.busy,
        ),
        JournalPage(
          entries: state.journal,
          onSave: _controller.saveNote,
          controller: _controller,
        ),
        const PremiumPage(),
      ];
      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              if (_controller.storageError)
                MaterialBanner(
                  content: Text(l10n.storageSaveError),
                  actions: [
                    TextButton(
                      onPressed: _controller.busy
                          ? null
                          : _controller.dismissStorageError,
                      child: Text(
                        MaterialLocalizations.of(context).closeButtonTooltip,
                      ),
                    ),
                  ],
                ),
              Expanded(child: pages[_tab]),
            ],
          ),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _tab,
          onDestinationSelected: (index) {
            setState(() => _tab = index);
            unawaited(_controller.refreshDay());
          },
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.auto_awesome_outlined),
              selectedIcon: const Icon(Icons.auto_awesome),
              label: l10n.reading,
            ),
            NavigationDestination(
              icon: const Icon(Icons.menu_book_outlined),
              selectedIcon: const Icon(Icons.menu_book),
              label: l10n.journal,
            ),
            NavigationDestination(
              icon: const Icon(Icons.workspace_premium_outlined),
              selectedIcon: const Icon(Icons.workspace_premium),
              label: l10n.premium,
            ),
          ],
        ),
      );
    },
  );
}
