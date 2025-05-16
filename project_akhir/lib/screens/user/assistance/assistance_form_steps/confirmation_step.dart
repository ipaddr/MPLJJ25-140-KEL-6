import 'dart:io';
import 'package:flutter/material.dart';
import 'package:project_akhir/screens/user/assistance/assistance_form_screen.dart';
import 'package:project_akhir/services/assistance_service.dart';

class ConfirmationStep extends StatefulWidget {
  final FormData formData;
  final VoidCallback onSubmit;

  const ConfirmationStep({
    super.key,
    required this.formData,
    required this.onSubmit,
  });

  @override
  State<ConfirmationStep> createState() => _ConfirmationStepState();
}

class _ConfirmationStepState extends State<ConfirmationStep> {
  final AssistanceService _assistanceService = AssistanceService();
  bool _isSubmitting = false;
  String? _errorMessage;

  Future<void> _submitRequest() async {
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      // Validate all required fields are filled
      if (widget.formData.familyCardNumber == null ||
          widget.formData.nik == null ||
          widget.formData.name == null ||
          widget.formData.birthPlace == null ||
          widget.formData.birthDate == null ||
          widget.formData.gender == null ||
          widget.formData.occupation == null ||
          widget.formData.maritalStatus == null ||
          widget.formData.province == null ||
          widget.formData.city == null ||
          widget.formData.district == null ||
          widget.formData.village == null ||
          widget.formData.fullAddress == null ||
          widget.formData.email == null ||
          widget.formData.phoneNumber == null ||
          widget.formData.buildingYear == null ||
          widget.formData.ownershipStatus == null ||
          widget.formData.electricityCapacity == null ||
          widget.formData.waterStatus == null ||
          widget.formData.buildingArea == null ||
          widget.formData.landArea == null ||
          widget.formData.buildingType == null ||
          widget.formData.photos == null ||
          widget.formData.photos!.isEmpty) {
        throw Exception('Mohon lengkapi semua data yang dibutuhkan');
      }

      await _assistanceService.submitRequest(
        familyCardNumber: widget.formData.familyCardNumber!,
        nik: widget.formData.nik!,
        name: widget.formData.name!,
        birthPlace: widget.formData.birthPlace!,
        birthDate: widget.formData.birthDate!,
        gender: widget.formData.gender!,
        occupation: widget.formData.occupation!,
        maritalStatus: widget.formData.maritalStatus!,
        province: widget.formData.province!,
        city: widget.formData.city!,
        district: widget.formData.district!,
        village: widget.formData.village!,
        fullAddress: widget.formData.fullAddress!,
        email: widget.formData.email!,
        phoneNumber: widget.formData.phoneNumber!,
        buildingYear: widget.formData.buildingYear!,
        ownershipStatus: widget.formData.ownershipStatus!,
        electricityCapacity: widget.formData.electricityCapacity!,
        waterStatus: widget.formData.waterStatus!,
        buildingArea: widget.formData.buildingArea!,
        landArea: widget.formData.landArea!,
        buildingType: widget.formData.buildingType!,
        photos: widget.formData.photos!.cast<File>(),
      );

      // Show success dialog
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('Sukses'),
            content: const Text('Permohonan bantuan berhasil diajukan.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  widget.onSubmit();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });

      // Show error dialog
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errorMessage ?? 'Terjadi kesalahan'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const Text(
            'Pastikan data anda terisi dengan benar!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8B0000),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Image.asset(
            'assets/images/confirmation.png',
            height: 150,
            errorBuilder: (context, error, stackTrace) {
              return Column(
                children: [
                  Icon(
                    Icons.fact_check,
                    size: 100,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Form Lengkap',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 40),
          Text(
            'Dengan menekan tombol Ajukan, anda menyatakan bahwa semua data yang telah diisi adalah benar dan dapat dipertanggungjawabkan.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                _errorMessage!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submitRequest,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B0000),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Ajukan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}