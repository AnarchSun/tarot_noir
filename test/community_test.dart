import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tarot_noir/l10n/app_localizations.dart';
import 'package:tarot_noir/models/community.dart';
import 'package:tarot_noir/screens/community_screen.dart';
import 'package:tarot_noir/services/community_repository.dart';
import 'package:tarot_noir/services/solana_wallet_service.dart';

class _EmptyStore implements WalletSecretStore {
  @override
  Future<void> deletePhrase() async {}
  @override
  Future<String?> readPhrase() async => null;
  @override
  Future<void> writePhrase(String value) async {}
}

Future<void> _pump(
  WidgetTester tester,
  CommunityRepository repo, {
  String uid = 'me',
}) async {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 2.5;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: CommunityScreen(
          uid: uid,
          displayName: 'Moi',
          isSelected: true,
          repository: repo,
          walletService: SolanaWalletService(store: _EmptyStore()),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  test('friendship ids are order independent and statuses are directional', () {
    expect(Friendship.pairId('b', 'a'), Friendship.pairId('a', 'b'));
    final f = Friendship(
      members: const ['a', 'b'],
      requester: 'a',
      accepted: false,
    );
    expect(f.statusFor('a'), FriendStatus.outgoing);
    expect(f.statusFor('b'), FriendStatus.incoming);
    expect(friendStatusWith([f], 'a', 'c'), FriendStatus.none);
  });

  testWidgets('join, post a shout and delete it', (tester) async {
    final repo = InMemoryCommunityRepository();
    await _pump(tester, repo);
    expect(find.byKey(const Key('community-join')), findsOneWidget);
    await tester.tap(find.byKey(const Key('community-join-button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('join-submit')));
    await tester.pumpAndSettle();
    expect(await repo.getProfile('me'), isNotNull);
    await tester.enterText(find.byKey(const Key('shout-field')), 'Bonjour');
    await tester.tap(find.byKey(const Key('shout-send')));
    await tester.pumpAndSettle();
    expect(find.text('Bonjour'), findsOneWidget);
    await tester.tap(find.byTooltip('Delete'));
    await tester.pumpAndSettle();
    expect(find.text('Bonjour'), findsNothing);
  });

  testWidgets('visit a member, send a request, then accept as them', (
    tester,
  ) async {
    final repo = InMemoryCommunityRepository();
    await repo.saveProfile(const PublicProfile(uid: 'me', displayName: 'Moi'));
    await repo.saveProfile(
      const PublicProfile(
        uid: 'zoe',
        displayName: 'Zoé',
        city: 'Montréal',
        bio: 'Tarot lover',
      ),
    );
    await _pump(tester, repo);
    await tester.tap(find.text('Members'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('member-zoe')));
    await tester.pumpAndSettle();
    expect(find.text('Tarot lover'), findsOneWidget);
    expect(
      find.text('This member does not show their collection.'),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const Key('friend-add')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('friend-cancel')), findsOneWidget);
    await repo.acceptFriend('zoe', 'me');
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('friend-remove')), findsOneWidget);
  });
}
