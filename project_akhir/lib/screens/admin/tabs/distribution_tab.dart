import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_akhir/models/assistance_request_model.dart';
import 'package:project_akhir/screens/admin/request_detail_screen.dart';
import 'package:project_akhir/services/assistance_service.dart';

class DistributionTab extends StatefulWidget {
  const DistributionTab({super.key});

  @override
  State<DistributionTab> createState() => _DistributionTabState();
}

class _DistributionTabState extends State<DistributionTab> {
  final AssistanceService _assistanceService = AssistanceService();
  List<AssistanceRequestModel> _approvedRequests = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadApprovedRequests();
  }

  Future<void> _loadApprovedRequests() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      _approvedRequests = await _assistanceService.getAllApprovedRequests();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Penyaluran Bantuan'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF8B0000),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Penyaluran Bantuan Kepada Masyarakat',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Berikut data berupa penyaluran bantuan:',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
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
                              onPressed: _loadApprovedRequests,
                              child: const Text('Coba Lagi'),
                            ),
                          ],
                        ),
                      )
                    : _approvedRequests.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Belum ada penyaluran bantuan',
                                  style: TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: _loadApprovedRequests,
                                  child: const Text('Refresh'),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _approvedRequests.length,
                            itemBuilder: (context, index) {
                              final request = _approvedRequests[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => RequestDetailScreen(
                                          requestId: request.id,
                                          isReadOnly: true,
                                        ),
                                      ),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Penyaluran unit-${index + 1}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Tanggal disalurkan: ${DateFormat('dd MMMM yyyy').format(request.approvalDate ?? request.requestDate)}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Penerima: ${request.name}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Alamat: ${request.fullAddress}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}