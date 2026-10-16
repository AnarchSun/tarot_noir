import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_config.dart';
import '../l10n/app_localizations.dart';
import '../services/solana_wallet_service.dart';

class BuiltinWalletPanel extends StatefulWidget {
  const BuiltinWalletPanel({
    required this.isPremiumUnlocked,
    required this.onOpenPremium,
    this.service,
    super.key,
  });

  final bool isPremiumUnlocked;
  final VoidCallback onOpenPremium;
  final SolanaWalletService? service;

  @visibleForTesting
  static SolanaWalletService? serviceOverride;

  @override
  State<BuiltinWalletPanel> createState() => _BuiltinWalletPanelState();
}

class _BuiltinWalletPanelState extends State<BuiltinWalletPanel> {
  late final SolanaWalletService _service =
      widget.service ??
      BuiltinWalletPanel.serviceOverride ??
      SolanaWalletService();
  WalletKeys? _keys;
  bool _loading = true;
  bool _busy = false;
  int? _lamports;
  int? _nfts;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final keys = await _service.loadKeys();
      if (!mounted) return;
      setState(() {
        _keys = keys;
        _loading = false;
      });
      if (keys != null) unawaited(_refresh());
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _snack(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _refresh() async {
    final keys = _keys;
    if (keys == null) return;
    setState(() => _busy = true);
    try {
      final lamports = await _service.balanceLamports(keys.address);
      final nfts = await _service.nftCount(keys.address);
      if (mounted) {
        setState(() {
          _lamports = lamports;
          _nfts = nfts;
        });
      }
    } catch (error) {
      if (mounted) {
        _snack(AppLocalizations.of(context)!.walletError(error.toString()));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _activate(String phrase) async {
    await _service.saveWallet(phrase);
    final keys = await SolanaWalletService.keysFromPhrase(phrase);
    if (!mounted) return;
    setState(() => _keys = keys);
    unawaited(_refresh());
  }

  Future<void> _create() async {
    final phrase = SolanaWalletService.generatePhrase();
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      isDismissible: false,
      builder: (_) =>
          _RecoveryPhraseSheet(phrase: phrase, confirmRequired: true),
    );
    if (confirmed == true) await _activate(phrase);
  }

  Future<void> _import() async {
    final phrase = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const _ImportSheet(),
    );
    if (phrase != null) await _activate(phrase);
  }

  Future<void> _showPhrase() async {
    final phrase = await _service.readPhrase();
    if (phrase == null || !mounted) return;
    await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _RecoveryPhraseSheet(phrase: phrase),
    );
  }

  Future<void> _remove() async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(l10n.walletRemoveConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.walletCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.walletRemoveAction),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await _service.removeWallet();
    if (mounted) {
      setState(() {
        _keys = null;
        _lamports = null;
        _nfts = null;
      });
    }
  }

