import 'package:flutter/material.dart';
import 'package:rumahku/utils/app_theme.dart';

class RequestAdminCard extends StatelessWidget {
  final String title;
  final String date;
  final VoidCallback onViewTap;
  final VoidCallback onApproveTap;
  final VoidCallback onRejectTap;

  const RequestAdminCard({
    super.key,
    required this.title,
    required this.date,
    required this.onViewTap,
    required this.onApproveTap,
    required this.onRejectTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              date,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                // View Button
                Expanded(
                  child: OutlinedButton(
                    onPressed: onViewTap,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppTheme.primaryColor),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: const Text('Lihat'),
                  ),
                ),
                const SizedBox(width: 8),
                // Approve Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: onApproveTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: const Text('Terima'),
                  ),
                ),
                const SizedBox(width: 8),
                // Reject Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: onRejectTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: const Text('Tolak'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}