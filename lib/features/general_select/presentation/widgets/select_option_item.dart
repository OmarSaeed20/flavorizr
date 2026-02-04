import 'package:flutter/material.dart';
import 'package:flavorizr/features/general_select/domain/entities/select_option.dart';

/// Widget for displaying a single select option.
class SelectOptionItem extends StatelessWidget {
  final SelectOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectOptionItem({
    super.key,
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: option.isEnabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor.withOpacity(0.1)
              : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[300]!,
              width: 1.0,
            ),
          ),
        ),
        child: Row(
          children: [
            if (option.imageUrl != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  option.imageUrl!,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 48,
                      height: 48,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image, color: Colors.grey),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: option.isEnabled
                          ? Colors.black87
                          : Colors.grey[400],
                    ),
                  ),
                  if (option.description != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      option.description!,
                      style: TextStyle(
                        fontSize: 14,
                        color: option.isEnabled
                            ? Colors.grey[600]
                            : Colors.grey[400],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).primaryColor,
              ),
          ],
        ),
      ),
    );
  }
}