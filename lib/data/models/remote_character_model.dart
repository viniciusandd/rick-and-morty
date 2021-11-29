import '../../domain/entities/entities.dart';

class RemoteCharacterModel {
  final int id;
  final String name;
  final String status;
  final String gender;

  RemoteCharacterModel({
    required this.id, 
    required this.name, 
    required this.status, 
    required this.gender
  });

  factory RemoteCharacterModel.fromMap(Map map) => 
    RemoteCharacterModel(
      id: map["id"],
      name: map["name"],
      status: map["status"],
      gender: map["gender"],
    );
  
  CharacterEntity toEntity() =>
    CharacterEntity(
      id: this.id, 
      name: this.name, 
      status: this.status, 
      gender: this.gender
    );
}