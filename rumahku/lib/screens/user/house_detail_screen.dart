import 'package:flutter/material.dart';
import 'package:rumahku/models/house_model.dart';
import 'package:rumahku/utils/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rumahku/widgets/feature_item.dart';

class HouseDetailScreen extends StatelessWidget {
  final HouseModel house;

  const HouseDetailScreen({
    super.key,
    required this.house,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(house.type),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // House Image
            AspectRatio(
              aspectRatio: 16 / 9,
              child: CachedNetworkImage(
                imageUrl: house.imageUrls.isNotEmpty
                    ? house.imageUrls.first
                    : 'https://images.pexels.com/photos/106399/pexels-photo-106399.jpeg',
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            
            // House Details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    house.type,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // House Specifications Grid
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    childAspectRatio: 2.5,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      FeatureItem(
                        icon: Icons.square_foot,
                        title: 'Luas Bangunan',
                        value: '${house.buildingArea} m²',
                      ),
                      FeatureItem(
                        icon: Icons.crop_square,
                        title: 'Luas Tanah',
                        value: '${house.landArea} m²',
                      ),
                      FeatureItem(
                        icon: Icons.electric_bolt,
                        title: 'Tegangan Listrik',
                        value: house.electricVoltage,
                      ),
                      FeatureItem(
                        icon: Icons.water_drop,
                        title: 'Status Perairan',
                        value: house.waterStatus,
                      ),
                      FeatureItem(
                        icon: Icons.thermostat,
                        title: 'Status Kelembapan',
                        value: house.humidityStatus,
                      ),
                      FeatureItem(
                        icon: Icons.bed,
                        title: 'Banyak Kamar',
                        value: '${house.bedrooms}',
                      ),
                      FeatureItem(
                        icon: Icons.bathroom,
                        title: 'Banyak Kamar Mandi',
                        value: '${house.bathrooms}',
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Floor Plan
                  Text(
                    'Denah Rumah',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: house.floorPlanUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                  
                  if (house.description.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Deskripsi',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(house.description),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}