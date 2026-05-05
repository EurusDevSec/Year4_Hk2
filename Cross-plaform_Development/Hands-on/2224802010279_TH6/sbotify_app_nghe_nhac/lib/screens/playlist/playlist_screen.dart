import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/playlist_provider.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({Key? key}) : super(key: key);

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _createPlaylist() {
    final playlistProvider = context.read<PlaylistProvider>();
    // Note: You need to get userId from AuthProvider
    playlistProvider.createPlaylist(
      _nameController.text,
      _descriptionController.text,
      'user_id', // Replace with actual user ID
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Danh sách phát')),
      body: Consumer<PlaylistProvider>(
        builder: (context, provider, _) {
          return ListView.builder(
            itemCount: provider.userPlaylists.length,
            itemBuilder: (context, index) {
              final playlist = provider.userPlaylists[index];
              return ListTile(
                title: Text(playlist.name),
                subtitle: Text('${playlist.songCount} bài hát'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navigate to playlist details
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Tạo danh sách phát mới'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      hintText: 'Tên danh sách phát',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(hintText: 'Mô tả'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Hủy'),
                ),
                ElevatedButton(
                  onPressed: _createPlaylist,
                  child: const Text('Tạo'),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
