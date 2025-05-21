import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:rumahku/utils/app_theme.dart';

class ImagePickerField extends StatelessWidget {
  final String label;
  final Uint8List? imageData;
  final VoidCallback onTap;

  const ImagePickerField({
    super.key,
    required this.label,
    this.imageData,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: imageData != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(
                      imageData!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_a_photo,
                        color: AppTheme.primaryColor,
                        size: 36,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Pilih Foto',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}