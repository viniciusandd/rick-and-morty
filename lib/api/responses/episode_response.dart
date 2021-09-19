class EpisodeResponse {
  final int id;
  final String name;
  final String airDate;
  final String episode;

  EpisodeResponse({
      required this.id,
      required this.name,
      required this.airDate,
      required this.episode,
    });

  EpisodeResponse.fromJson(Map<String, dynamic> json) 
    : id = json['id'],
      name = json['name'],
      airDate = json['air_date'],
      episode = json['episode'];
}
