// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coffee_picture.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoffeePicture _$CoffeePictureFromJson(Map<String, dynamic> json) =>
    CoffeePicture(
      id: json['id'] as String?,
      file: json['file'] as String,
      isDownloaded: json['isDownloaded'] as bool? ?? false,
    );

Map<String, dynamic> _$CoffeePictureToJson(CoffeePicture instance) =>
    <String, dynamic>{
      'id': instance.id,
      'file': instance.file,
      'isDownloaded': instance.isDownloaded,
    };
