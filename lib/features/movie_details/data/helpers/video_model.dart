class VideoModel {
  final String id;
  final String key;
  final String name;
  final String site;
  final String type;

  const VideoModel({
    required this.id,
    required this.key,
    required this.name,
    required this.site,
    required this.type,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'] ?? '',
      key: json['key'] ?? '',
      name: json['name'] ?? '',
      site: json['site'] ?? '',
      type: json['type'] ?? '',
    );
  }

  bool get isYoutube => site == 'YouTube';

  // YouTube's public thumbnail CDN — no TMDB image path involved, so this
  // works even though we don't have (and don't need) an embedded player.
  String get thumbnailUrl => 'https://img.youtube.com/vi/$key/hqdefault.jpg';

  String get youtubeUrl => 'https://www.youtube.com/watch?v=$key';

  Map<String, dynamic> toJson() {
    return {'id': id, 'key': key, 'name': name, 'site': site, 'type': type};
  }
}