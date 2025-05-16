import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:project_akhir/models/assistance_request_model.dart';
import 'package:project_akhir/services/assistance_service.dart';

class RequestDetailScreen extends StatefulWidget {
  final String requestId;
  final bool isReadOnly;

  const RequestDetailScreen({
    super.key,
    required this.requestId,
    this.isReadOnly = false,
  });

  @override
  State<RequestDetailScreen> createState() => _RequestDetailScreenState();
}

class _RequestDetailScreenState extends State<RequestDetailScreen> {
  final AssistanceService _assistanceService = AssistanceService();
  AssistanceRequestModel? _request;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadRequestDetails();
  }

  Future<void> _loadRequestDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      _request = await _assistanceService.getRequestById(widget.requestId);
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _approveRequest() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await _assistanceService.approveRequest(widget.requestId, '');
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        
        // Show success dialog and navigate back
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Permintaan bantuan berhasil disetujui'),
            backgroundColor: Colors.green,
          ),
        );
        
        Navigator.pop(context); // Go back to requests list
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        
        // Show error dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _rejectRequest() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await _assistanceService.rejectRequest(widget.requestId, '');
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        
        // Show success dialog and navigate back
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Permintaan bantuan berhasil ditolak'),
            backgroundColor: Colors.orange,
          ),
        );
        
        Navigator.pop(context); // Go back to requests list
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        
        // Show error dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_request?.name ?? 'Usulan ke-1'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: const Color(0xFF8B0000),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error: $_errorMessage',
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _loadRequestDetails,
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Personal Information
                      const Text(
                        'Data Individu',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              _buildInfoRow('Nomor Kartu Keluarga', _request!.familyCardNumber),
                              _buildInfoRow('NIK', _request!.nik),
                              _buildInfoRow('Nama Lengkap', _request!.name),
                              _buildInfoRow('Tempat Lahir', _request!.birthPlace),
                              _buildInfoRow('Tanggal Lahir', DateFormat('dd MMMM yyyy').format(_request!.birthDate)),
                              _buildInfoRow('Jenis Kelamin', _request!.gender),
                              _buildInfoRow('Pekerjaan', _request!.occupation),
                              _buildInfoRow('Status Perkawinan', _request!.maritalStatus),
                              _buildInfoRow('Provinsi', _request!.province),
                              _buildInfoRow('Kabupaten/Kota', _request!.city),
                              _buildInfoRow('Kecamatan', _request!.district),
                              _buildInfoRow('Kelurahan/Desa', _request!.village),
                              _buildInfoRow('Alamat Lengkap', _request!.fullAddress),
                              _buildInfoRow('Email', _request!.email),
                              _buildInfoRow('Nomor Telepon', _request!.phoneNumber),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // House Information
                      const Text(
                        'Data Rumah',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              _buildInfoRow('Tahun Bangunan', _request!.buildingYear),
                              _buildInfoRow('Status Kepemilikan', _request!.ownershipStatus),
                              _buildInfoRow('Tegangan Listrik', _request!.electricityCapacity),
                              _buildInfoRow('Status Perairan', _request!.waterStatus),
                              _buildInfoRow('Luas Bangunan', _request!.buildingArea),
                              _buildInfoRow('Luas Tanah', _request!.landArea),
                              _buildInfoRow('Tipe Bangunan', _request!.buildingType),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // House Photos
                      const Text(
                        'Foto Rumah',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (_request!.photoUrls.isNotEmpty)
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: _request!.photoUrls.length,
                          itemBuilder: (context, index) {
                            return Card(
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 2,
                              child: CachedNetworkImage(
                                imageUrl: _request!.photoUrls[index],
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: Colors.grey[300],
                                  child: const Center(child: CircularProgressIndicator()),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.error),
                                ),
                              ),
                            );
                          },
                        ),
                      
                      if (!widget.isReadOnly) ...[
                        const SizedBox(height: 32),
                        
                        // Action buttons
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _approveRequest,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: const Text('Terima'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _rejectRequest,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: const Text('Tolak'),
                              ),
                            ),
                          ],
                        ),
                      ],
                      
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}