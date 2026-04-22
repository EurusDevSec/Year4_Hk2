import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../viewmodels/news_list_viewmodel.dart';
import 'detail_screen.dart';

/// Screen for browsing news by category
class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chủ đề'), elevation: 0),
      body: Consumer<NewsListViewModel>(
        builder: (context, viewModel, _) {
          return Column(
            children: [
              // Category tabs
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: viewModel.categories.length,
                  itemBuilder: (context, index) {
                    final category = viewModel.categories[index];
                    final isSelected = category == viewModel.currentCategory;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: FilterChip(
                        selected: isSelected,
                        onSelected: (_) {
                          viewModel.changeCategory(category);
                        },
                        label: Text(category),
                      ),
                    );
                  },
                ),
              ),
              // News list
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (viewModel.isLoading && viewModel.news.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (viewModel.error != null && viewModel.news.isEmpty) {
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
                            Text('Lỗi: ${viewModel.error}'),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () =>
                                  viewModel.loadNews(forceRefresh: true),
                              child: const Text('Thử lại'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (viewModel.news.isEmpty) {
                      return const Center(child: Text('Không có tin tức'));
                    }

                    return RefreshIndicator(
                      onRefresh: () => viewModel.refreshNews(),
                      child: ListView.builder(
                        itemCount: viewModel.news.length,
                        itemBuilder: (context, index) {
                          final news = viewModel.news[index];
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
                                    // Image
                                    if (news.imageUrl != null)
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          news.imageUrl!,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Container(
                                                  width: 100,
                                                  height: 100,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[300],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  child: const Icon(
                                                    Icons.image,
                                                  ),
                                                );
                                              },
                                        ),
                                      )
                                    else
                                      Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: const Icon(Icons.image),
                                      ),
                                    const SizedBox(width: 12),
                                    // Content
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            news.title,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            news.description,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          const SizedBox(height: 8),
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
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
