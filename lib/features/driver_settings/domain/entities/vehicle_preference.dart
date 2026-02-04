/// Entity representing vehicle preference.
class VehiclePreference {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final bool isSelected;

  const VehiclePreference({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    required this.isSelected,
  });
}