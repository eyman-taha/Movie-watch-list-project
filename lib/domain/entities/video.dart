import 'package:equatable/equatable.dart';

class Video extends Equatable {
  final String id;
  final String key;
  final String name;
  final String site;
  final String type;
  final bool official;

  const Video({
    required this.id,
    required this.key,
    required this.name,
    required this.site,
    required this.type,
    required this.official,
  });

  bool get isYouTube => site.toLowerCase() == 'youtube';
  bool get isTrailer => type.toLowerCase() == 'trailer';
  bool get isTeaser => type.toLowerCase() == 'teaser';

  String? get thumbnailUrl {
    if (!isYouTube) return null;
    return 'https://img.youtube.com/vi/$key/hqdefault.jpg';
  }

  @override
  List<Object?> get props => [id, key, name, site, type, official];
}
