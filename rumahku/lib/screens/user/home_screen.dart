import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rumahku/models/house_model.dart';
import 'package:rumahku/models/news_model.dart';
import 'package:rumahku/providers/house_provider.dart';
import 'package:rumahku/providers/news_provider.dart';
import 'package:rumahku/screens/user/house_detail_screen.dart';
import 'package:rumahku/screens/user/news_detail_screen.dart';
import 'package:rumahku/utils/app_theme.dart';
import 'package:rumahku/widgets/house_card.dart';
import 'package:rumahku/widgets/loading_indicator.dart';
import 'package:rumahku/widgets/news_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final houseProvider = Provider.of<HouseProvider>(context, listen: false);
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);
    
    await houseProvider.fetchHouses();
    await newsProvider.fetchNews();
  }

  void _openHouseDetail(BuildContext context, HouseModel house) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => HouseDetailScreen(house: house),
      ),
    );
  }

  void _openNewsDetail(BuildContext context, NewsModel news) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NewsDetailScreen(news: news),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final houseProvider = Provider.of<HouseProvider>(context);
    final newsProvider = Provider.of<NewsProvider>(context);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'rumah.ku',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      'https://images.pexels.com/photos/106399/pexels-photo-106399.jpeg',
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // House References Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Temukan Referensi Rumah Bersanitasi Baik!',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            
            // House Grid
            houseProvider.isLoading
                ? const SliverToBoxAdapter(child: Center(child: LoadingIndicator()))
                : houseProvider.houses.isEmpty
                    ? const SliverToBoxAdapter(
                        child: Center(
                          child: Text('No house references available'),
                        ),
                      )
                    : SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        sliver: SliverGrid(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.8,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final house = houseProvider.houses[index];
                              return HouseCard(
                                house: house,
                                onTap: () => _openHouseDetail(context, house),
                              );
                            },
                            childCount: houseProvider.houses.length,
                          ),
                        ),
                      ),
            
            // News Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    Text(
                      'Berita Perumahan Terbaru',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            
            // News List
            newsProvider.isLoading
                ? const SliverToBoxAdapter(child: Center(child: LoadingIndicator()))
                : newsProvider.news.isEmpty
                    ? const SliverToBoxAdapter(
                        child: Center(
                          child: Text('No news available'),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final news = newsProvider.news[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: NewsCard(
                                news: news,
                                onTap: () => _openNewsDetail(context, news),
                              ),
                            );
                          },
                          childCount: newsProvider.news.length,
                        ),
                      ),
                      
            // Bottom Padding
            const SliverToBoxAdapter(
              child: SizedBox(height: 32),
            ),
          ],
        ),
      ),
    );
  }
}