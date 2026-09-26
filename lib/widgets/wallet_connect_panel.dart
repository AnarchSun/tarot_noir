import 'dart:async';

import 'package:flutter/material.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app_config.dart';
import '../l10n/app_localizations.dart';

class WalletConnectPanel extends StatefulWidget {
  const WalletConnectPanel({super.key, this.onConnected});

  final ValueChanged<String>? onConnected;

  @override
  State<WalletConnectPanel> createState() => _WalletConnectPanelState();
}

class _WalletConnectPanelState extends State<WalletConnectPanel> {
  static const _solanaDevnetChain = 'solana:EtWTRABZaYq6iMfeYKouRu166VU2xqa1';
  static bool _networksConfigured = false;

  ReownAppKitModal? _modal;
  bool _initializing = false;
  String? _error;
  String? _notifiedAddress;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (AppConfig.isWalletConnectConfigured &&
        _modal == null &&
        !_initializing) {
      _initialize();
    }
  }

  void _configureSolanaDevnet() {
    if (_networksConfigured) return;
    for (final namespace
        in ReownAppKitModalNetworks.getAllSupportedNamespaces().toList()) {
      ReownAppKitModalNetworks.removeSupportedNetworks(namespace);
    }
    ReownAppKitModalNetworks.addSupportedNetworks('solana', [
      ReownAppKitModalNetworkInfo(
        name: 'Solana Devnet',
        chainId: _solanaDevnetChain,
        currency: 'SOL',
        rpcUrl: AppConfig.solanaClusterUrl,
        extraRpcUrls: const [AppConfig.solanaClusterUrl],
        explorerUrl: 'https://explorer.solana.com/?cluster=devnet',
        isTestNetwork: true,
      ),
    ]);
    _networksConfigured = true;
  }

  Future<void> _initialize() async {
    setState(() {
      _initializing = true;
      _error = null;
    });
    try {
      _configureSolanaDevnet();
      final icons = AppConfig.walletIconUrl.isEmpty
          ? const <String>[]
          : <String>[AppConfig.walletIconUrl];
      final modal = ReownAppKitModal(
        context: context,
        projectId: AppConfig.reownProjectId,
        metadata: PairingMetadata(
          name: AppConfig.appName,
          description: 'Tarot Noir — journal et expérience Orion',
          url: AppConfig.walletMetadataUrl,
          icons: icons,
          redirect: const Redirect(
            native: '${AppConfig.walletRedirectScheme}://wallet',
          ),
        ),
        optionalNamespaces: const {
          'solana': RequiredNamespace(
            chains: [_solanaDevnetChain],
            methods: ['solana_signMessage'],
            events: [],
          ),
        },
        disconnectOnDispose: false,
        // ignore: deprecated_member_use
        featuresConfig: FeaturesConfig(email: false, socials: const []),
      );
      modal.onModalConnect.subscribe(_refresh);
      modal.onModalUpdate.subscribe(_refresh);
      modal.onModalDisconnect.subscribe(_refresh);
      modal.onModalNetworkChange.subscribe(_refresh);
      modal.onModalError.subscribe((event) {
        if (!mounted) return;
        setState(() => _error = event.message);
      });
      await modal.init();
      final devnet = ReownAppKitModalNetworks.getNetworkInfo(
        'solana',
        _solanaDevnetChain,
      );
      if (devnet != null) await modal.selectChain(devnet);
      if (!mounted) {
        unawaited(modal.dispose());
        return;
      }
      setState(() => _modal = modal);
      _notifyConnectedWallet();
    } catch (error) {
      if (mounted) setState(() => _error = '$error');
    } finally {
      if (mounted) setState(() => _initializing = false);
    }
  }

  void _refresh(dynamic _) {
    if (!mounted) return;
    setState(() => _error = null);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _notifyConnectedWallet(),
    );
  }

  void _notifyConnectedWallet() {
    if (!mounted || _modal?.isConnected != true) return;
    final address = _address;
    if (address == null || address == _notifiedAddress) return;
    _notifiedAddress = address;
    widget.onConnected?.call(address);
  }

  String? get _address => _modal?.session?.getAddress('solana');

  String _shortAddress(String address) {
    if (address.length <= 12) return address;
    return '${address.substring(0, 6)}…${address.substring(address.length - 4)}';
  }

  Future<void> _connect() async {
    final l10n = AppLocalizations.of(context)!;
    if (!AppConfig.isWalletConnectConfigured) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.walletConfigurationRequired)));
      return;
    }
    final modal = _modal;
    if (modal == null) {
      if (!_initializing) await _initialize();
      return;
    }
    try {
      await modal.openModalView();
    } catch (error) {
      if (mounted) setState(() => _error = '$error');
    }
  }

  Future<void> _openDownload(String url) async {
    final opened = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.walletDownloadError),
        ),
      );
    }
  }

  Future<void> _disconnect() async {
    try {
      await _modal?.disconnect();
      _notifiedAddress = null;
      if (mounted) setState(() => _error = null);
    } catch (error) {
      if (mounted) setState(() => _error = '$error');
    }
  }

  @override
  void dispose() {
    final modal = _modal;
    if (modal != null) unawaited(modal.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final address = _address;
    final connected = _modal?.isConnected == true && address != null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.walletSectionTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              connected
                  ? l10n.walletConnectedAs(_shortAddress(address))
                  : l10n.walletPrivacy,
            ),
            if (_initializing) ...[
              const SizedBox(height: 12),
              const LinearProgressIndicator(),
              const SizedBox(height: 8),
              Text(l10n.walletInitializing),
            ],
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                l10n.walletError(_error!),
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            if (!connected) ...[
              const SizedBox(height: 12),
              Text(
                l10n.walletDownloadHint,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Wrap(
                spacing: 8,
                children: [
                  TextButton(
                    key: const Key('download-phantom'),
                    onPressed: () =>
                        _openDownload(AppConfig.phantomDownloadUrl),
                    child: Text(l10n.downloadPhantom),
                  ),
                  TextButton(
                    key: const Key('download-solflare'),
                    onPressed: () =>
                        _openDownload(AppConfig.solflareDownloadUrl),
                    child: Text(l10n.downloadSolflare),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            if (connected)
              OutlinedButton.icon(
                onPressed: _disconnect,
                icon: const Icon(Icons.link_off),
                label: Text(l10n.walletDisconnect),
              )
            else
              FilledButton.icon(
                key: const Key('wallet-connect'),
                onPressed: _initializing ? null : _connect,
                icon: const Icon(Icons.account_balance_wallet_outlined),
                label: Text(l10n.walletConnect),
              ),
          ],
        ),
      ),
    );
  }
}
