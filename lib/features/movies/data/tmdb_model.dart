import 'package:task/features/movies/data/movie_model.dart';

class TmdbModel {
  final int page;
  final List<MovieModel> results;
  final int totalPages;
  final int totalResults;

  TmdbModel({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory TmdbModel.fromJson(Map<String, dynamic> json) {
    return TmdbModel(
      page: json['page'] ?? 1,
      results: json['results'] != null
          ? List<MovieModel>.from(
              (json['results'] as List).map((e) => MovieModel.fromJson(e)))
          : [],
      totalPages: json['total_pages'] ?? 0,
      totalResults: json['total_results'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'results': results.map((e) => e.toJson()).toList(),
      'total_pages': totalPages,
      'total_results': totalResults,
    };
  }
}
