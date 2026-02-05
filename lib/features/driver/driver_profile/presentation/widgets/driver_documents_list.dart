import 'package:flutter/material.dart';
import 'package:flavorizr/features/driver/driver_profile/domain/entities/driver_document.dart';

/// Widget for displaying driver documents list.
class DriverDocumentsList extends StatelessWidget {
  final List<DriverDocument> documents;
  final bool isLoading;
  final Function(String) onDelete;

  const DriverDocumentsList({
    super.key,
    required this.documents,
    this.isLoading = false,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.description,
                  size: 32,
                  color: Colors.blue,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Documents',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: isLoading
                      ? null
                      : () {
                          Navigator.pushNamed(context, '/driver/documents/upload');
                        },
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (documents.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text(
                    'No documents uploaded yet',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: documents.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final document = documents[index];
                  return _buildDocumentItem(document);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentItem(DriverDocument document) {
    Color statusColor;
    String statusText;

    if (document.isVerified) {
      statusColor = Colors.green;
      statusText = 'Verified';
    } else if (document.rejectionReason != null) {
      statusColor = Colors.red;
      statusText = 'Rejected';
    } else {
      statusColor = Colors.orange;
      statusText = 'Pending';
    }

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: statusColor.withOpacity(0.1),
        child: Icon(
          _getDocumentIcon(document.documentType),
          color: statusColor,
        ),
      ),
      title: Text(document.documentType),
      subtitle: Text(document.documentNumber),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              statusText,
              style: TextStyle(
                color: statusColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (document.rejectionReason != null) ...[
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                // Show rejection reason
              },
            ),
          ],
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => onDelete(document.id),
          ),
        ],
      ),
    );
  }

  IconData _getDocumentIcon(String documentType) {
    switch (documentType.toLowerCase()) {
      case 'driver license':
        return Icons.badge;
      case 'vehicle registration':
        return Icons.directions_car;
      case 'insurance':
        return Icons.security;
      case 'id card':
        return Icons.credit_card;
      default:
        return Icons.description;
    }
  }
}