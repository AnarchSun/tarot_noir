import 'dart:async';

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/community.dart';
import '../services/community_repository.dart';
import '../services/solana_wallet_service.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({
    required this.uid,
    required this.displayName,
    required this.isSelected,
    this.repository,
    this.walletService,
    super.key,
  });

  final String uid;
  final String displayName;
  final bool isSelected;
  final CommunityRepository? repository;
  final SolanaWalletService? walletService;

  @visibleForTesting
  static CommunityRepository? repositoryOverride;

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  CommunityRepository? _repo;
  PublicProfile? _me;
  bool _loading = true;
  bool _started = false;

  CommunityRepository get repo => _repo!;

  @override
  void initState() {
    super.initState();
    if (widget.isSelected) _start();
  }

  @override
  void didUpdateWidget(covariant CommunityScreen old) {
    super.didUpdateWidget(old);
    if (widget.isSelected) _start();
  }

  void _start() {
    if (_started) return;
    _started = true;
    _repo =
        widget.repository ??
        CommunityScreen.repositoryOverride ??
        FirestoreCommunityRepository();
    unawaited(_loadMe());
  }

  Future<void> _loadMe() async {
    try {
      final me = await repo.getProfile(widget.uid);
      if (mounted) setState(() => _me = me);
    } catch (_) {
      // Offline or rules not deployed: show the join card.
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _join() async {
    final profile = await showModalBottomSheet<PublicProfile>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _JoinSheet(
        uid: widget.uid,
        initialName: widget.displayName,
        walletService: widget.walletService,
      ),
    );
    if (profile == null) return;
    try {
      await repo.saveProfile(profile);
      if (mounted) setState(() => _me = profile);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.communityError(error.toString()),
            ),
          ),
        );
      }
    }
  }

  Future<void> _leave() async {
    await repo.leave(widget.uid);
    if (mounted) setState(() => _me = null);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (!_started) return const SizedBox.shrink();
    if (_loading) return const Center(child: CircularProgressIndicator());
    final me = _me;
    if (me == null) {
      return ListView(
        key: const Key('community-join'),
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            l10n.community,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Text(l10n.communityIntro, style: const TextStyle(height: 1.45)),
          const SizedBox(height: 16),
          FilledButton.icon(
            key: const Key('community-join-button'),
            onPressed: _join,
            icon: const Icon(Icons.groups_outlined),
            label: Text(l10n.communityJoin),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.communityPrivacy,
            style: const TextStyle(color: Color(0xFFB9AFBE), fontSize: 12),
          ),
        ],
      );
    }
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(text: l10n.communityShoutbox),
              Tab(text: l10n.communityFriends),
              Tab(text: l10n.communityMembers),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _ShoutboxTab(repo: repo, me: me, onVisit: _visit),
                _FriendsTab(repo: repo, me: me, onVisit: _visit),
                _MembersTab(
                  repo: repo,
                  me: me,
                  onVisit: _visit,
                  onLeave: _leave,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _visit(String uid) {
    if (uid == widget.uid) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MemberProfileScreen(
          repo: repo,
          meUid: widget.uid,
          uid: uid,
          walletService: widget.walletService,
        ),
      ),
    );
  }
}

class _ShoutboxTab extends StatefulWidget {
  const _ShoutboxTab({
    required this.repo,
    required this.me,
    required this.onVisit,
  });

  final CommunityRepository repo;
  final PublicProfile me;
  final void Function(String uid) onVisit;

  @override
  State<_ShoutboxTab> createState() => _ShoutboxTabState();
}

