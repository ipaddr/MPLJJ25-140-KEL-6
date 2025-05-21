import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rumahku/providers/request_provider.dart';
import 'package:rumahku/screens/admin/request_detail_screen.dart';
import 'package:rumahku/utils/app_theme.dart';
import 'package:rumahku/widgets/distribution_card.dart';
import 'package:rumahku/widgets/loading_indicator.dart';

class DistributionScreen extends StatefulWidget {
  const DistributionScreen({super.key});

  @override
  State<DistributionScreen> createState() => _DistributionScreenState();
}

class _DistributionScreenState extends State<DistributionScreen> {
  @override
  void initState() {
    super.initState();
    _loadDistributions();
  }

  Future<void> _loadDistributions() async {
    final requestProvider = Provider.of<RequestProvider>(context, listen: false);
    await requestProvider.fetchAllRequests();
  }

  @override
  Widget build(BuildContext context) {
    final requestProvider = Provider.of<RequestProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Penyaluran Bantuan'),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _loadDistributions,
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
                            'Penyaluran Bantuan kepada Masyarakat',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Berikut data berupa penyaluran bantuan:',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                  
                  // List of distributions
                  requestProvider.approvedRequests.isEmpty
                      ? const SliverFillRemaining(
                          child: Center(
                            child: Text('Tidak ada penyaluran bantuan'),
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final request = requestProvider.approvedRequests[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: DistributionCard(
                                  title: 'Penyaluran unit-${request.requestNumber}',
                                  date: 'Tanggal disalurkan: ${request.distributionDate != null ? DateFormat('dd MMM yyyy').format(DateTime.parse(request.distributionDate!)) : 'Tidak tersedia'}',
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => RequestDetailScreen(requestId: request.id),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                            childCount: requestProvider.approvedRequests.length,
                          ),
                        ),
                ],
              ),
      ),
    );
  }
}