class PasswordResetRequest {
  final String id;
  final String userId;
  final String collection;
  final String username;
  final String newPassword;

  PasswordResetRequest({
    required this.id,
    required this.userId,
    required this.collection,
    required this.username,
    required this.newPassword,
  });

  factory PasswordResetRequest.fromJson(Map<String, dynamic> json) {
    return PasswordResetRequest(
      id: json['id'] as String,
      userId: json['userId'] as String,
      collection: json['type'] as String,
      username: json['username'] as String,
      newPassword: json['password'] as String,
    );
  }
}