class _ShoutboxTabState extends State<_ShoutboxTab> {
  final _controller = TextEditingController();
  bool _posting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _post() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _posting) return;
    setState(() => _posting = true);
    try {
      await widget.repo.postShout(
        uid: widget.me.uid,
        name: widget.me.displayName,
        text: text,
      );
      _controller.clear();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.communityError(error.toString()),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _posting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  key: const Key('shout-field'),
                  controller: _controller,
                  maxLength: Shout.maxLength,
                  minLines: 1,
                  maxLines: 3,
                  decoration: InputDecoration(hintText: l10n.shoutHint),
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: IconButton.filled(
                  key: const Key('shout-send'),
                  tooltip: l10n.shoutSend,
                  onPressed: _posting ? null : _post,
                  icon: const Icon(Icons.send),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<List<Shout>>(
            stream: widget.repo.watchShouts(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(l10n.communityError('${snapshot.error}')),
                );
              }
              final shouts = snapshot.data;
              if (shouts == null) {
                return const Center(child: CircularProgressIndicator());
              }
              if (shouts.isEmpty) {
                return Center(child: Text(l10n.shoutEmpty));
              }
              return ListView.builder(
                key: const Key('shout-list'),
                padding: const EdgeInsets.all(16),
                itemCount: shouts.length,
                itemBuilder: (context, i) {
                  final s = shouts[i];
                  final mine = s.authorUid == widget.me.uid;
                  return Card(
                    child: ListTile(
                      onTap: () => widget.onVisit(s.authorUid),
                      title: Text(
                        s.authorName,
                        style: const TextStyle(
                          color: Color(0xFFD4AF59),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(s.text),
                      trailing: mine
                          ? IconButton(
                              tooltip: l10n.shoutDelete,
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => widget.repo.deleteShout(s.id),
                            )
                          : null,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _NameTile extends StatelessWidget {
  const _NameTile({
    required this.repo,
    required this.uid,
    required this.onTap,
    this.trailing,
  });

  final CommunityRepository repo;
  final String uid;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PublicProfile?>(
      future: repo.getProfile(uid),
      builder: (context, snapshot) {
        final profile = snapshot.data;
        return ListTile(
          onTap: onTap,
          leading: const CircleAvatar(child: Icon(Icons.person_outline)),
          title: Text(profile?.displayName ?? '…'),
          subtitle: profile?.city == null ? null : Text(profile!.city!),
          trailing: trailing,
        );
      },
    );
  }
}

class _FriendsTab extends StatelessWidget {
  const _FriendsTab({
    required this.repo,
    required this.me,
    required this.onVisit,
  });

  final CommunityRepository repo;
  final PublicProfile me;
  final void Function(String uid) onVisit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return StreamBuilder<List<Friendship>>(
      stream: repo.watchFriendships(me.uid),
      builder: (context, snapshot) {
        final all = snapshot.data ?? const <Friendship>[];
        final incoming = [
          for (final f in all)
            if (f.statusFor(me.uid) == FriendStatus.incoming) f,
        ];
        final friends = [
          for (final f in all)
            if (f.accepted) f,
        ];
        final outgoing = [
          for (final f in all)
            if (f.statusFor(me.uid) == FriendStatus.outgoing) f,
        ];
        if (all.isEmpty) {
          return Center(
            key: const Key('friends-empty'),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(l10n.friendsEmpty, textAlign: TextAlign.center),
            ),
          );
        }
        return ListView(
          key: const Key('friends-list'),
          padding: const EdgeInsets.all(8),
          children: [
            if (incoming.isNotEmpty) _header(l10n.friendRequests),
            for (final f in incoming)
              _NameTile(
                repo: repo,
                uid: f.otherThan(me.uid),
                onTap: () => onVisit(f.otherThan(me.uid)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      key: Key('friend-accept-${f.otherThan(me.uid)}'),
                      tooltip: l10n.friendAccept,
                      icon: const Icon(Icons.check),
                      onPressed: () =>
                          repo.acceptFriend(me.uid, f.otherThan(me.uid)),
                    ),
                    IconButton(
                      tooltip: l10n.friendDecline,
                      icon: const Icon(Icons.close),
                      onPressed: () =>
                          repo.removeFriend(me.uid, f.otherThan(me.uid)),
                    ),
                  ],
                ),
              ),
            if (friends.isNotEmpty) _header(l10n.communityFriends),
            for (final f in friends)
              _NameTile(
                repo: repo,
                uid: f.otherThan(me.uid),
                onTap: () => onVisit(f.otherThan(me.uid)),
              ),
            if (outgoing.isNotEmpty) _header(l10n.friendPending),
            for (final f in outgoing)
              _NameTile(
                repo: repo,
                uid: f.otherThan(me.uid),
                onTap: () => onVisit(f.otherThan(me.uid)),
                trailing: const Icon(Icons.hourglass_bottom, size: 18),
              ),
          ],
        );
      },
    );
  }

  Widget _header(String text) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
    child: Text(
      text.toUpperCase(),
      style: const TextStyle(
        color: Color(0xFFD4AF59),
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        fontSize: 12,
      ),
    ),
  );
}

class _MembersTab extends StatelessWidget {
  const _MembersTab({
    required this.repo,
    required this.me,
    required this.onVisit,
    required this.onLeave,
  });

  final CommunityRepository repo;
  final PublicProfile me;
  final void Function(String uid) onVisit;
  final Future<void> Function() onLeave;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FutureBuilder<List<PublicProfile>>(
      future: repo.listMembers(),
      builder: (context, snapshot) {
        final members = [
          for (final m in snapshot.data ?? const <PublicProfile>[])
            if (m.uid != me.uid) m,
        ];
        return ListView(
          key: const Key('members-list'),
          padding: const EdgeInsets.all(8),
          children: [
            if (snapshot.connectionState != ConnectionState.done)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              ),
            for (final m in members)
              ListTile(
                key: Key('member-${m.uid}'),
                onTap: () => onVisit(m.uid),
                leading: const CircleAvatar(child: Icon(Icons.person_outline)),
                title: Text(m.displayName),
                subtitle: m.city == null ? null : Text(m.city!),
                trailing: const Icon(Icons.chevron_right),
              ),
            if (snapshot.connectionState == ConnectionState.done &&
                members.isEmpty)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(l10n.membersEmpty, textAlign: TextAlign.center),
              ),
            const SizedBox(height: 16),
            TextButton(
              key: const Key('community-leave'),
              onPressed: onLeave,
              child: Text(l10n.communityLeave),
            ),
          ],
        );
      },
    );
  }
}

