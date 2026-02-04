/// Parameters for driver login.
class DriverLoginParameters {
  final String phone;
  final String password;

  DriverLoginParameters({required this.phone, required this.password});

  Map<String, dynamic> toJson() {
    return {'phone': phone, 'password': password};
  }
}
