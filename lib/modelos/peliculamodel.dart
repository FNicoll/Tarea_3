class PeliculaModel {
  final String backdropPath;
  final int id;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final String posterPath;
  final String releaseDate;
  final String title;
  final double voteAverage;

  PeliculaModel({
    required this.backdropPath,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.voteAverage,
  });

  factory PeliculaModel.fromJson(Map<String, dynamic> json) => PeliculaModel(
        backdropPath: json["backdrop_path"],
        id: json["id"],
        originalLanguage: json["original_language"]!,
        originalTitle: json["original_title"],
        overview: json["overview"],
        posterPath: json["poster_path"],
        releaseDate: json["release_date"],
        title: json["title"],
        voteAverage: json["vote_average"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "backdrop_path": backdropPath,
        "id": id,
        "original_language": originalLanguage,
        "original_title": originalTitle,
        "overview": overview,
        "poster_path": posterPath,
        "release_date": releaseDate,
        "title": title,
        "vote_average": voteAverage,
      };
}
