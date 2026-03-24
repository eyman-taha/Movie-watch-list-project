import 'package:equatable/equatable.dart';

class CastMember extends Equatable {
  final int id;
  final String name;
  final String character;
  final String? profilePath;
  final int order;

  const CastMember({
    required this.id,
    required this.name,
    required this.character,
    this.profilePath,
    required this.order,
  });

  @override
  List<Object?> get props => [id, name, character, profilePath, order];
}

class CrewMember extends Equatable {
  final int id;
  final String name;
  final String job;
  final String? profilePath;
  final String department;

  const CrewMember({
    required this.id,
    required this.name,
    required this.job,
    this.profilePath,
    required this.department,
  });

  @override
  List<Object?> get props => [id, name, job, profilePath, department];
}

class Credits extends Equatable {
  final List<CastMember> cast;
  final List<CrewMember> crew;

  const Credits({
    required this.cast,
    required this.crew,
  });

  List<CastMember> get topCast => cast.take(10).toList();
  
  CrewMember? get director => 
      crew.where((c) => c.job == 'Director').firstOrNull;

  @override
  List<Object?> get props => [cast, crew];
}
