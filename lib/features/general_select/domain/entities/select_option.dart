class SelectOption {
  final String id;
  final String label;
  final String? value;
  final String? description;
  final String? imageUrl;
  final bool isEnabled;
  final Map<String, dynamic>? metadata;

  const SelectOption({
    required this.id,
    required this.label,
    this.value,
    this.description,
    this.imageUrl,
    this.isEnabled = true,
    this.metadata,
  });

  SelectOption copyWith({
    String? id,
    String? label,
    String? value,
    String? description,
    String? imageUrl,
    bool? isEnabled,
    Map<String, dynamic>? metadata,
  }) {
    return SelectOption(
      id: id ?? this.id,
      label: label ?? this.label,
      value: value ?? this.value,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      isEnabled: isEnabled ?? this.isEnabled,
      metadata: metadata ?? this.metadata,
    );
  }
}
