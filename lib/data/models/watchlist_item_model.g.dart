// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watchlist_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WatchlistItemModelAdapter extends TypeAdapter<WatchlistItemModel> {
  @override
  final int typeId = 2;

  @override
  WatchlistItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WatchlistItemModel(
      userId: fields[0] as String?,
      movieId: fields[1] as int,
      movie: fields[2] as MovieModel,
      statusIndex: fields[3] as int,
      userRating: fields[4] as double?,
      isFavorite: fields[5] as bool,
      addedAt: fields[6] as DateTime,
      updatedAt: fields[7] as DateTime,
      watchedAt: fields[8] as DateTime?,
      note: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, WatchlistItemModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.movieId)
      ..writeByte(2)
      ..write(obj.movie)
      ..writeByte(3)
      ..write(obj.statusIndex)
      ..writeByte(4)
      ..write(obj.userRating)
      ..writeByte(5)
      ..write(obj.isFavorite)
      ..writeByte(6)
      ..write(obj.addedAt)
      ..writeByte(7)
      ..write(obj.updatedAt)
      ..writeByte(8)
      ..write(obj.watchedAt)
      ..writeByte(9)
      ..write(obj.note);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WatchlistItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
