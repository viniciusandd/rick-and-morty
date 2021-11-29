import 'package:equatable/equatable.dart';

class CharacterEntity extends Equatable {
  final int id;
  final String name;
  final String status;
  final String gender;

  List get props => [
    id,
    name,
    status,
    gender
  ];

  CharacterEntity({
    required this.id,
    required this.name,
    required this.status,
    required this.gender
  });
}