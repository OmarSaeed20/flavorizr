// lib/features/settings/presentation/controllers/notification_settings_controller.dart
import 'package:flavorizr/features/settings/domain/entities/notification_settings.dart';
import 'package:flavorizr/features/settings/domain/repositories/notification_settings_repository.dart';
import 'package:flavorizr/features/settings/presentation/providers/settings_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for notification settings.
class NotificationSettingsState {
  const NotificationSettingsState({
    this.settings = const NotificationSettings(),
    this.originalSettings = const NotificationSettings(),
    this.isLoading = false,
    this.isSaving = false,
    this.errorMessage,
    this.isSuccess = false,
    this.hasChanges = false,
  });

  final NotificationSettings settings;
  final NotificationSettings originalSettings;
  final bool isLoading;
  final bool isSaving;
  final String? errorMessage;
  final bool isSuccess;
  final bool hasChanges;

  NotificationSettingsState copyWith({
    NotificationSettings? settings,
    NotificationSettings? originalSettings,
    bool? isLoading,
    bool? isSaving,
    String? errorMessage,
    bool? isSuccess,
    bool? hasChanges,
    bool clearError = false,
  }) {
    return NotificationSettingsState(
      settings: settings ?? this.settings,
      originalSettings: originalSettings ?? this.originalSettings,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
      hasChanges: hasChanges ?? this.hasChanges,
    );
  }
}

/// Controller for notification settings.
class NotificationSettingsController extends Notifier<NotificationSettingsState> {
  late final NotificationSettingsRepository _repository;

  @override
  NotificationSettingsState build() {
    _repository = ref.watch(notificationSettingsRepositoryProvider);
    return const NotificationSettingsState();
  }

  /// Loads the current notification settings.
  Future<void> loadSettings() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _repository.getSettings();

    if (result.failure != null) {
      state = state.copyWith(isLoading: false, errorMessage: result.failure!.message);
      return;
    }

    final settings = result.data ?? const NotificationSettings();
    state = state.copyWith(
      isLoading: false,
      settings: settings,
      originalSettings: settings,
      hasChanges: false,
    );
  }

  /// Saves the current settings.
  Future<bool> saveSettings() async {
    if (state.isSaving || !state.hasChanges) return false;

    state = state.copyWith(isSaving: true, clearError: true);

    final result = await _repository.updateSettings(state.settings);

    if (result.failure != null) {
      state = state.copyWith(isSaving: false, errorMessage: result.failure!.message);
      return false;
    }

    state = state.copyWith(
      isSaving: false,
      isSuccess: true,
      originalSettings: state.settings,
      hasChanges: false,
    );

    return true;
  }

  /// Resets settings to defaults.
  Future<void> resetToDefaults() async {
    if (state.isSaving) return;

    state = state.copyWith(isSaving: true, clearError: true);

    final result = await _repository.resetToDefaults();

    if (result.failure != null) {
      state = state.copyWith(isSaving: false, errorMessage: result.failure!.message);
      return;
    }

    final settings = result.data ?? const NotificationSettings();
    state = state.copyWith(
      isSaving: false,
      isSuccess: true,
      settings: settings,
      originalSettings: settings,
      hasChanges: false,
    );
  }

  /// Resets to original settings (discards changes).
  void discardChanges() {
    state = state.copyWith(settings: state.originalSettings, hasChanges: false, clearError: true);
  }

  void _updateSettings(NotificationSettings newSettings) {
    state = state.copyWith(
      settings: newSettings,
      hasChanges: newSettings != state.originalSettings,
    );
  }

  // ==================== General Settings ====================

  void setPushEnabled(bool value) {
    _updateSettings(state.settings.copyWith(pushEnabled: value));
  }

  void setEmailEnabled(bool value) {
    _updateSettings(state.settings.copyWith(emailEnabled: value));
  }

  void setSmsEnabled(bool value) {
    _updateSettings(state.settings.copyWith(smsEnabled: value));
  }

  void setInAppEnabled(bool value) {
    _updateSettings(state.settings.copyWith(inAppEnabled: value));
  }

  // ==================== Delivery Settings ====================

  void setSoundEnabled(bool value) {
    _updateSettings(state.settings.copyWith(soundEnabled: value));
  }

  void setVibrationEnabled(bool value) {
    _updateSettings(state.settings.copyWith(vibrationEnabled: value));
  }

  void setBadgeEnabled(bool value) {
    _updateSettings(state.settings.copyWith(badgeEnabled: value));
  }

  void setPreviewEnabled(bool value) {
    _updateSettings(state.settings.copyWith(previewEnabled: value));
  }

  // ==================== Social Notifications ====================

  void setMessagesEnabled(bool value) {
    _updateSettings(state.settings.copyWith(messagesEnabled: value));
  }

  void setMentionsEnabled(bool value) {
    _updateSettings(state.settings.copyWith(mentionsEnabled: value));
  }

  void setCommentsEnabled(bool value) {
    _updateSettings(state.settings.copyWith(commentsEnabled: value));
  }

  void setLikesEnabled(bool value) {
    _updateSettings(state.settings.copyWith(likesEnabled: value));
  }

  void setFollowsEnabled(bool value) {
    _updateSettings(state.settings.copyWith(followsEnabled: value));
  }

  void setDirectMessagesEnabled(bool value) {
    _updateSettings(state.settings.copyWith(directMessagesEnabled: value));
  }

  void setGroupMessagesEnabled(bool value) {
    _updateSettings(state.settings.copyWith(groupMessagesEnabled: value));
  }

  // ==================== Other Notifications ====================

  void setPromotionalEnabled(bool value) {
    _updateSettings(state.settings.copyWith(promotionalEnabled: value));
  }

  void setUpdatesEnabled(bool value) {
    _updateSettings(state.settings.copyWith(updatesEnabled: value));
  }

  void setSecurityAlertsEnabled(bool value) {
    _updateSettings(state.settings.copyWith(securityAlertsEnabled: value));
  }

  void setReminderEnabled(bool value) {
    _updateSettings(state.settings.copyWith(reminderEnabled: value));
  }

  // ==================== Quiet Hours ====================

  void setQuietHoursEnabled(bool value) {
    _updateSettings(state.settings.copyWith(quietHoursEnabled: value));
  }

  void setQuietHoursStart(int? hour) {
    _updateSettings(state.settings.copyWith(quietHoursStart: hour));
  }

  void setQuietHoursEnd(int? hour) {
    _updateSettings(state.settings.copyWith(quietHoursEnd: hour));
  }

  /// Clears the error message.
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  /// Clears the success state.
  void clearSuccess() {
    state = state.copyWith(isSuccess: false);
  }
}
