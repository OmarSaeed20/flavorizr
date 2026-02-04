// lib/features/general_select/data/endpoints/general_select_endpoints.dart
/// Defines all API endpoints for general select operations.
abstract class GeneralSelectEndpoints {
  const GeneralSelectEndpoints._();

  /// Gets all locations.
  static const String locations = '/general/locations';

  /// Gets a specific location by ID.
  static String locationById(String locationId) => '/general/locations/$locationId';

  /// Searches locations.
  static const String searchLocations = '/general/locations/search';

  /// Gets all vehicle types.
  static const String vehicleTypes = '/general/vehicle-types';

  /// Gets a specific vehicle type by ID.
  static String vehicleTypeById(String typeId) => '/general/vehicle-types/$typeId';

  /// Gets all payment methods.
  static const String paymentMethods = '/general/payment-methods';

  /// Gets a specific payment method by ID.
  static String paymentMethodById(String methodId) => '/general/payment-methods/$methodId';

  /// Gets all trip types.
  static const String tripTypes = '/general/trip-types';

  /// Gets a specific trip type by ID.
  static String tripTypeById(String typeId) => '/general/trip-types/$typeId';

  /// Gets all service areas.
  static const String serviceAreas = '/general/service-areas';

  /// Gets a specific service area by ID.
  static String serviceAreaById(String areaId) => '/general/service-areas/$areaId';

  /// Gets all promo codes.
  static const String promoCodes = '/general/promo-codes';

  /// Validates a promo code.
  static const String validatePromoCode = '/general/promo-codes/validate';

  /// Gets all support categories.
  static const String supportCategories = '/general/support/categories';

  /// Gets all FAQs.
  static const String faqs = '/general/faqs';

  /// Gets app configuration.
  static const String appConfig = '/general/config';

  /// Gets app version info.
  static const String appVersion = '/general/version';
}
