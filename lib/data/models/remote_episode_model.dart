import '../../domain/entities/entities.dart';

class RemoteEpisodeModel {
  final String name;
  final String airDate;
  final String episode;

  RemoteEpisodeModel({
    required this.name, 
    required this.airDate, 
    required this.episode
  });

  factory RemoteEpisodeModel.fromMap(Map map) => RemoteEpisodeModel(
    name: map["name"],
    airDate: map["air_date"],
    episode: map["episode"]
  );

  EpisodeEntity toEntity() => EpisodeEntity(
    episode: this.episode, 
    name: this.name, 
    airDate: this.airDate
  );
}