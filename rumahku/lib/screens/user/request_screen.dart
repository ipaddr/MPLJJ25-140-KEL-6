import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rumahku/providers/request_provider.dart';
import 'package:rumahku/screens/user/request_form_screen.dart';
import 'package:rumahku/utils/app_theme.dart';
import 'package:rumahku/widgets/loading_indicator.dart';
import 'package:rumahku/widgets/request_card.dart';

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
    await requestProvider.fetchUserRequests();
  }

  @override
  Widget build(BuildContext context) {
    final requestProvider = Provider.of<RequestProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Usulan'),
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
                            'Menu Usulan',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Di bawah ini adalah data yang telah anda usulkan',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                  
                  // List of requests
                  requestProvider.requests.isEmpty
                      ? SliverFillRemaining(
                          child: Center(
                            child: Text(
                              'Belum ada usulan',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final request = requestProvider.requests[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: RequestCard(
                                  title: 'Usulan ke-${request.requestNumber}',
                                  date: 'Tanggal diajukan: ${DateFormat('dd MMM yyyy').format(request.submissionDate)}',
                                  status: request.status,
                                  onTap: () {
                                    // View request details
                                  },
                                ),
                              );
                            },
                            childCount: requestProvider.requests.length,
                          ),
                        ),
                  
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 100),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const RequestFormScreen(),
            ),
          ).then((_) => _loadRequests());
        },
        backgroundColor: AppTheme.primaryColor,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Usulan'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}