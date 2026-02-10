// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Flavorizr';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get appearance => 'Appearance';

  @override
  String get theme => 'Theme';

  @override
  String get system => 'System';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get account => 'Account';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get editProfileSubtitle => 'Update your profile information';

  @override
  String get profileSettings => 'Profile Settings';

  @override
  String get profileSettingsSubtitle =>
      'Manage profile visibility and preferences';

  @override
  String get appSettings => 'App Settings';

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationsSubtitle => 'Manage notification preferences';

  @override
  String get appearanceSubtitle => 'Theme, colors, and display options';

  @override
  String get languageSubtitle => 'Change app language';

  @override
  String get privacySecurity => 'Privacy & Security';

  @override
  String get privacy => 'Privacy';

  @override
  String get privacySubtitle => 'Control your data and visibility';

  @override
  String get security => 'Security';

  @override
  String get securitySubtitle => 'Password, 2FA, and login options';

  @override
  String get support => 'Support';

  @override
  String get helpCenter => 'Help Center';

  @override
  String get helpCenterSubtitle => 'Get help and support';

  @override
  String get sendFeedback => 'Send Feedback';

  @override
  String get sendFeedbackSubtitle => 'Help us improve the app';

  @override
  String get about => 'About';

  @override
  String get aboutSubtitle => 'App info and legal';

  @override
  String get signOut => 'Sign Out';

  @override
  String get signOutConfirmation => 'Are you sure you want to sign out?';

  @override
  String get cancel => 'Cancel';

  @override
  String get version => 'Version';

  @override
  String get justNow => 'Just now';

  @override
  String minutesAgo(Object count) {
    return '${count}m ago';
  }

  @override
  String hoursAgo(Object count) {
    return '${count}h ago';
  }

  @override
  String daysAgo(Object count) {
    return '${count}d ago';
  }

  @override
  String get yesterday => 'Yesterday';

  @override
  String durationHoursMinutes(Object hours, Object minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String durationMinutesSeconds(Object minutes, Object seconds) {
    return '${minutes}m ${seconds}s';
  }

  @override
  String durationSeconds(Object seconds) {
    return '${seconds}s';
  }

  @override
  String get bytes => 'B';

  @override
  String get kb => 'KB';

  @override
  String get mb => 'MB';

  @override
  String get gb => 'GB';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get warning => 'Warning';

  @override
  String get info => 'Info';

  @override
  String get retry => 'Retry';

  @override
  String get close => 'Close';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get add => 'Add';

  @override
  String get remove => 'Remove';

  @override
  String get search => 'Search';

  @override
  String get filter => 'Filter';

  @override
  String get sort => 'Sort';

  @override
  String get refresh => 'Refresh';

  @override
  String get share => 'Share';

  @override
  String get copy => 'Copy';

  @override
  String get paste => 'Paste';

  @override
  String get clear => 'Clear';

  @override
  String get submit => 'Submit';

  @override
  String get confirm => 'Confirm';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get previous => 'Previous';

  @override
  String get done => 'Done';

  @override
  String get skip => 'Skip';

  @override
  String get continueAction => 'Continue';

  @override
  String get finish => 'Finish';

  @override
  String get companyLogin => 'Company Login';

  @override
  String get companyLoginSubtitle => 'Sign in to your company account';

  @override
  String get companyRegister => 'Company Registration';

  @override
  String get companyRegisterSubtitle => 'Create a new company account';

  @override
  String get companyName => 'Company Name';

  @override
  String get companyNameHint => 'Enter your company name';

  @override
  String get companyPhone => 'Company Phone';

  @override
  String get companyPhoneHint => 'Enter your company phone number';

  @override
  String get companyEmail => 'Company Email';

  @override
  String get companyEmailHint => 'Enter your company email';

  @override
  String get companyAddress => 'Company Address';

  @override
  String get companyAddressHint => 'Enter your company address';

  @override
  String get companyForgotPassword => 'Forgot Password?';

  @override
  String get companyForgotPasswordSubtitle =>
      'Enter your email to reset password';

  @override
  String get companyResetPassword => 'Reset Password';

  @override
  String get companyResetPasswordSubtitle => 'Create a new password';

  @override
  String get companyVerifyPhone => 'Verify Phone';

  @override
  String get companyVerifyPhoneSubtitle =>
      'Enter the verification code sent to your phone';

  @override
  String get verificationCode => 'Verification Code';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get register => 'Register';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get phoneNumberHint => 'Enter your phone number';

  @override
  String get phoneNumberRequired => 'Phone number is required';

  @override
  String get invalidPhoneNumber => 'Invalid phone number';

  @override
  String get verificationCodeHint => 'Enter 6-digit code';

  @override
  String get resendCode => 'Resend Code';

  @override
  String resendCodeIn(Object seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get loginToContinue => 'Login to continue';

  @override
  String get password => 'Password';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get login => 'Login';

  @override
  String get loginWithBiometric => 'Login with Biometric';

  @override
  String get companyLoginSuccess => 'Login successful';

  @override
  String get companyRegisterSuccess => 'Registration successful';

  @override
  String get companyPhoneVerified => 'Phone verified successfully';

  @override
  String get companyProfile => 'Company Profile';

  @override
  String get companyProfileSubtitle => 'Manage your company information';

  @override
  String get editCompanyProfile => 'Edit Company Profile';

  @override
  String get editCompanyProfileSubtitle => 'Update your company details';

  @override
  String get companyLogo => 'Company Logo';

  @override
  String get changeLogo => 'Change Logo';

  @override
  String get removeLogo => 'Remove Logo';

  @override
  String get companyDetails => 'Company Details';

  @override
  String get businessLicense => 'Business License';

  @override
  String get taxId => 'Tax ID';

  @override
  String get taxIdHint => 'Enter your tax ID';

  @override
  String get updateProfile => 'Update Profile';

  @override
  String get profileUpdated => 'Profile updated successfully';

  @override
  String get logoUpdated => 'Logo updated successfully';

  @override
  String get logoRemoved => 'Logo removed successfully';

  @override
  String get companySettings => 'Company Settings';

  @override
  String get companySettingsSubtitle => 'Manage your company settings';

  @override
  String get aboutUs => 'About Us';

  @override
  String get aboutUsSubtitle => 'Learn about Fast Golden Taxi';

  @override
  String get faq => 'FAQ';

  @override
  String get faqSubtitle => 'Frequently asked questions';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get privacyPolicySubtitle => 'Read our privacy policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get termsOfServiceSubtitle => 'Read our terms of service';

  @override
  String get contactSupport => 'Contact Support';

  @override
  String get contactSupportSubtitle => 'Get help from our support team';

  @override
  String get reportProblem => 'Report a Problem';

  @override
  String get reportProblemSubtitle => 'Report an issue or bug';

  @override
  String get companyNotifications => 'Notifications';

  @override
  String get companyNotificationsSubtitle => 'Manage notification preferences';

  @override
  String get companySecurity => 'Security';

  @override
  String get companySecuritySubtitle => 'Password and security settings';

  @override
  String get companyLanguage => 'Language';

  @override
  String get companyLanguageSubtitle => 'Change app language';

  @override
  String get companyTheme => 'Theme';

  @override
  String get companyThemeSubtitle => 'Change app theme';

  @override
  String get appVersion => 'App Version';

  @override
  String get roleSelection => 'Select Your Role';

  @override
  String get roleSelectionSubtitle =>
      'Choose how you want to use Fast Golden Taxi';

  @override
  String get consumerRole => 'Consumer';

  @override
  String get consumerRoleDescription => 'Book rides and travel comfortably';

  @override
  String get driverRole => 'Driver';

  @override
  String get driverRoleDescription => 'Earn money by driving';

  @override
  String get companyRole => 'Company';

  @override
  String get companyRoleDescription => 'Manage your fleet efficiently';

  @override
  String get alreadyHaveAccount => 'Already have an account?';
}
