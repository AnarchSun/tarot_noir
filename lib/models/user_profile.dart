class UserProfile {
  const UserProfile({
    required this.displayName,
    required this.walletAddress,
    required this.completedAt,
    this.email,
  });

  final String displayName;
  final String? email;
  final String walletAddress;
  final DateTime completedAt;

  Map<String, Object?> toJson() => {
    'displayName': displayName,
    'email': email,
    'walletAddress': walletAddress,
    'completedAt': completedAt.toUtc().toIso8601String(),
  };

  static UserProfile? fromJson(Map<String, dynamic> json) {
    try {
      final displayName = (json['displayName'] as String).trim();
      final walletAddress = (json['walletAddress'] as String).trim();
      if (displayName.isEmpty || walletAddress.isEmpty) return null;
      final rawEmail = (json['email'] as String?)?.trim();
      return UserProfile(
        displayName: displayName,
        email: rawEmail == null || rawEmail.isEmpty ? null : rawEmail,
        walletAddress: walletAddress,
        completedAt: DateTime.parse(json['completedAt'] as String),
      );
    } on FormatException {
      return null;
    } on TypeError {
      return null;
    }
  }
}
