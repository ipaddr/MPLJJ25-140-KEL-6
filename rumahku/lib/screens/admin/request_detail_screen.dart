import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rumahku/providers/request_provider.dart';
import 'package:rumahku/utils/app_theme.dart';
import 'package:rumahku/widgets/detail_item.dart';
import 'package:rumahku/widgets/loading_indicator.dart';

class RequestDetailScreen extends StatefulWidget {
  final String requestId;

  const RequestDetailScreen({
    super.key,
    required this.requestId,
  });

  @override
  State<RequestDetailScreen> createState() => _RequestDetailScreenState();
}

class _RequestDetailScreenState extends State<RequestDetailScreen> {
  @override
  void initState() {
    super.initState();
    _loadRequestDetails();
  }

  Future<void> _loadRequestDetails() async {
    final requestProvider = Provider.of<RequestProvider>(context, listen: false);
    await requestProvider.getRequestById(widget.requestId);
  }

  @override
  Widget build(BuildContext context) {
    final requestProvider = Provider.of<RequestProvider>(context);
    final request = requestProvider.currentRequest;

    return Scaffold(
      appBar: AppBar(
        title: request != null
            ? Text('Usulan ke-${request.requestNumber}')
            : const Text('Detail Permintaan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (request != null && request.status == 'pending')
            PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'approve') {
                  final success = await requestProvider.approveRequest(request.id);
                  if (success && mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Permintaan berhasil disetujui'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(context);
                  }
                } else if (value == 'reject') {
                  final success = await requestProvider.rejectRequest(request.id);
                  if (success && mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Permintaan berhasil ditolak'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                    Navigator.pop(context);
                  }
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'approve',
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green),
                      SizedBox(width: 8),
                      Text('Setujui'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'reject',
                  child: Row(
                    children: [
                      Icon(Icons.cancel, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Tolak'),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: requestProvider.isLoading
          ? const Center(child: LoadingIndicator())
          : request == null
              ? const Center(child: Text('Permintaan tidak ditemukan'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Usulan ke-${request.requestNumber}',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tanggal Pengajuan: ${DateFormat('dd MMMM yyyy').format(request.submissionDate)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Status: ${request.status == 'pending' ? 'Menunggu Persetujuan' : request.status == 'approved' ? 'Disetujui' : 'Ditolak'}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: request.status == 'pending'
                              ? Colors.orange
                              : request.status == 'approved'
                                  ? Colors.green
                                  : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      // Personal Data Section
                      Text(
                        'Data Individu',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      DetailItem(label: 'Nomor Kartu Keluarga', value: request.familyCardNumber),
                      DetailItem(label: 'NIK', value: request.nik),
                      DetailItem(label: 'Nama Lengkap', value: request.fullName),
                      DetailItem(label: 'Tempat Lahir', value: request.birthPlace),
                      DetailItem(
                        label: 'Tanggal Lahir',
                        value: DateFormat('dd MMMM yyyy').format(request.birthDate),
                      ),
                      DetailItem(label: 'Jenis Kelamin', value: request.gender),
                      DetailItem(label: 'Pekerjaan', value: request.occupation),
                      DetailItem(label: 'Status Perkawinan', value: request.maritalStatus),
                      DetailItem(label: 'Provinsi', value: request.province),
                      DetailItem(label: 'Kabupaten/Kota', value: request.city),
                      DetailItem(label: 'Kecamatan', value: request.district),
                      DetailItem(label: 'Kelurahan/Desa', value: request.village),
                      DetailItem(label: 'Alamat Lengkap', value: request.fullAddress),
                      DetailItem(label: 'Email', value: request.email),
                      DetailItem(label: 'Nomor Telepon', value: request.phoneNumber),
                      
                      const SizedBox(height: 24),
                      // House Data Section
                      Text(
                        'Data Rumah',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      DetailItem(label: 'Tahun Bangunan', value: request.buildingYear),
                      DetailItem(label: 'Status Kepemilikan', value: request.ownershipStatus),
                      DetailItem(label: 'Tegangan Listrik', value: request.electricVoltage),
                      DetailItem(label: 'Status Perairan', value: request.waterStatus),
                      DetailItem(
                        label: 'Luas Bangunan',
                        value: '${request.buildingArea} m²',
                      ),
                      DetailItem(
                        label: 'Luas Tanah',
                        value: '${request.landArea} m²',
                      ),
                      DetailItem(label: 'Tipe Bangunan', value: request.buildingType),
                      
                      const SizedBox(height: 24),
                      // House Photos Section
                      Text(
                        'Foto Rumah',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      if (request.frontPhotoUrl.isNotEmpty || request.backPhotoUrl.isNotEmpty) ...[
                        Row(
                          children: [
                            if (request.frontPhotoUrl.isNotEmpty)
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Tampak Depan'),
                                    const SizedBox(height: 8),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: CachedNetworkImage(
                                        imageUrl: request.frontPhotoUrl,
                                        fit: BoxFit.cover,
                                        height: 150,
                                        placeholder: (context, url) => const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (request.frontPhotoUrl.isNotEmpty && request.backPhotoUrl.isNotEmpty)
                              const SizedBox(width: 16),
                            if (request.backPhotoUrl.isNotEmpty)
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Tampak Belakang'),
                                    const SizedBox(height: 8),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: CachedNetworkImage(
                                        imageUrl: request.backPhotoUrl,
                                        fit: BoxFit.cover,
                                        height: 150,
                                        placeholder: (context, url) => const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ] else
                        const Text('Tidak ada foto yang diunggah'),
                        
                      const SizedBox(height: 32),
                      
                      // Action Buttons
                      if (request.status == 'pending')
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  final confirmed = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Konfirmasi Persetujuan'),
                                      content: const Text('Apakah Anda yakin ingin menyetujui permintaan ini?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, false),
                                          child: const Text('Batal'),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, true),
                                          child: const Text('Ya, Setuju'),
                                        ),
                                      ],
                                    ),
                                  );
                                  
                                  if (confirmed == true) {
                                    final success = await requestProvider.approveRequest(request.id);
                                    if (success && mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Permintaan berhasil disetujui'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                      Navigator.pop(context);
                                    }
                                  }
                                },
                                icon: const Icon(Icons.check_circle),
                                label: const Text('Terima'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () async {
                                  final confirmed = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Konfirmasi Penolakan'),
                                      content: const Text('Apakah Anda yakin ingin menolak permintaan ini?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, false),
                                          child: const Text('Batal'),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, true),
                                          child: const Text('Ya, Tolak'),
                                        ),
                                      ],
                                    ),
                                  );
                                  
                                  if (confirmed == true) {
                                    final success = await requestProvider.rejectRequest(request.id);
                                    if (success && mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Permintaan berhasil ditolak'),
                                          backgroundColor: Colors.orange,
                                        ),
                                      );
                                      Navigator.pop(context);
                                    }
                                  }
                                },
                                icon: const Icon(Icons.cancel),
                                label: const Text('Tolak'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
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