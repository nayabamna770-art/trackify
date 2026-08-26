// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models/subscription_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubscriptionModelAdapter extends TypeAdapter<SubscriptionModel> {
  @override
  final int typeId = 1;

  @override
  SubscriptionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubscriptionModel(
      id: fields[0] as String,
      name: fields[1] as String,
      cost: fields[2] as double,
      billingCycle: fields[3] as BillingCycle,
      nextBillingDate: fields[4] as DateTime,
      currency: fields[5] as CurrencyType,
      isFreeTrial: fields[6] as bool,
      linkedHabitId: fields[7] as String?,
      linkedHabitName: fields[8] as String?,
      isUnderutilized: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SubscriptionModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.cost)
      ..writeByte(3)
      ..write(obj.billingCycle)
      ..writeByte(4)
      ..write(obj.nextBillingDate)
      ..writeByte(5)
      ..write(obj.currency)
      ..writeByte(6)
      ..write(obj.isFreeTrial)
      ..writeByte(7)
      ..write(obj.linkedHabitId)
      ..writeByte(8)
      ..write(obj.linkedHabitName)
      ..writeByte(9)
      ..write(obj.isUnderutilized);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubscriptionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BillingCycleAdapter extends TypeAdapter<BillingCycle> {
  @override
  final int typeId = 2;

  @override
  BillingCycle read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BillingCycle.monthly;
      case 1:
        return BillingCycle.yearly;
      default:
        return BillingCycle.monthly;
    }
  }

  @override
  void write(BinaryWriter writer, BillingCycle obj) {
    switch (obj) {
      case BillingCycle.monthly:
        writer.writeByte(0);
        break;
      case BillingCycle.yearly:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BillingCycleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}