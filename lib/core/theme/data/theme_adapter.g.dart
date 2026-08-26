import 'package:hive/hive.dart';
import '../../database/hive_types.dart';

class ThemeStateDto {
  final String paletteId;
  final double glassOpacity;

  ThemeStateDto({
    required this.paletteId,
    required this.glassOpacity,
  });
}

class ThemeStateAdapter extends TypeAdapter<ThemeStateDto> {
  @override
  final int typeId = HiveTypes.themeState;

  @override
  ThemeStateDto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ThemeStateDto(
      paletteId: fields[0] as String,
      glassOpacity: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, ThemeStateDto obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.paletteId)
      ..writeByte(1)
      ..write(obj.glassOpacity);
  }
}