/// Parameters for updating driver privacy settings.
///
/// Based on the FAST App API documentation for POST /driver/settings/privacy
class UpdatePrivacyParameters {
  final bool? showPhone;
  final bool? showLocation;
  final bool? allowRatings;

  UpdatePrivacyParameters({this.showPhone, this.showLocation, this.allowRatings});

  Map<String, dynamic> toJson() {
    return {
      if (showPhone != null) 'show_phone': showPhone,
      if (showLocation != null) 'show_location': showLocation,
      if (allowRatings != null) 'allow_ratings': allowRatings,
    };
  }
}
