import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../models/journal_entry.dart';
import '../models/user_profile.dart';
import '../services/firebase_auth_service.dart';
import '../services/tarot_storage_service.dart';
import '../services/solana_wallet_service.dart';
import '../widgets/builtin_wallet_panel.dart';
import '../widgets/journal_section.dart';
import '../widgets/profile_completion_sheet.dart';
import '../widgets/wallet_connect_panel.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    required this.initialUser,
    required this.isSelected,
    required this.onFirebaseUserChanged,
    required this.onEnableJournalSync,
    required this.onDisableJournalSync,
    required this.journalEntries,
    required this.onUpdateJournalNote,
    required this.onDeleteJournalEntry,
    required this.onClearData,
    required this.isPremiumUnlocked,
    required this.onOpenPremium,
    this.walletService,
    super.key,
  });

  final User initialUser;
  final bool isSelected;
  final Future<void> Function(User?) onFirebaseUserChanged;
  final Future<void> Function(User user) onEnableJournalSync;
  final Future<void> Function(User user) onDisableJournalSync;
  final List<JournalEntry> journalEntries;
  final Future<void> Function(JournalEntry entry, String note)
  onUpdateJournalNote;
  final Future<void> Function(JournalEntry entry) onDeleteJournalEntry;
  final VoidCallback onClearData;
  final bool isPremiumUnlocked;
  final VoidCallback onOpenPremium;
  final SolanaWalletService? walletService;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _storage = TarotStorageService();
  final _auth = const FirebaseAuthService();
  UserProfile? _profile;
  User? _authUser;
  bool _journalSyncEnabled = false;
  bool _syncingJournal = false;
  late final Future<void> _restoreTask;

  @override
  void initState() {
    super.initState();
    _authUser = widget.initialUser;
    _restoreTask = _restoreProfile();
    if (widget.isSelected) {
      _promptProfileCompletion();
    }
  }

  @override
  void didUpdateWidget(covariant ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.isSelected && widget.isSelected) {
      _promptProfileCompletion();
    }
  }

  Future<void> _promptProfileCompletion() async {
    await _restoreTask;
    final user = _authUser;
    if (user != null && mounted) await _completeFirebaseProfile(user);
  }

  Future<void> _restoreProfile() async {
    final profile = await _storage.restoreUserProfile();
    final user = _authUser;
    final syncEnabled = user != null
        ? await _storage.isJournalSyncEnabledForUser(user.uid)
        : false;
    if (mounted) {
      setState(() {
        _profile = profile;
        if (_authUser?.uid == user?.uid) {
          _journalSyncEnabled = syncEnabled;
        }
      });
    }
  }

  Future<void> _completeProfile(String walletAddress) async {
    if (_profile?.belongsToWallet(walletAddress) == true) return;
    await Future<void>.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;
    await _showProfileForm(walletAddress: walletAddress);
  }

  Future<void> _completeFirebaseProfile(User user) async {
    if (_profile?.belongsToFirebaseUser(user.uid) == true) return;
    await Future<void>.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;
    await _showProfileForm(
      firebaseUid: user.uid,
      suggestedDisplayName: user.displayName,
      suggestedEmail: user.email,
    );
  }

  Future<void> _showProfileForm({
    String? walletAddress,
    String? firebaseUid,
    String? suggestedDisplayName,
    String? suggestedEmail,
  }) async {
    final profile = await showModalBottomSheet<UserProfile>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => ProfileCompletionSheet(
        walletAddress: walletAddress,
        firebaseUid: firebaseUid,
        suggestedDisplayName: suggestedDisplayName,
        suggestedEmail: suggestedEmail,
        initialProfile: _profile,
      ),
    );
    if (profile == null) return;
    await _storage.saveUserProfile(profile);
    if (!mounted) return;
    setState(() => _profile = profile);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.profileSaved)),
    );
  }

  Future<void> _signOut() async {
    try {
      await _auth.signOut();
      if (mounted) {
        setState(() {
          _authUser = null;
          _journalSyncEnabled = false;
        });
        await widget.onFirebaseUserChanged(null);
      }
    } on FirebaseAuthException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.message ?? error.code)));
      }
    }
  }

  Future<void> _setJournalSync(bool enabled) async {
    final user = _authUser;
    if (user == null || _syncingJournal) return;
    setState(() => _syncingJournal = true);
    try {
      if (enabled) {
        await widget.onEnableJournalSync(user);
      } else {
        await widget.onDisableJournalSync(user);
      }
      if (!mounted) return;
      setState(() => _journalSyncEnabled = enabled);
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            enabled ? l10n.journalSyncEnabled : l10n.journalSyncDisabled,
          ),
        ),
      );
    } catch (error) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.journalSyncFailed(error.toString()))),
        );
      }
    } finally {
      if (mounted) setState(() => _syncingJournal = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final profile = _profile;
    final authUser = _authUser;
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.profile),
          bottom: TabBar(
            key: const Key('profile-tabs'),
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: l10n.profileTabHome),
              Tab(text: l10n.profileTabJournal),
              Tab(text: l10n.profileTabCollection),
              Tab(text: l10n.profileTabWallet),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildHomeTab(context, l10n, profile, authUser),
            ListView(
              padding: const EdgeInsets.all(20),
              children: [
                JournalSection(
                  entries: widget.journalEntries,
                  onUpdateNote: widget.onUpdateJournalNote,
                  onDelete: widget.onDeleteJournalEntry,
                  onClearData: widget.onClearData,
                  isPremiumUnlocked: widget.isPremiumUnlocked,
                  onOpenPremium: widget.onOpenPremium,
                ),
              ],
            ),
            _buildCollectionTab(l10n),
            ListView(
              padding: const EdgeInsets.all(20),
              children: [
                BuiltinWalletPanel(
                  isPremiumUnlocked: widget.isPremiumUnlocked,
                  onOpenPremium: widget.onOpenPremium,
                  service: widget.walletService,
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.walletExternalTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                WalletConnectPanel(onConnected: _completeProfile),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollectionTab(AppLocalizations l10n) => ListView(
    key: const Key('profile-collection'),
    padding: const EdgeInsets.all(20),
    children: [
      Text(
        l10n.collectionTitle,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 24),
      const Icon(Icons.collections_bookmark_outlined, size: 56),
      const SizedBox(height: 16),
      Text(
        l10n.collectionEmpty,
        textAlign: TextAlign.center,
        style: const TextStyle(height: 1.4),
      ),
      const SizedBox(height: 12),
      Text(
        l10n.collectionPremiumHint,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Color(0xFFB9AFBE), height: 1.4),
      ),
    ],
  );

  Widget _buildHomeTab(
    BuildContext context,
    AppLocalizations l10n,
    UserProfile? profile,
    User? authUser,
  ) {
    final about = <(IconData, String)>[
      if (profile?.city != null) (Icons.location_city_outlined, profile!.city!),
      if (profile?.origin != null) (Icons.public, profile!.origin!),
      if (profile != null)
        (
          Icons.calendar_today_outlined,
          l10n.memberSince(
            DateFormat.yMMMMd(l10n.localeName)
                .format(profile.completedAt.toLocal()),
          ),
        ),
    ];
    return ListView(
      key: const Key('profile-home'),
      padding: const EdgeInsets.all(20),
      children: [
        CircleAvatar(
          radius: 42,
          child: profile == null
              ? const Icon(Icons.person_outline, size: 44)
              : Text(
                  profile.displayName.characters.first.toUpperCase(),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
        ),
        const SizedBox(height: 20),
        Text(
          profile?.displayName ?? l10n.profileTitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          authUser?.email ??
              authUser?.phoneNumber ??
              profile?.email ??
              l10n.profileIntro,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        if (profile != null) ...[
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () => _showProfileForm(
              walletAddress: profile.walletAddress,
              firebaseUid: profile.firebaseUid,
            ),
            icon: const Icon(Icons.edit_outlined),
            label: Text(l10n.editProfile),
          ),
        ],
        const SizedBox(height: 16),
        Card(
          key: const Key('profile-about'),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.aboutTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  profile?.bio ?? l10n.aboutEmpty,
                  style: const TextStyle(height: 1.4),
                ),
                for (final item in about) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(item.$1, size: 18),
                      const SizedBox(width: 10),
                      Expanded(child: Text(item.$2)),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (authUser != null)
          OutlinedButton.icon(
            key: const Key('sign-out'),
            onPressed: _signOut,
            icon: const Icon(Icons.logout),
            label: Text(l10n.signOut),
          ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: Icon(
              authUser != null ? Icons.verified_user : Icons.lock_outline,
            ),
            title: Text(
              authUser == null
                  ? l10n.authenticationConfigured
                  : l10n.signedInAs(
                      authUser.email ?? authUser.phoneNumber ?? authUser.uid,
                    ),
            ),
            subtitle: Text(l10n.authenticationPrivacy),
          ),
        ),
        if (authUser != null) ...[
          const SizedBox(height: 12),
          Card(
            child: SwitchListTile(
              key: const Key('journal-cloud-sync'),
              value: _journalSyncEnabled,
              onChanged: _syncingJournal ? null : _setJournalSync,
              secondary: _syncingJournal
                  ? const SizedBox.square(
                      dimension: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.cloud_sync_outlined),
              title: Text(l10n.journalSyncTitle),
              subtitle: Text(l10n.journalSyncDescription),
            ),
          ),
        ],
      ],
    );
  }
}
