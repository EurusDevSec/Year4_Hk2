import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../viewmodels/news_list_viewmodel.dart';
import 'detail_screen.dart';

/// Screen showing the latest 10 news articles
class LatestScreen extends StatefulWidget {
  const LatestScreen({super.key});

  @override
  State<LatestScreen> createState() => _LatestScreenState();
}

class _LatestScreenState extends State<LatestScreen> {
  bool _isLoading = false;
  List<dynamic> _latestNews = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadLatestNews();
  }

  Future<void> _loadLatestNews() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final viewModel = context.read<NewsListViewModel>();
      final news = await _loadNewsFromRepository();
      setState(() {
        _latestNews = news;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<List<dynamic>> _loadNewsFromRepository() async {
    final viewModel = context.read<NewsListViewModel>();
    // Get all news from repository
    final categories = viewModel.categories;
    final allNews = <dynamic>[];

    for (final category in categories.take(2)) {
      try {
        final news = await Future.delayed(const Duration(milliseconds: 100));
        // Using a simple approach: fetch from first category
        await viewModel.changeCategory(category);
        allNews.addAll(viewModel.news);
        if (allNews.length >= 10) break;
      } catch (e) {
        continue;
      }
    }

    allNews.sort((a, b) => b.pubDate.compareTo(a.pubDate));
    return allNews.take(10).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tin mới nhất'), elevation: 0),
      body: Consumer<NewsListViewModel>(
        builder: (context, viewModel, _) {
          // Combine news from multiple categories
          final allNews = <dynamic>{};
          for (final category in viewModel.categories.take(2)) {
            // Store news from each category
          }

          return Builder(
            builder: (context) {
              if (_isLoading && _latestNews.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (_error != null && _latestNews.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text('Lỗi: $_error'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadLatestNews,
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                );
              }

              // Get latest 10 from current news
              final latestList = viewModel.news.take(10).toList();

              if (latestList.isEmpty) {
                return const Center(child: Text('Không có tin tức'));
              }

              return RefreshIndicator(
                onRefresh: () async {
                  await viewModel.refreshNews();
                  await _loadLatestNews();
                },
                child: ListView.builder(
                  itemCount: latestList.length,
                  itemBuilder: (context, index) {
                    final news = latestList[index];
                    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailScreen(news: news),
                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Index badge
                              Container(
                                width: 40,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Image
                              if (news.imageUrl != null)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    news.imageUrl!,
                                    width: 80,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 80,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: const Icon(Icons.image),
                                      );
                                    },
                                  ),
                                )
                              else
                                Container(
                                  width: 80,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.image),
                                ),
                              const SizedBox(width: 12),
                              // Content
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      news.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      dateFormat.format(news.pubDate),
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
