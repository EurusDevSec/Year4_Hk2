import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/song.dart';
import '../../providers/audio_provider.dart';
import '../../providers/playlist_provider.dart';
import '../../widgets/song_card.dart';
import '../../widgets/search_bar.dart' as custom_search;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<PlaylistProvider>().fetchSongs();
    });
  }

  void _playSong(Song song) {
    final audioProvider = context.read<AudioProvider>();
    final playlistProvider = context.read<PlaylistProvider>();

    List<Song> playlist = playlistProvider.searchResults.isEmpty
        ? playlistProvider.allSongs
        : playlistProvider.searchResults;

    audioProvider.loadPlaylist(playlist).then((_) {
      int index = playlist.indexWhere((s) => s.id == song.id);
      if (index != -1) {
        audioProvider.playSong(index);
      }
      Navigator.pushNamed(context, '/player');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Spotify deeply dark background
      body: Consumer<PlaylistProvider>(
        // Rebuild entire screen when provider changes
        builder: (context, provider, _) {
          List<Song> songs = provider.searchResults.isEmpty
              ? provider.allSongs
              : provider.searchResults;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 280.0,
                pinned: true,
                backgroundColor: const Color(
                  0xFF1DB954,
                ), // Spotify Green for collapse
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: const Text(
                    'This Is milet',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromARGB(
                            255,
                            185,
                            84,
                            153,
                          ), // A pinkish gradient as in screenshot
                          Colors.black,
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        // Mimicking playlist banner art
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: CachedNetworkImage(
                            imageUrl: songs.isNotEmpty
                                ? songs.first.imageUrl
                                : 'https://is1-ssl.mzstatic.com/image/thumb/Music211/v4/90/a1/a2/90a1a2e9-09a1-83b5-4dc7-eb5a7000f265/4547366789072.jpg/600x600bb.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
              ),
              // Search Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                  child: custom_search.CustomSearchBar(
                    onChanged: (query) {
                      provider.searchSongs(query);
                    },
                    onClear: () {
                      provider.clearSearchResults();
                    },
                  ),
                ),
              ),
              // Action Buttons row (Play, Shuffle)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    children: [
                      const IconButton(
                        icon: Icon(
                          Icons.download_for_offline_outlined,
                          color: Colors.grey,
                          size: 28,
                        ),
                        onPressed: null,
                      ),
                      const IconButton(
                        icon: Icon(
                          Icons.group_add_outlined,
                          color: Colors.grey,
                          size: 28,
                        ),
                        onPressed: null,
                      ),
                      const Spacer(),
                      const IconButton(
                        icon: Icon(
                          Icons.shuffle,
                          color: Color(0xFF1DB954),
                          size: 28,
                        ),
                        onPressed: null,
                      ),
                      const SizedBox(width: 8),
                      // Big green play button
                      InkWell(
                        onTap: () {
                          if (songs.isNotEmpty) _playSong(songs.first);
                        },
                        child: Container(
                          width: 55,
                          height: 55,
                          decoration: const BoxDecoration(
                            color: Color(0xFF1DB954),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.play_arrow,
                            size: 35,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Songs List
              if (provider.isLoading)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: Color(0xFF1DB954)),
                  ),
                )
              else if (songs.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'Không tìm thấy bài hát',
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(color: Colors.white),
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          // Adding index number like desktop view
                          Container(
                            width: 30,
                            alignment: Alignment.center,
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Expanded(
                            child: SongCard(
                              song: songs[index],
                              onTap: () => _playSong(songs[index]),
                              onFavoriteTap: () {
                                // Implement favorite logic
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }, childCount: songs.length),
                ),
            ],
          );
        },
      ),
    );
  }
}
