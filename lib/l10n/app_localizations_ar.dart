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
}
