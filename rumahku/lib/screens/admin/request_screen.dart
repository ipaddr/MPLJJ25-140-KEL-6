import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rumahku/providers/request_provider.dart';
import 'package:rumahku/screens/admin/request_detail_screen.dart';
import 'package:rumahku/utils/app_theme.dart';
import 'package:rumahku/widgets/loading_indicator.dart';
import 'package:rumahku/widgets/request_admin_card.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    final requestProvider = Provider.of<RequestProvider>(context, listen: false);
    await requestProvider.fetchAllRequests();
  }

  @override
  Widget build(BuildContext context) {
    final requestProvider = Provider.of<RequestProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Permintaan Ajuan'),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _loadRequests,
        child: requestProvider.isLoading
            ? const Center(child: LoadingIndicator())
            : CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Permintaan Ajuan Bantuan',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Berikut data berupa permintaan bantuan:',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                  
                  // List of requests
                  requestProvider.requests.isEmpty
                      ? const SliverFillRemaining(
                          child: Center(
                            child: Text('Tidak ada permintaan yang menunggu persetujuan'),
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final request = requestProvider.requests[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: RequestAdminCard(
                                  title: 'Usulan ke-${request.requestNumber}',
                                  date: 'Tanggal diajukan: ${DateFormat('dd MMM yyyy').format(request.submissionDate)}',
                                  onViewTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => RequestDetailScreen(requestId: request.id),
                                      ),
                                    ).then((_) => _loadRequests());
                                  },
                                  onApproveTap: () async {
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
                                      await requestProvider.approveRequest(request.id);
                                      if (mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Permintaan berhasil disetujui'),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  onRejectTap: () async {
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
                                      await requestProvider.rejectRequest(request.id);
                                      if (mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Permintaan berhasil ditolak'),
                                            backgroundColor: Colors.orange,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                ),
                              );
                            },
                            childCount: requestProvider.requests.length,
                          ),
                        ),
                ],
              ),
      ),
    );
  }
}