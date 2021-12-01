import 'package:rickandmorty/domain/entities/entities.dart';

abstract class LoadEpisodesUseCase {
  Future<List<EpisodeEntity>> load();
}