import 'package:task/features/movies/data/movie_model.dart';

class TmdbResponse {
  final int page;
  final List<MovieModel> results;
  final int totalPages;
  final int totalResults;

  TmdbResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory TmdbResponse.fromJson(Map<String, dynamic> json) {
    return TmdbResponse(
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

class TmdbMovieDetails extends MovieModel {
  final String? tagline;
  final String? status;
  final int? runtime;
  final List<Genre>? genres;
  final List<ProductionCompany>? productionCompanies;
  final List<ProductionCountry>? productionCountries;
  final List<SpokenLanguage>? spokenLanguages;
  final String? homepage;
  final String? imdbId;
  final int? budget;
  final int? revenue;

  TmdbMovieDetails({
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
  });

  factory TmdbMovieDetails.fromJson(Map<String, dynamic> json) {
    return TmdbMovieDetails(
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
          ? List<Genre>.from(
              (json['genres'] as List).map((e) => Genre.fromJson(e)))
          : null,
      productionCompanies: json['production_companies'] != null
          ? List<ProductionCompany>.from(
              (json['production_companies'] as List)
                  .map((e) => ProductionCompany.fromJson(e)))
          : null,
      productionCountries: json['production_countries'] != null
          ? List<ProductionCountry>.from(
              (json['production_countries'] as List)
                  .map((e) => ProductionCountry.fromJson(e)))
          : null,
      spokenLanguages: json['spoken_languages'] != null
          ? List<SpokenLanguage>.from(
              (json['spoken_languages'] as List)
                  .map((e) => SpokenLanguage.fromJson(e)))
          : null,
      homepage: json['homepage'],
      imdbId: json['imdb_id'],
      budget: json['budget'],
      revenue: json['revenue'],
    );
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

class Genre {
  final int id;
  final String name;

  Genre({required this.id, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class ProductionCompany {
  final int id;
  final String name;
  final String? logoPath;
  final String? originCountry;

  ProductionCompany({
    required this.id,
    required this.name,
    this.logoPath,
    this.originCountry,
  });

  factory ProductionCompany.fromJson(Map<String, dynamic> json) {
    return ProductionCompany(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      logoPath: json['logo_path'],
      originCountry: json['origin_country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo_path': logoPath,
      'origin_country': originCountry,
    };
  }
}

class ProductionCountry {
  final String iso31661;
  final String name;

  ProductionCountry({
    required this.iso31661,
    required this.name,
  });

  factory ProductionCountry.fromJson(Map<String, dynamic> json) {
    return ProductionCountry(
      iso31661: json['iso_3166_1'] ?? '',
      name: json['name'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'iso_3166_1': iso31661,
      'name': name,
    };
  }
}

class SpokenLanguage {
  final String iso6391;
  final String name;

  SpokenLanguage({
    required this.iso6391,
    required this.name,
  });

  factory SpokenLanguage.fromJson(Map<String, dynamic> json) {
    return SpokenLanguage(
      iso6391: json['iso_639_1'] ?? '',
      name: json['name'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'iso_639_1': iso6391,
      'name': name,
    };
  }
}