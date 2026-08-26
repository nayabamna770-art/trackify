// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HabitModelAdapter extends TypeAdapter<HabitModel> {
  @override
  final int typeId = 0;

  @override
  HabitModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HabitModel(
      id: fields[0] as String,
      title: fields[1] as String,
      category: fields[2] as String,
      iconCodePoint: fields[3] as int?,
      iconFontFamily: fields[4] as String?,
      iconName: fields[5] as String,
      streakCount: fields[6] as int,
      isCompletedToday: fields[7] as bool,
      weeklyProgress: (fields[8] as List?)?.cast<bool>(),
      completionDates: (fields[9] as List?)?.cast<String>(),
      defaultTimerMinutes: fields[10] as int,
      linkedSubscriptionId: fields[11] as String?,
      linkedSubscriptionName: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HabitModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.iconCodePoint)
      ..writeByte(4)
      ..write(obj.iconFontFamily)
      ..writeByte(5)
      ..write(obj.iconName)
      ..writeByte(6)
      ..write(obj.streakCount)
      ..writeByte(7)
      ..write(obj.isCompletedToday)
      ..writeByte(8)
      ..write(obj.weeklyProgress)
      ..writeByte(9)
      ..write(obj.completionDates)
      ..writeByte(10)
      ..write(obj.defaultTimerMinutes)
      ..writeByte(11)
      ..write(obj.linkedSubscriptionId)
      ..writeByte(12)
      ..write(obj.linkedSubscriptionName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
