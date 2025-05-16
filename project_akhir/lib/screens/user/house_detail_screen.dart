import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:project_akhir/models/house_model.dart';
import 'package:project_akhir/services/house_service.dart';

class HouseDetailScreen extends StatefulWidget {
  final String houseId;
  
  const HouseDetailScreen({
    super.key,
    required this.houseId,
  });

  @override
  State<HouseDetailScreen> createState() => _HouseDetailScreenState();
}

class _HouseDetailScreenState extends State<HouseDetailScreen> {
  final HouseService _houseService = HouseService();
  HouseModel? _house;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadHouseDetails();
  }

  Future<void> _loadHouseDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      _house = await _houseService.getHouseById(widget.houseId);
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
                        onPressed: _loadHouseDetails,
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                )
              : CustomScrollView(
                  slivers: [
                    // App bar with image
                    SliverAppBar(
                      expandedHeight: 200,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        background: _house!.photoUrls.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: _house!.photoUrls.first,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.error),
                                ),
                              )
                            : Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.home),
                              ),
                      ),
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    
                    // House details
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _house!.type,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // House specifications
                            Row(
                              children: [
                                Expanded(
                                  child: _buildSpecItem(
                                    'Luas Bangunan',
                                    _house!.buildingArea,
                                  ),
                                ),
                                Expanded(
                                  child: _buildSpecItem(
                                    'Luas Tanah',
                                    _house!.landArea,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildSpecItem(
                                    'Tegangan Listrik',
                                    _house!.electricityCapacity,
                                  ),
                                ),
                                Expanded(
                                  child: _buildSpecItem(
                                    'Status Perairan',
                                    _house!.waterStatus,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildSpecItem(
                                    'Status Kelembaban',
                                    _house!.humidityStatus,
                                  ),
                                ),
                                Expanded(
                                  child: _buildSpecItem(
                                    'Banyak Kamar',
                                    '${_house!.numberOfRooms} kamar',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildSpecItem(
                                    'Banyak Kamar Mandi',
                                    '${_house!.numberOfBathrooms} kamar mandi',
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                              ],
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // House floor plan
                            const Text(
                              'Denah Rumah',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: _house!.floorPlanImageUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  height: 200,
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  height: 200,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.error),
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Additional photos
                            if (_house!.photoUrls.length > 1) ...[
                              const Text(
                                'Foto Lainnya',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 100,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _house!.photoUrls.length - 1,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      width: 150,
                                      margin: const EdgeInsets.only(right: 8),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: CachedNetworkImage(
                                          imageUrl: _house!.photoUrls[index + 1],
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => Container(
                                            color: Colors.grey[300],
                                            child: const Center(
                                              child: CircularProgressIndicator(),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) => Container(
                                            color: Colors.grey[300],
                                            child: const Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                            
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildSpecItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}