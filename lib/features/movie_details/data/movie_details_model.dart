import 'package:task/features/genres/data/genre_model.dart';
import 'package:task/features/movie_details/data/helpers/cast_model.dart';
import 'package:task/features/movies/data/movie_model.dart';
import 'package:task/features/movie_details/data/helpers/production_company_model.dart';
import 'package:task/features/movie_details/data/helpers/production_country_model.dart';
import 'package:task/features/movie_details/data/helpers/spoken_language_model.dart';
import 'package:task/features/movie_details/data/helpers/video_model.dart';

class MovieDetailsModel extends MovieModel {
  final String? tagline;
  final String? status;
  final int? runtime;
  final List<GenreModel>? genres;
  final List<ProductionCompanyModel>? productionCompanies;
  final List<ProductionCountryModel>? productionCountries;
  final List<SpokenLanguageModel>? spokenLanguages;
  final String? homepage;
  final String? imdbId;
  final int? budget;
  final int? revenue;
  final List<CastModel>? cast;
  final List<VideoModel>? videos;

  MovieDetailsModel({
    required super.id,
    required super.title,
    super.overview,
    super.posterPath,
    super.backdropPath,
    super.releaseDate,
    super.voteAverage,
    super.voteCount,
    super.genreIds,
    super.adult,
    super.originalLanguage,
    super.originalTitle,
    super.popularity,
    super.video,
    this.tagline,
    this.status,
    this.runtime,
    this.genres,
    this.productionCompanies,
    this.productionCountries,
    this.spokenLanguages,
    this.homepage,
    this.imdbId,
    this.budget,
    this.revenue,
    this.cast,
    this.videos,
  });

  factory MovieDetailsModel.fromJson(Map<String, dynamic> json) {
    // When fetched with append_to_response=credits,videos these arrive as
    // nested objects rather than top-level fields.
    final creditsJson = json['credits'] as Map<String, dynamic>?;
    final videosJson = json['videos'] as Map<String, dynamic>?;

    return MovieDetailsModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? json['original_title'] ?? 'Unknown Title',
      overview: json['overview'],
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      releaseDate: json['release_date'],
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      voteCount: json['vote_count'],
      genreIds: json['genre_ids'] != null
          ? List<int>.from(json['genre_ids'])
          : null,
      adult: json['adult'] ?? false,
      originalLanguage: json['original_language'],
      originalTitle: json['original_title'],
      popularity: (json['popularity'] as num?)?.toDouble(),
      video: json['video'] ?? false,
      tagline: json['tagline'],
      status: json['status'],
      runtime: json['runtime'],
      genres: json['genres'] != null
          ? List<GenreModel>.from(
              (json['genres'] as List).map((e) => GenreModel.fromJson(e)))
          : null,
      productionCompanies: json['production_companies'] != null
          ? List<ProductionCompanyModel>.from(
              (json['production_companies'] as List)
                  .map((e) => ProductionCompanyModel.fromJson(e)))
          : null,
      productionCountries: json['production_countries'] != null
          ? List<ProductionCountryModel>.from(
              (json['production_countries'] as List)
                  .map((e) => ProductionCountryModel.fromJson(e)))
          : null,
      spokenLanguages: json['spoken_languages'] != null
          ? List<SpokenLanguageModel>.from(
              (json['spoken_languages'] as List)
                  .map((e) => SpokenLanguageModel.fromJson(e)))
          : null,
      homepage: json['homepage'],
      imdbId: json['imdb_id'],
      budget: json['budget'],
      revenue: json['revenue'],
      cast: creditsJson?['cast'] != null
          ? List<CastModel>.from(
              (creditsJson!['cast'] as List).map((e) => CastModel.fromJson(e)))
          : null,
      videos: videosJson?['results'] != null
          ? List<VideoModel>.from((videosJson!['results'] as List)
              .map((e) => VideoModel.fromJson(e)))
          : null,
    );
  }

  // "2h 14m" / "45m" / "2h" — empty string when runtime isn't known.
  String get formattedRuntime {
    if (runtime == null || runtime == 0) return '';
    final hours = runtime! ~/ 60;
    final minutes = runtime! % 60;
    if (hours == 0) return '${minutes}m';
    if (minutes == 0) return '${hours}h';
    return '${hours}h ${minutes}m';
  }

  // Prefers an official YouTube trailer; falls back to the first available
  // YouTube video, then to whatever the first video entry is.
  VideoModel? get trailer {
    if (videos == null || videos!.isEmpty) return null;
    final youtubeTrailer = videos!.where((v) => v.isYoutube && v.type == 'Trailer');
    if (youtubeTrailer.isNotEmpty) return youtubeTrailer.first;
    final anyYoutube = videos!.where((v) => v.isYoutube);
    if (anyYoutube.isNotEmpty) return anyYoutube.first;
    return videos!.first;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'tagline': tagline,
      'status': status,
      'runtime': runtime,
      'genres': genres?.map((e) => e.toJson()).toList(),
      'production_companies':
          productionCompanies?.map((e) => e.toJson()).toList(),
      'production_countries':
          productionCountries?.map((e) => e.toJson()).toList(),
      'spoken_languages': spokenLanguages?.map((e) => e.toJson()).toList(),
      'homepage': homepage,
      'imdb_id': imdbId,
      'budget': budget,
      'revenue': revenue,
    };
  }
}