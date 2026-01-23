// lib/features/auth/domain/usecases/social_auth_usecase.dart
import 'package:flavorizr/features/auth/domain/entities/auth_result.dart';
import 'package:flavorizr/features/auth/domain/repositories/auth_repository.dart';
import 'package:flavorizr/shared/domain/usecases/usecase.dart';

/// Use case for Google OAuth sign-in.
class GoogleSignInUseCase implements UseCase<AuthResult, NoParams> {
  GoogleSignInUseCase(this._repository);
  final AuthRepository _repository;

  @override
  UseCaseResult<AuthResult> call(NoParams params) async {
    return _repository.signInWithGoogle();
  }
}

/// Use case for Apple OAuth sign-in.
class AppleSignInUseCase implements UseCase<AuthResult, NoParams> {
  AppleSignInUseCase(this._repository);
  final AuthRepository _repository;

  @override
  UseCaseResult<AuthResult> call(NoParams params) async {
    return _repository.signInWithApple();
  }
}
