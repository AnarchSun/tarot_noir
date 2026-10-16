import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/community.dart';

abstract class CommunityRepository {
  Future<PublicProfile?> getProfile(String uid);
  Future<void> saveProfile(PublicProfile profile);
  Future<void> leave(String uid);
  Future<List<PublicProfile>> listMembers({int limit = 50});
  Stream<List<Shout>> watchShouts();
  Future<void> postShout({
    required String uid,
    required String name,
    required String text,
  });
  Future<void> deleteShout(String id);
  Stream<List<Friendship>> watchFriendships(String uid);
  Future<void> requestFriend(String me, String other);
  Future<void> acceptFriend(String me, String other);
  Future<void> removeFriend(String me, String other);
}

class FirestoreCommunityRepository implements CommunityRepository {
  FirestoreCommunityRepository({FirebaseFirestore? firestore})
    : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _profiles =>
      _db.collection('publicProfiles');
  CollectionReference<Map<String, dynamic>> get _shouts =>
      _db.collection('shouts');
  CollectionReference<Map<String, dynamic>> get _friendships =>
      _db.collection('friendships');

  PublicProfile _profileFrom(String uid, Map<String, dynamic> d) =>
      PublicProfile(
        uid: uid,
        displayName: (d['displayName'] as String?) ?? '—',
        bio: d['bio'] as String?,
        city: d['city'] as String?,
        origin: d['origin'] as String?,
        walletAddress: d['walletAddress'] as String?,
      );

  @override
  Future<PublicProfile?> getProfile(String uid) async {
    final doc = await _profiles.doc(uid).get();
    final data = doc.data();
    return data == null ? null : _profileFrom(uid, data);
  }

  @override
  Future<void> saveProfile(PublicProfile p) => _profiles.doc(p.uid).set({
    'displayName': p.displayName,
    'bio': p.bio,
    'city': p.city,
    'origin': p.origin,
    'walletAddress': p.walletAddress,
    'updatedAt': FieldValue.serverTimestamp(),
  });

  @override
  Future<void> leave(String uid) => _profiles.doc(uid).delete();

  @override
  Future<List<PublicProfile>> listMembers({int limit = 50}) async {
    final snap = await _profiles
        .orderBy('updatedAt', descending: true)
        .limit(limit)
        .get();
    return [for (final d in snap.docs) _profileFrom(d.id, d.data())];
  }

  @override
  Stream<List<Shout>> watchShouts() => _shouts
      .orderBy('createdAt', descending: true)
      .limit(50)
      .snapshots()
      .map(
        (snap) => [
          for (final d in snap.docs)
            Shout(
              id: d.id,
              authorUid: d.data()['authorUid'] as String? ?? '',
              authorName: d.data()['authorName'] as String? ?? '—',
              text: d.data()['text'] as String? ?? '',
              createdAt:
                  (d.data()['createdAt'] as Timestamp?)?.toDate() ??
                  DateTime.now(),
            ),
        ],
      );

  @override
  Future<void> postShout({
    required String uid,
    required String name,
    required String text,
  }) async {
    await _shouts.add({
      'authorUid': uid,
      'authorName': name,
      'text': text,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> deleteShout(String id) => _shouts.doc(id).delete();

  @override
  Stream<List<Friendship>> watchFriendships(String uid) => _friendships
      .where('members', arrayContains: uid)
      .snapshots()
      .map(
        (snap) => [
          for (final d in snap.docs)
            Friendship(
              members: List<String>.from(d.data()['members'] as List),
              requester: d.data()['requester'] as String,
              accepted: d.data()['status'] == 'accepted',
            ),
        ],
      );

  @override
  Future<void> requestFriend(String me, String other) {
    final members = [me, other]..sort();
    return _friendships.doc(Friendship.pairId(me, other)).set({
      'members': members,
      'requester': me,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> acceptFriend(String me, String other) => _friendships
      .doc(Friendship.pairId(me, other))
      .update({'status': 'accepted'});

  @override
  Future<void> removeFriend(String me, String other) =>
      _friendships.doc(Friendship.pairId(me, other)).delete();
}

class InMemoryCommunityRepository implements CommunityRepository {
  final _profiles = <String, PublicProfile>{};
  final _shouts = <Shout>[];
  final _friendships = <String, Friendship>{};
  final _changes = StreamController<void>.broadcast();
  var _counter = 0;

  Stream<T> _watch<T>(T Function() read) async* {
    yield read();
    await for (final _ in _changes.stream) {
      yield read();
    }
  }

  @override
  Future<PublicProfile?> getProfile(String uid) async => _profiles[uid];

  @override
  Future<void> saveProfile(PublicProfile profile) async =>
      _profiles[profile.uid] = profile;

  @override
  Future<void> leave(String uid) async => _profiles.remove(uid);

  @override
  Future<List<PublicProfile>> listMembers({int limit = 50}) async =>
      _profiles.values.take(limit).toList();

  @override
  Stream<List<Shout>> watchShouts() =>
      _watch(() => _shouts.reversed.toList(growable: false));

  @override
  Future<void> postShout({
    required String uid,
    required String name,
    required String text,
  }) async {
    _shouts.add(
      Shout(
        id: '${_counter++}',
        authorUid: uid,
        authorName: name,
        text: text,
        createdAt: DateTime.now(),
      ),
    );
    _changes.add(null);
  }

  @override
  Future<void> deleteShout(String id) async {
    _shouts.removeWhere((s) => s.id == id);
    _changes.add(null);
  }

  @override
  Stream<List<Friendship>> watchFriendships(String uid) => _watch(
    () => _friendships.values
        .where((f) => f.members.contains(uid))
        .toList(growable: false),
  );

  @override
  Future<void> requestFriend(String me, String other) async {
    _friendships[Friendship.pairId(me, other)] = Friendship(
      members: [me, other]..sort(),
      requester: me,
      accepted: false,
    );
    _changes.add(null);
  }

  @override
  Future<void> acceptFriend(String me, String other) async {
    final id = Friendship.pairId(me, other);
    final f = _friendships[id];
    if (f == null) return;
    _friendships[id] = Friendship(
      members: f.members,
      requester: f.requester,
      accepted: true,
    );
    _changes.add(null);
  }

  @override
  Future<void> removeFriend(String me, String other) async {
    _friendships.remove(Friendship.pairId(me, other));
    _changes.add(null);
  }
}
