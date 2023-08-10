import 'package:subtitle/subtitle.dart';

class NetworkSubtitleProvider extends SubtitleProvider {
  /// The url of subtitle file on the internet.
  final Uri url;
  final SubtitleType? type;

   NetworkSubtitleProvider(
      this.url, {
        this.type,
      });

  // Replace this method with your code to return a `SubtitleObject`.
  @override
  Future<SubtitleObject> getSubtitle() async {
    // Preparing subtitle file data.
    final _repository = SubtitleRepository.inctance;
    final data = await _repository.fetchFromNetwork(url);

    // Find the current format type of subtitle.
    final ext = url.path.substring(url.path.lastIndexOf("."));
    final type = this.type ?? getSubtitleType(ext);

    return SubtitleObject(data: data, type: type);
  }
}