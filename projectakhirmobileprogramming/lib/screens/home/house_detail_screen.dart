import 'package:flutter/material.dart';
import 'package:projectakhirmobileprogramming/services/house_service.dart'; // Adjusted path for consistency

class HouseDetailScreen extends StatefulWidget {
  final String houseType;

  const HouseDetailScreen({Key? key, required this.houseType}) : super(key: key);

  @override
  _HouseDetailScreenState createState() => _HouseDetailScreenState();
}

class _HouseDetailScreenState extends State<HouseDetailScreen> {
  Map<String, dynamic>? _houseData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHouseDetails();
  }

  Future<void> _fetchHouseDetails() async {
    try {
      final houseService = HouseService();
      final data = await houseService.getHouseByType(widget.houseType);

      setState(() {
        _houseData = data;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching house details: $e');
      setState(() {
        _isLoading = false;
        _houseData = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.houseType),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _houseData == null
              ? const Center(child: Text('Could not load house details.'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Detail Informasi Rumah',
                        style: Theme.of(context).textTheme.headlineSmall, // Updated
                      ),
                      const SizedBox(height: 16.0),
                      _buildInfoRow('Tipe Rumah:', _houseData?['houseType'] ?? 'N/A'),
                      _buildInfoRow('Luas Bangunan:', '${_houseData?['buildingArea'] ?? 'N/A'} m²'),
                      _buildInfoRow('Luas Tanah:', '${_houseData?['landArea'] ?? 'N/A'} m²'),
                      _buildInfoRow('Kapasitas Listrik:', '${_houseData?['electricityCapacity'] ?? 'N/A'} VA'),
                      _buildInfoRow('Status Air:', _houseData?['waterStatus'] ?? 'N/A'),
                      _buildInfoRow('Status Kelembaban:', _houseData?['humidityStatus'] ?? 'N/A'),
                      _buildInfoRow('Jumlah Kamar:', '${_houseData?['numberOfRooms'] ?? 'N/A'}'),
                      _buildInfoRow('Jumlah Kamar Mandi:', '${_houseData?['numberOfBathrooms'] ?? 'N/A'}'),
                      const SizedBox(height: 16.0),
                      Text(
                        'Denah Lantai:',
                        style: Theme.of(context).textTheme.titleMedium, // Updated
                      ),
                      const SizedBox(height: 8.0),
                      _houseData?['floorPlanImageUrl'] != null && (_houseData?['floorPlanImageUrl'] as String).isNotEmpty
                          ? Center(
                              child: Image.network(
                                _houseData!['floorPlanImageUrl'],
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                          : null,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) => const Text('Tidak dapat memuat gambar denah lantai.'),
                              ),
                            )
                          : const Text('Denah lantai tidak tersedia.'),
                    ],
                  ),
                ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}