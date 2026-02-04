/// Parameters for verifying driver phone number.
class VerifyDriverPhoneParameters {
  final String phone;
  final String otp;

  VerifyDriverPhoneParameters({
    required this.phone,
    required this.otp,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'otp': otp,
    };
  }
}