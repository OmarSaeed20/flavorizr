// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'Flavorizr';

  @override
  String get settings => 'الإعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get appearance => 'المظهر';

  @override
  String get theme => 'السمة';

  @override
  String get system => 'النظام';

  @override
  String get light => 'فاتح';

  @override
  String get dark => 'داكن';

  @override
  String get selectLanguage => 'اختر اللغة';

  @override
  String get account => 'الحساب';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get editProfileSubtitle => 'تحديث معلومات الملف الشخصي';

  @override
  String get profileSettings => 'إعدادات الملف الشخصي';

  @override
  String get profileSettingsSubtitle => 'إدارة ظهور الملف الشخصي والتفضيلات';

  @override
  String get appSettings => 'إعدادات التطبيق';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get notificationsSubtitle => 'إدارة تفضيلات الإشعارات';

  @override
  String get appearanceSubtitle => 'السمة والألوان وخيارات العرض';

  @override
  String get languageSubtitle => 'تغيير لغة التطبيق';

  @override
  String get privacySecurity => 'الخصوصية والأمان';

  @override
  String get privacy => 'الخصوصية';

  @override
  String get privacySubtitle => 'التحكم في بياناتك وظهورها';

  @override
  String get security => 'الأمان';

  @override
  String get securitySubtitle =>
      'كلمة المرور والمصادقة الثنائية وخيارات تسجيل الدخول';

  @override
  String get support => 'الدعم';

  @override
  String get helpCenter => 'مركز المساعدة';

  @override
  String get helpCenterSubtitle => 'الحصول على المساعدة والدعم';

  @override
  String get sendFeedback => 'إرسال ملاحظات';

  @override
  String get sendFeedbackSubtitle => 'ساعدنا في تحسين التطبيق';

  @override
  String get about => 'حول';

  @override
  String get aboutSubtitle => 'معلومات التطبيق والقانونية';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get signOutConfirmation => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get version => 'الإصدار';

  @override
  String get justNow => 'الآن';

  @override
  String minutesAgo(Object count) {
    return 'منذ $count دقيقة';
  }

  @override
  String hoursAgo(Object count) {
    return 'منذ $count ساعة';
  }

  @override
  String daysAgo(Object count) {
    return 'منذ $count يوم';
  }

  @override
  String get yesterday => 'أمس';

  @override
  String durationHoursMinutes(Object hours, Object minutes) {
    return '$hoursس $minutesد';
  }

  @override
  String durationMinutesSeconds(Object minutes, Object seconds) {
    return '$minutesد $secondsث';
  }

  @override
  String durationSeconds(Object seconds) {
    return '$secondsث';
  }

  @override
  String get bytes => 'بايت';

  @override
  String get kb => 'كيلوبايت';

  @override
  String get mb => 'ميجابايت';

  @override
  String get gb => 'جيجابايت';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get error => 'خطأ';

  @override
  String get success => 'نجح';

  @override
  String get warning => 'تحذير';

  @override
  String get info => 'معلومات';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get close => 'إغلاق';

  @override
  String get ok => 'موافق';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get save => 'حفظ';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get add => 'إضافة';

  @override
  String get remove => 'إزالة';

  @override
  String get search => 'بحث';

  @override
  String get filter => 'تصفية';

  @override
  String get sort => 'ترتيب';

  @override
  String get refresh => 'تحديث';

  @override
  String get share => 'مشاركة';

  @override
  String get copy => 'نسخ';

  @override
  String get paste => 'لصق';

  @override
  String get clear => 'مسح';

  @override
  String get submit => 'إرسال';

  @override
  String get confirm => 'تأكيد';

  @override
  String get back => 'رجوع';

  @override
  String get next => 'التالي';

  @override
  String get previous => 'السابق';

  @override
  String get done => 'تم';

  @override
  String get skip => 'تخطي';

  @override
  String get continueAction => 'متابعة';

  @override
  String get finish => 'إنهاء';

  @override
  String get companyLogin => 'تسجيل دخول الشركة';

  @override
  String get companyLoginSubtitle => 'سجل الدخول إلى حساب شركتك';

  @override
  String get companyRegister => 'تسجيل شركة جديدة';

  @override
  String get companyRegisterSubtitle => 'إنشاء حساب شركة جديد';

  @override
  String get companyName => 'اسم الشركة';

  @override
  String get companyNameHint => 'أدخل اسم شركتك';

  @override
  String get companyPhone => 'هاتف الشركة';

  @override
  String get companyPhoneHint => 'أدخل رقم هاتف شركتك';

  @override
  String get companyEmail => 'بريد الشركة الإلكتروني';

  @override
  String get companyEmailHint => 'أدخل بريد شركتك الإلكتروني';

  @override
  String get companyAddress => 'عنوان الشركة';

  @override
  String get companyAddressHint => 'أدخل عنوان شركتك';

  @override
  String get companyForgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get companyForgotPasswordSubtitle =>
      'أدخل بريدك الإلكتروني لإعادة تعيين كلمة المرور';

  @override
  String get companyResetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get companyResetPasswordSubtitle => 'إنشاء كلمة مرور جديدة';

  @override
  String get companyVerifyPhone => 'تأكيد الهاتف';

  @override
  String get companyVerifyPhoneSubtitle => 'أدخل رمز التحقق المرسل إلى هاتفك';

  @override
  String get verificationCode => 'رمز التحقق';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟';

  @override
  String get register => 'تسجيل';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get phoneNumberHint => 'أدخل رقم هاتفك';

  @override
  String get phoneNumberRequired => 'رقم الهاتف مطلوب';

  @override
  String get invalidPhoneNumber => 'رقم هاتف غير صالح';

  @override
  String get verificationCodeHint => 'أدخل الرمز المكون من 6 أرقام';

  @override
  String get resendCode => 'إعادة إرسال الرمز';

  @override
  String resendCodeIn(Object seconds) {
    return 'إعادة الإرسال خلال $seconds ثانية';
  }

  @override
  String get welcomeBack => 'مرحباً بعودتك';

  @override
  String get loginToContinue => 'سجل الدخول للمتابعة';

  @override
  String get password => 'كلمة المرور';

  @override
  String get passwordHint => 'أدخل كلمة المرور';

  @override
  String get passwordRequired => 'كلمة المرور مطلوبة';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get loginWithBiometric => 'تسجيل الدخول بالبصمة';

  @override
  String get companyLoginSuccess => 'تم تسجيل الدخول بنجاح';

  @override
  String get companyRegisterSuccess => 'تم التسجيل بنجاح';

  @override
  String get companyPhoneVerified => 'تم تأكيد الهاتف بنجاح';

  @override
  String get companyProfile => 'ملف الشركة';

  @override
  String get companyProfileSubtitle => 'إدارة معلومات شركتك';

  @override
  String get editCompanyProfile => 'تعديل ملف الشركة';

  @override
  String get editCompanyProfileSubtitle => 'تحديث تفاصيل شركتك';

  @override
  String get companyLogo => 'شعار الشركة';

  @override
  String get changeLogo => 'تغيير الشعار';

  @override
  String get removeLogo => 'إزالة الشعار';

  @override
  String get companyDetails => 'تفاصيل الشركة';

  @override
  String get businessLicense => 'رخصة العمل';

  @override
  String get taxId => 'الرقم الضريبي';

  @override
  String get taxIdHint => 'أدخل الرقم الضريبي الخاص بك';

  @override
  String get updateProfile => 'تحديث الملف';

  @override
  String get profileUpdated => 'تم تحديث الملف بنجاح';

  @override
  String get logoUpdated => 'تم تحديث الشعار بنجاح';

  @override
  String get logoRemoved => 'تم إزالة الشعار بنجاح';

  @override
  String get companySettings => 'إعدادات الشركة';

  @override
  String get companySettingsSubtitle => 'إدارة إعدادات شركتك';

  @override
  String get aboutUs => 'من نحن';

  @override
  String get aboutUsSubtitle => 'تعرف على تاكسي الذهبي السريع';

  @override
  String get faq => 'الأسئلة الشائعة';

  @override
  String get faqSubtitle => 'الأسئلة المتكررة';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get privacyPolicySubtitle => 'اقرأ سياسة الخصوصية الخاصة بنا';

  @override
  String get termsOfService => 'شروط الخدمة';

  @override
  String get termsOfServiceSubtitle => 'اقرأ شروط الخدمة الخاصة بنا';

  @override
  String get contactSupport => 'اتصل بالدعم';

  @override
  String get contactSupportSubtitle => 'احصل على المساعدة من فريق الدعم لدينا';

  @override
  String get reportProblem => 'الإبلاغ عن مشكلة';

  @override
  String get reportProblemSubtitle => 'الإبلاغ عن مشكلة أو خطأ';

  @override
  String get companyNotifications => 'الإشعارات';

  @override
  String get companyNotificationsSubtitle => 'إدارة تفضيلات الإشعارات';

  @override
  String get companySecurity => 'الأمان';

  @override
  String get companySecuritySubtitle => 'كلمة المرور وإعدادات الأمان';

  @override
  String get companyLanguage => 'اللغة';

  @override
  String get companyLanguageSubtitle => 'تغيير لغة التطبيق';

  @override
  String get companyTheme => 'السمة';

  @override
  String get companyThemeSubtitle => 'تغيير سمة التطبيق';

  @override
  String get appVersion => 'إصدار التطبيق';

  @override
  String get roleSelection => 'اختر دورك';

  @override
  String get roleSelectionSubtitle =>
      'اختر كيف تريد استخدام تاكسي الذهبي السريع';

  @override
  String get consumerRole => 'عميل';

  @override
  String get consumerRoleDescription => 'احجز رحلات وسافر براحة';

  @override
  String get driverRole => 'سائق';

  @override
  String get driverRoleDescription => 'اكسب المال من خلال القيادة';

  @override
  String get companyRole => 'شركة';

  @override
  String get companyRoleDescription => 'أدر أسطولك بكفاءة';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟';
}
