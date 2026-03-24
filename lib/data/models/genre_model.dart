import 'package:hive/hive.dart';
import '../../domain/entities/genre.dart';

part 'genre_model.g.dart';

@HiveType(typeId: 1)
class GenreModel extends Genre {
  @override
  @HiveField(0)
  final int id;
  
  @override
  @HiveField(1)
  final String name;

  const GenreModel({
    required this.id,
    required this.name,
  }) : super(id: id, name: name);

  factory GenreModel.fromJson(Map<String, dynamic> json) {
    return GenreModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory GenreModel.fromEntity(Genre genre) {
    return GenreModel(
      id: genre.id,
      name: genre.name,
    );
  }
}
