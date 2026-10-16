class PublicProfile {
  const PublicProfile({
    required this.uid,
    required this.displayName,
    this.bio,
    this.city,
    this.origin,
    this.walletAddress,
  });

  final String uid;
  final String displayName;
  final String? bio;
  final String? city;
  final String? origin;

  /// Only set when the member chooses to show their collection.
  final String? walletAddress;

  PublicProfile copyWith({
    String? displayName,
    String? bio,
    String? city,
    String? origin,
    String? walletAddress,
    bool clearWallet = false,
  }) => PublicProfile(
    uid: uid,
    displayName: displayName ?? this.displayName,
    bio: bio ?? this.bio,
    city: city ?? this.city,
    origin: origin ?? this.origin,
    walletAddress: clearWallet ? null : (walletAddress ?? this.walletAddress),
  );
}

class Shout {
  const Shout({
    required this.id,
    required this.authorUid,
    required this.authorName,
    required this.text,
    required this.createdAt,
  });

  static const maxLength = 280;

  final String id;
  final String authorUid;
  final String authorName;
  final String text;
  final DateTime createdAt;
}

enum FriendStatus { none, outgoing, incoming, friends }

class Friendship {
  const Friendship({
    required this.members,
    required this.requester,
    required this.accepted,
  });

  final List<String> members;
  final String requester;
  final bool accepted;

  static String pairId(String a, String b) =>
      a.compareTo(b) < 0 ? '${a}_$b' : '${b}_$a';

  String otherThan(String uid) => members.firstWhere((m) => m != uid);

  FriendStatus statusFor(String uid) {
    if (accepted) return FriendStatus.friends;
    return requester == uid ? FriendStatus.outgoing : FriendStatus.incoming;
  }
}

FriendStatus friendStatusWith(
  Iterable<Friendship> friendships,
  String me,
  String other,
) {
  for (final f in friendships) {
    if (f.members.contains(other)) return f.statusFor(me);
  }
  return FriendStatus.none;
}
