// lib/features/auth/auth.dart
/// Authentication feature exports.
///
/// This barrel file exports all public authentication-related classes
/// and providers for easy importing throughout the app.
library;

// Domain - Entities
export 'domain/entities/user.dart';
export 'domain/entities/auth_tokens.dart';
export 'domain/entities/auth_result.dart';

// Domain - Repository Interface
export 'domain/repositories/auth_repository.dart';

// Domain - Use Cases
export 'domain/usecases/login_usecase.dart';
export 'domain/usecases/register_usecase.dart';
export 'domain/usecases/logout_usecase.dart';
export 'domain/usecases/social_auth_usecase.dart';
export 'domain/usecases/password_reset_usecase.dart';
export 'domain/usecases/biometric_auth_usecase.dart';
export 'domain/usecases/get_current_user_usecase.dart';

// Data - Models
export 'data/models/user_model.dart';

// Data - Repository Implementation
export 'data/repositories/auth_repository_impl.dart';

// Presentation - Providers
export 'presentation/providers/auth_providers.dart';

// Presentation - Controllers
export 'presentation/controllers/login_controller.dart';
export 'presentation/controllers/register_controller.dart';
export 'presentation/controllers/forgot_password_controller.dart';

// Presentation - Pages
export 'presentation/pages/login_page.dart';
export 'presentation/pages/register_page.dart';
export 'presentation/pages/forgot_password_page.dart';

// Presentation - Widgets
export 'presentation/widgets/social_login_buttons.dart';
