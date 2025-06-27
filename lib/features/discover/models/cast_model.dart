class CastModel {
  final String? name;
  final String? character;
  final String? profilePath;
  const CastModel({
    required this.name,
    required this.character,
    required this.profilePath,
  });
  factory CastModel.fromJson(Map<String, dynamic> json) => CastModel(
    name: json['name']??'OMT did not find the name',
    character: json['character']??'OMT did not find the character',
    profilePath: json['profile_path']??'OMT did not find the image',
  );
}