  Future<void> _send() async {
    final keys = _keys;
    if (keys == null) return;
    final l10n = AppLocalizations.of(context)!;
    final request = await showModalBottomSheet<(String, double)>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const _SendSheet(),
    );
    if (request == null) return;
    setState(() => _busy = true);
    try {
      final signature = await _service.sendSol(
        from: keys,
        toAddress: request.$1,
        sol: request.$2,
      );
      _snack(l10n.walletSent(signature));
      unawaited(_refresh());
    } catch (error) {
      _snack(l10n.walletError(error.toString()));
      if (mounted) setState(() => _busy = false);
    }
  }

  void _receive(WalletKeys keys) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.walletReceiveHint),
              const SizedBox(height: 16),
              SelectableText(
                keys.address,
                key: const Key('wallet-receive-address'),
                style: const TextStyle(fontFamily: 'monospace'),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => _copy(keys.address),
                icon: const Icon(Icons.copy),
                label: Text(l10n.walletCopy),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _copy(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) _snack(AppLocalizations.of(context)!.walletCopied);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final keys = _keys;
    return Card(
      key: const Key('builtin-wallet'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.account_balance_wallet_outlined),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l10n.walletBuiltinTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_loading)
              const Center(child: CircularProgressIndicator())
            else if (keys == null && !widget.isPremiumUnlocked) ...[
              Text(l10n.walletLockedHint, style: const TextStyle(height: 1.4)),
              const SizedBox(height: 12),
              OutlinedButton(
                key: const Key('wallet-discover-premium'),
                onPressed: widget.onOpenPremium,
                child: Text(l10n.walletDiscoverPremium),
              ),
            ] else if (keys == null) ...[
              Text(l10n.walletCreateIntro, style: const TextStyle(height: 1.4)),
              const SizedBox(height: 12),
              FilledButton(
                key: const Key('wallet-create'),
                onPressed: _create,
                child: Text(l10n.walletCreate),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                key: const Key('wallet-import'),
                onPressed: _import,
                child: Text(l10n.walletImport),
              ),
            ] else ...[
              Text(
                l10n.walletAddress,
                style: const TextStyle(color: Color(0xFFB9AFBE), fontSize: 12),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      keys.address,
                      key: const Key('wallet-address'),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontFamily: 'monospace'),
                    ),
                  ),
                  IconButton(
                    tooltip: l10n.walletCopy,
                    onPressed: () => _copy(keys.address),
                    icon: const Icon(Icons.copy, size: 18),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${l10n.walletBalance}: ${_lamports == null ? '—' : '${(_lamports! / 1e9).toStringAsFixed(4)} SOL'}',
                key: const Key('wallet-balance'),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (_nfts != null) Text(l10n.walletNftCount(_nfts!)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.icon(
                    key: const Key('wallet-send'),
                    onPressed: _busy ? null : _send,
                    icon: const Icon(Icons.north_east),
                    label: Text(l10n.walletSend),
                  ),
                  OutlinedButton.icon(
                    key: const Key('wallet-receive'),
                    onPressed: () => _receive(keys),
                    icon: const Icon(Icons.south_west),
                    label: Text(l10n.walletReceive),
                  ),
                  IconButton(
                    tooltip: l10n.walletRefresh,
                    onPressed: _busy ? null : _refresh,
                    icon: _busy
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.refresh),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _showPhrase,
                child: Text(l10n.walletShowPhrase),
              ),
              TextButton(onPressed: _remove, child: Text(l10n.walletRemove)),
            ],
            const SizedBox(height: 8),
            Text(
              l10n.walletNetworkNote(AppConfig.solanaCluster),
              style: const TextStyle(fontSize: 11, color: Color(0xFFB9AFBE)),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecoveryPhraseSheet extends StatefulWidget {
  const _RecoveryPhraseSheet({
    required this.phrase,
    this.confirmRequired = false,
  });

  final String phrase;
  final bool confirmRequired;

  @override
  State<_RecoveryPhraseSheet> createState() => _RecoveryPhraseSheetState();
}

class _RecoveryPhraseSheetState extends State<_RecoveryPhraseSheet> {
  bool _saved = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final words = widget.phrase.split(' ');
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.walletRecoveryTitle,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(l10n.walletRecoveryWarning, style: const TextStyle(height: 1.4)),
          const SizedBox(height: 16),
          Wrap(
            key: const Key('wallet-phrase'),
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var i = 0; i < words.length; i++)
                Chip(label: Text('${i + 1}. ${words[i]}')),
            ],
          ),
          const SizedBox(height: 12),
          if (widget.confirmRequired) ...[
            CheckboxListTile(
              key: const Key('wallet-saved-check'),
              value: _saved,
              onChanged: (v) => setState(() => _saved = v ?? false),
              title: Text(l10n.walletSavedConfirm),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            FilledButton(
              key: const Key('wallet-activate'),
              onPressed: _saved ? () => Navigator.pop(context, true) : null,
              child: Text(l10n.walletActivate),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.walletCancel),
            ),
          ] else
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.walletClose),
            ),
        ],
      ),
    );
  }
}

class _ImportSheet extends StatefulWidget {
  const _ImportSheet();

  @override
  State<_ImportSheet> createState() => _ImportSheetState();
}

class _ImportSheetState extends State<_ImportSheet> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final phrase = SolanaWalletService.normalizePhrase(_controller.text);
    if (phrase == null) {
      setState(
        () => _error = AppLocalizations.of(context)!.walletInvalidPhrase,
      );
      return;
    }
    Navigator.pop(context, phrase);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        24 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.walletImportTitle,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            TextField(
              key: const Key('wallet-import-field'),
              controller: _controller,
              minLines: 3,
              maxLines: 4,
              autocorrect: false,
              enableSuggestions: false,
              decoration: InputDecoration(
                hintText: l10n.walletImportHint,
                errorText: _error,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              key: const Key('wallet-import-submit'),
              onPressed: _submit,
              child: Text(l10n.walletImportAction),
            ),
          ],
        ),
      ),
    );
  }
}

class _SendSheet extends StatefulWidget {
  const _SendSheet();

  @override
  State<_SendSheet> createState() => _SendSheetState();
}

class _SendSheetState extends State<_SendSheet> {
  final _to = TextEditingController();
  final _amount = TextEditingController();
  String? _toError;
  String? _amountError;

  @override
  void dispose() {
    _to.dispose();
    _amount.dispose();
    super.dispose();
  }

  void _submit() {
    final l10n = AppLocalizations.of(context)!;
    final address = _to.text.trim();
    final amount = double.tryParse(_amount.text.trim().replaceAll(',', '.'));
    setState(() {
      _toError = isValidSolanaAddress(address)
          ? null
          : l10n.walletInvalidAddress;
      _amountError = amount == null || amount <= 0
          ? l10n.walletInvalidAmount
          : null;
    });
    if (_toError == null && _amountError == null) {
      Navigator.pop(context, (address, amount!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        24 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.walletSend,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            TextField(
              key: const Key('wallet-send-to'),
              controller: _to,
              autocorrect: false,
              decoration: InputDecoration(
                labelText: l10n.walletRecipient,
                errorText: _toError,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              key: const Key('wallet-send-amount'),
              controller: _amount,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: l10n.walletAmount,
                errorText: _amountError,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              key: const Key('wallet-send-submit'),
              onPressed: _submit,
              child: Text(l10n.walletSendAction),
            ),
          ],
        ),
      ),
    );
  }
}
