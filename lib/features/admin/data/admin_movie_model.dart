import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task/features/genres/data/genre_model.dart';
import 'package:task/features/movie_details/data/helpers/cast_model.dart';
import 'package:task/features/movie_details/data/helpers/video_model.dart';
import 'package:task/features/movie_details/data/movie_details_model.dart';

class AdminMovieModel extends MovieDetailsModel {
  /// Firestore document ID (auto-generated string).
  final String docId;

  AdminMovieModel({
    required this.docId,
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
    super.tagline,
    super.status,
    super.runtime,
    super.genres,
    super.homepage,
    super.imdbId,
    super.budget,
    super.revenue,
    super.cast,
    super.videos,
    // productionCompanies, productionCountries, spokenLanguages are not
    // captured in the admin form — they default to null.
  });

  factory AdminMovieModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return AdminMovieModel(
      docId: doc.id,
      id: (data['id'] as int?) ?? 0,
      title: (data['title'] as String?) ?? 'Untitled',
      overview: data['overview'] as String?,
      posterPath: data['poster_path'] as String?,
      backdropPath: data['backdrop_path'] as String?,
      releaseDate: data['release_date'] as String?,
      voteAverage: (data['vote_average'] as num?)?.toDouble(),
      voteCount: data['vote_count'] as int?,
      genreIds: data['genre_ids'] != null
          ? List<int>.from(data['genre_ids'] as List)
          : null,
      adult: (data['adult'] as bool?) ?? false,
      originalLanguage: data['original_language'] as String?,
      originalTitle: data['original_title'] as String?,
      popularity: (data['popularity'] as num?)?.toDouble(),
      video: (data['video'] as bool?) ?? false,
      tagline: data['tagline'] as String?,
      status: data['status'] as String?,
      runtime: data['runtime'] as int?,
      homepage: data['homepage'] as String?,
      imdbId: data['imdb_id'] as String?,
      budget: data['budget'] as int?,
      revenue: data['revenue'] as int?,
      genres: data['genres'] != null
          ? List<GenreModel>.from(
              (data['genres'] as List).map((e) => GenreModel.fromJson(e)),
            )
          : null,
      cast: data['cast'] != null
          ? List<CastModel>.from(
              (data['cast'] as List).map((e) => CastModel.fromJson(e)),
            )
          : null,
      videos: data['videos'] != null
          ? List<VideoModel>.from(
              (data['videos'] as List).map((e) => VideoModel.fromJson(e)),
            )
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'release_date': releaseDate,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'genre_ids': genreIds,
      'adult': adult,
      'original_language': originalLanguage,
      'original_title': originalTitle,
      'popularity': popularity,
      'video': video,
      'tagline': tagline,
      'status': status,
      'runtime': runtime,
      'homepage': homepage,
      'imdb_id': imdbId,
      'budget': budget,
      'revenue': revenue,
      'genres': genres?.map((g) => g.toJson()).toList(),
      'cast': cast?.map((c) => c.toJson()).toList(),
      'videos': videos?.map((v) => v.toJson()).toList(),
    };
  }

  AdminMovieModel copyWithAdmin({
    String? title,
    String? overview,
    String? posterPath,
    String? backdropPath,
    String? releaseDate,
    double? voteAverage,
    int? voteCount,
    List<int>? genreIds,
    bool? adult,
    String? originalLanguage,
    String? originalTitle,
    double? popularity,
    bool? video,
    String? tagline,
    String? status,
    int? runtime,
    String? homepage,
    String? imdbId,
    int? budget,
    int? revenue,
    List<GenreModel>? genres,
    List<CastModel>? cast,
    List<VideoModel>? videos,
  }) {
    return AdminMovieModel(
      docId: docId,
      id: id,
      title: title ?? this.title,
      overview: overview ?? this.overview,
      posterPath: posterPath ?? this.posterPath,
      backdropPath: backdropPath ?? this.backdropPath,
      releaseDate: releaseDate ?? this.releaseDate,
      voteAverage: voteAverage ?? this.voteAverage,
      voteCount: voteCount ?? this.voteCount,
      genreIds: genreIds ?? this.genreIds,
      adult: adult ?? this.adult,
      originalLanguage: originalLanguage ?? this.originalLanguage,
      originalTitle: originalTitle ?? this.originalTitle,
      popularity: popularity ?? this.popularity,
      video: video ?? this.video,
      tagline: tagline ?? this.tagline,
      status: status ?? this.status,
      runtime: runtime ?? this.runtime,
      homepage: homepage ?? this.homepage,
      imdbId: imdbId ?? this.imdbId,
      budget: budget ?? this.budget,
      revenue: revenue ?? this.revenue,
      genres: genres ?? this.genres,
      cast: cast ?? this.cast,
      videos: videos ?? this.videos,
    );
  }
}