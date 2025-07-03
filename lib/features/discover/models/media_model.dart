import 'package:uuid/uuid.dart';

const uuid=Uuid();
class MediaModel {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final int voteCount;
  final List<int> genreIds;
  final String releaseDate;
  final String originalLanguage;
  final List<String> originCountry;
  final double popularity;
  final String mediaType;
  final String? uid;

  MediaModel({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.voteCount,
    required this.genreIds,
    required this.releaseDate,
    required this.originalLanguage,
    required this.originCountry,
    required this.popularity,
    required this.mediaType,
  }):uid=uuid.v4();

  factory MediaModel.fromJson(Map<String, dynamic> json,String mediaType) {
    return MediaModel(
      id: json['id'],
      title: json['title'] ?? json['name'] ?? json['original_title'] ?? json['original_name'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      genreIds: List<int>.from(json['genre_ids'] ?? []),
      releaseDate: json['release_date'] ?? json['first_air_date'] ?? '',
      originalLanguage: json['original_language'] ?? '',
      originCountry: List<String>.from(json['origin_country'] ?? []),
      popularity: (json['popularity'] ?? 0).toDouble(),
      mediaType: json['media_type'] ?? mediaType,
    );
  }
  Map<String,dynamic> toJson()=> {
    'id': id,
    'title': title,
    'overview': overview,
    'poster_path': posterPath,
    'backdrop_path': backdropPath,
    'vote_average': voteAverage,
    'vote_count': voteCount,
    'genre_ids': genreIds,
    'release_date': releaseDate,
    'original_language': originalLanguage,
    'origin_country': originCountry,
    'popularity': popularity,
    'media_type': mediaType,
  };
}