class _JoinSheet extends StatefulWidget {
  const _JoinSheet({
    required this.uid,
    required this.initialName,
    this.walletService,
  });

  final String uid;
  final String initialName;
  final SolanaWalletService? walletService;

  @override
  State<_JoinSheet> createState() => _JoinSheetState();
}

class _JoinSheetState extends State<_JoinSheet> {
  late final _name = TextEditingController(text: widget.initialName);
  final _bio = TextEditingController();
  final _city = TextEditingController();
  String? _walletAddress;
  bool _showWallet = false;

  @override
  void initState() {
    super.initState();
    unawaited(_loadWallet());
  }

  Future<void> _loadWallet() async {
    try {
      final keys = await (widget.walletService ?? SolanaWalletService())
          .loadKeys();
      if (mounted && keys != null) {
        setState(() => _walletAddress = keys.address);
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _name.dispose();
    _bio.dispose();
    _city.dispose();
    super.dispose();
  }

  String? _clean(TextEditingController c) {
    final t = c.text.trim();
    return t.isEmpty ? null : t;
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
              l10n.communityJoin,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            TextField(
              key: const Key('join-name'),
              controller: _name,
              maxLength: 60,
              decoration: InputDecoration(labelText: l10n.communityPseudo),
            ),
            TextField(
              controller: _city,
              maxLength: 80,
              decoration: InputDecoration(labelText: l10n.cityLabel),
            ),
            TextField(
              controller: _bio,
              maxLength: 500,
              minLines: 2,
              maxLines: 4,
              decoration: InputDecoration(labelText: l10n.bioLabel),
            ),
            if (_walletAddress != null)
              SwitchListTile(
                key: const Key('join-show-wallet'),
                contentPadding: EdgeInsets.zero,
                value: _showWallet,
                onChanged: (v) => setState(() => _showWallet = v),
                title: Text(l10n.communityShowCollection),
              ),
            const SizedBox(height: 12),
            FilledButton(
              key: const Key('join-submit'),
              onPressed: () {
                final name = _name.text.trim();
                if (name.isEmpty) return;
                Navigator.pop(
                  context,
                  PublicProfile(
                    uid: widget.uid,
                    displayName: name,
                    bio: _clean(_bio),
                    city: _clean(_city),
                    walletAddress: _showWallet ? _walletAddress : null,
                  ),
                );
              },
              child: Text(l10n.communityJoinAction),
            ),
          ],
        ),
      ),
    );
  }
}

