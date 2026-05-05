import 'dart:convert';
import 'dart:io';

void main() async {
  final url = Uri.parse('https://itunes.apple.com/search?term=milet&entity=song&limit=8');
  final request = await HttpClient().getUrl(url);
  final response = await request.close();
  final stringData = await response.transform(utf8.decoder).join();
  final json = jsonDecode(stringData);
  
  final file = File('milet_output.txt');
  final sink = file.openWrite();

  for (var result in json['results']) {
    sink.writeln('Title: \${result['trackName']}');
    sink.writeln('Image: \${result['artworkUrl100'].replaceAll('100x100bb', '600x600bb')}');
    sink.writeln('Audio: \${result['previewUrl']}');
    sink.writeln('---');
  }
  
  await sink.close();
}
