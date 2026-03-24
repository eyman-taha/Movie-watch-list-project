import '../../domain/entities/credits.dart';

class CastMemberModel extends CastMember {
  const CastMemberModel({
    required super.id,
    required super.name,
    required super.character,
    super.profilePath,
    required super.order,
  });

  factory CastMemberModel.fromJson(Map<String, dynamic> json) {
    return CastMemberModel(
      id: json['id'] as int,
      name: json['name'] as String,
      character: json['character'] as String? ?? '',
      profilePath: json['profile_path'] as String?,
      order: json['order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'character': character,
      'profile_path': profilePath,
      'order': order,
    };
  }
}

class CrewMemberModel extends CrewMember {
  const CrewMemberModel({
    required super.id,
    required super.name,
    required super.job,
    super.profilePath,
    required super.department,
  });

  factory CrewMemberModel.fromJson(Map<String, dynamic> json) {
    return CrewMemberModel(
      id: json['id'] as int,
      name: json['name'] as String,
      job: json['job'] as String? ?? '',
      profilePath: json['profile_path'] as String?,
      department: json['department'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'job': job,
      'profile_path': profilePath,
      'department': department,
    };
  }
}

class CreditsModel extends Credits {
  const CreditsModel({
    required List<CastMemberModel> super.cast,
    required List<CrewMemberModel> super.crew,
  });

  factory CreditsModel.fromJson(Map<String, dynamic> json) {
    return CreditsModel(
      cast: (json['cast'] as List<dynamic>)
          .map((e) => CastMemberModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      crew: (json['crew'] as List<dynamic>)
          .map((e) => CrewMemberModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cast': cast.map((e) => (e as CastMemberModel).toJson()).toList(),
      'crew': crew.map((e) => (e as CrewMemberModel).toJson()).toList(),
    };
  }
}
