import 'package:equatable/equatable.dart';

class EpisodeEntity extends Equatable {
  final String episode;
  final String name;
  final String airDate;

  List get props => [
    episode,
    name,
    airDate
  ];

  EpisodeEntity({
    required this.episode, 
    required this.name, 
    required this.airDate
  });
}