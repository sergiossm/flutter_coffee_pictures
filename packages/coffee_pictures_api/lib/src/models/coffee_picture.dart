import 'package:coffee_pictures_api/coffee_pictures_api.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'coffee_picture.g.dart';

/// {@template coffeePicture}
/// A single coffee picture item.
///
/// Contains a [file] URL
///
/// [CoffeePicture]s are immutable and can be copied using [copyWith], in
/// addition to being serialized and deserialized using [toJson] and [fromJson]
/// respectively.
/// {@endtemplate}
@immutable
@JsonSerializable()
class CoffeePicture extends Equatable {
  /// {@macro coffeePicture}
  CoffeePicture({
    required this.file,
  }) : assert(file.isNotEmpty, 'file can not be empty');

  /// The url of the coffee picture.
  ///
  /// Cannot be empty.
  final String file;

  /// Returns a copy of this coffee picture with the given values updated.
  ///
  /// {@macro coffeePicture}
  CoffeePicture copyWith({
    String? file,
  }) {
    return CoffeePicture(
      file: file ?? this.file,
    );
  }

  /// Deserializes the given [JsonMap] into a [CoffeePicture].
  static CoffeePicture fromJson(JsonMap json) => _$CoffeePictureFromJson(json);

  /// Converts this [CoffeePicture] into a [JsonMap].
  JsonMap toJson() => _$CoffeePictureToJson(this);

  @override
  List<Object> get props => [file];
}