class MemberProfileScreen extends StatefulWidget {
  const MemberProfileScreen({
    required this.repo,
    required this.meUid,
    required this.uid,
    this.walletService,
    super.key,
  });

  final CommunityRepository repo;
  final String meUid;
  final String uid;
  final SolanaWalletService? walletService;

  @override
  State<MemberProfileScreen> createState() => _MemberProfileScreenState();
}

class _MemberProfileScreenState extends State<MemberProfileScreen> {
  late final Future<PublicProfile?> _profile = widget.repo.getProfile(
    widget.uid,
  );
  Future<int>? _nfts;

  Future<int> _loadNfts(String address) =>
      (widget.walletService ?? SolanaWalletService()).nftCount(address);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.communityMemberTitle)),
      body: FutureBuilder<PublicProfile?>(
        future: _profile,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final p = snapshot.data;
          if (p == null) {
            return Center(child: Text(l10n.memberNotFound));
          }
          final wallet = p.walletAddress;
          if (wallet != null) _nfts ??= _loadNfts(wallet);
          return ListView(
            key: const Key('member-profile'),
            padding: const EdgeInsets.all(24),
            children: [
              const Center(
                child: CircleAvatar(
                  radius: 40,
                  child: Icon(Icons.person_outline, size: 40),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                p.displayName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (p.city != null || p.origin != null)
                Text(
                  [p.city, p.origin].whereType<String>().join(' · '),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 12),
              _FriendButton(
                repo: widget.repo,
                me: widget.meUid,
                other: widget.uid,
              ),
              if (p.bio != null) ...[
                const SizedBox(height: 16),
                Text(p.bio!, style: const TextStyle(height: 1.45)),
              ],
              const SizedBox(height: 20),
              Text(
                l10n.profileTabCollection.toUpperCase(),
                style: const TextStyle(
                  color: Color(0xFFD4AF59),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              if (wallet == null)
                Text(l10n.memberCollectionPrivate)
              else
                FutureBuilder<int>(
                  future: _nfts,
                  builder: (context, nft) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectableText(
                        wallet,
                        style: const TextStyle(fontFamily: 'monospace'),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        nft.hasData
                            ? l10n.walletNftCount(nft.data!)
                            : nft.hasError
                            ? l10n.communityError('${nft.error}')
                            : '…',
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _FriendButton extends StatelessWidget {
  const _FriendButton({
    required this.repo,
    required this.me,
    required this.other,
  });

  final CommunityRepository repo;
  final String me;
  final String other;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return StreamBuilder<List<Friendship>>(
      stream: repo.watchFriendships(me),
      builder: (context, snapshot) {
        final status = friendStatusWith(
          snapshot.data ?? const <Friendship>[],
          me,
          other,
        );
        return switch (status) {
          FriendStatus.none => FilledButton.icon(
            key: const Key('friend-add'),
            onPressed: () => repo.requestFriend(me, other),
            icon: const Icon(Icons.person_add_alt),
            label: Text(l10n.friendAdd),
          ),
          FriendStatus.outgoing => OutlinedButton.icon(
            key: const Key('friend-cancel'),
            onPressed: () => repo.removeFriend(me, other),
            icon: const Icon(Icons.hourglass_bottom),
            label: Text(l10n.friendCancelRequest),
          ),
          FriendStatus.incoming => FilledButton.icon(
            key: const Key('friend-accept'),
            onPressed: () => repo.acceptFriend(me, other),
            icon: const Icon(Icons.check),
            label: Text(l10n.friendAccept),
          ),
          FriendStatus.friends => OutlinedButton.icon(
            key: const Key('friend-remove'),
            onPressed: () => repo.removeFriend(me, other),
            icon: const Icon(Icons.person_remove_outlined),
            label: Text(l10n.friendRemove),
          ),
        };
      },
    );
  }
}
