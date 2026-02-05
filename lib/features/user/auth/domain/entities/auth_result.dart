// lib/features/auth/domain/entities/auth_result.dart
import 'package:flavorizr/features/user/auth/domain/entities/auth_tokens.dart';
import 'package:flavorizr/features/user/auth/domain/entities/user.dart';

/// Represents the result of a successful authentication.
///
/// Contains both the authenticated user and the tokens needed
/// for subsequent API requests.
class AuthResult {
  /// Creates a new [AuthResult] instance.
  const AuthResult({required this.user, required this.tokens, this.isNewUser = false});

  /// The authenticated user.
  final User user;

  /// The authentication tokens.
  final AuthTokens tokens;

  /// Whether this is a newly created account.
  final bool isNewUser;

  /// Creates a copy of this result with the given fields replaced.
  AuthResult copyWith({User? user, AuthTokens? tokens, bool? isNewUser}) {
    return AuthResult(
      user: user ?? this.user,
      tokens: tokens ?? this.tokens,
      isNewUser: isNewUser ?? this.isNewUser,
    );
  }

  @override
  String toString() {
    return 'AuthResult(user: ${user.email}, isNewUser: $isNewUser)';
  }
}
