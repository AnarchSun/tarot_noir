class UserProfile {
  const UserProfile({
    required this.displayName,
    required this.completedAt,
    this.email,
    this.walletAddress,
    this.firebaseUid,
  }) : assert(walletAddress != null || firebaseUid != null);

  final String displayName;
  final String? email;
  final String? walletAddress;
  final String? firebaseUid;
  final DateTime completedAt;

  bool belongsToFirebaseUser(String uid) => firebaseUid == uid;

  bool belongsToWallet(String address) => walletAddress == address;

  Map<String, Object?> toJson() => {
    'displayName': displayName,
    'email': email,
    'walletAddress': walletAddress,
    'firebaseUid': firebaseUid,
    'completedAt': completedAt.toUtc().toIso8601String(),
  };

  static UserProfile? fromJson(Map<String, dynamic> json) {
    try {
      final displayName = (json['displayName'] as String).trim();
      final rawEmail = (json['email'] as String?)?.trim();
      final rawWalletAddress = (json['walletAddress'] as String?)?.trim();
      final rawFirebaseUid = (json['firebaseUid'] as String?)?.trim();
      final walletAddress = rawWalletAddress == null || rawWalletAddress.isEmpty
          ? null
          : rawWalletAddress;
      final firebaseUid = rawFirebaseUid == null || rawFirebaseUid.isEmpty
          ? null
          : rawFirebaseUid;
      if (displayName.isEmpty ||
          (walletAddress == null && firebaseUid == null)) {
        return null;
      }
      return UserProfile(
        displayName: displayName,
        email: rawEmail == null || rawEmail.isEmpty ? null : rawEmail,
        walletAddress: walletAddress,
        firebaseUid: firebaseUid,
        completedAt: DateTime.parse(json['completedAt'] as String),
      );
    } on FormatException {
      return null;
    } on TypeError {
      return null;
    }
  }
}
