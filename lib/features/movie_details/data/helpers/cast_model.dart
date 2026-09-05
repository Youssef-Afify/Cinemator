class CastModel {
  final int id;
  final String name;
  final String? character;
  final String? profilePath;

  const CastModel({
    required this.id,
    required this.name,
    this.character,
    this.profilePath,
  });

  factory CastModel.fromJson(Map<String, dynamic> json) {
    return CastModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      character: json['character'],
      profilePath: json['profile_path'],
    );
  }

  String get profileUrl {
    if (profilePath == null || profilePath!.isEmpty) return '';
    if (profilePath!.startsWith('http')) return profilePath!;
    return 'https://image.tmdb.org/t/p/w185$profilePath';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'character': character,
      'profile_path': profilePath,
    };
  }
}