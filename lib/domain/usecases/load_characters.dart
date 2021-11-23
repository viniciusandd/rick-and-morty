import 'package:rickandmorty/domain/entities/entities.dart';

abstract class LoadCharactersUseCase {
  Future<List<CharacterEntity>> load();
}