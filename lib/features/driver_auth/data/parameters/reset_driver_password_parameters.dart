/// Parameters for resetting driver password.
class ResetDriverPasswordParameters {
  final String phone;
  final String newPassword;
  final String otp;

  ResetDriverPasswordParameters({
    required this.phone,
    required this.newPassword,
    required this.otp,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'new_password': newPassword,
      'otp': otp,
    };
  }
}