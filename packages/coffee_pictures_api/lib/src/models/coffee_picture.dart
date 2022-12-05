import 'package:coffee_pictures_api/coffee_pictures_api.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

part 'coffee_picture.g.dart';

/// {@template coffeePicture}
/// A single coffe picture item.
///
/// Contains a [file] and [id], in addition to a [isDownloaded]
/// flag.
///
/// If an [id] is provided, it cannot be empty. If no [id] is provided, one
/// will be generated.
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
    String? id,
    required this.file,
    this.isDownloaded = false,
  })  : assert(
          id == null || id.isNotEmpty,
          'id can not be null and should be empty',
        ),
        id = id ?? const Uuid().v4();

  /// The unique identifier of the coffee picture.
  ///
  /// Cannot be empty.
  final String id;

  /// The url of the coffe picture.
  ///
  /// Cannot be empty.
  final String file;

  /// Whether the coffee picture has been downloaded.
  ///
  /// Defaults to `false`.
  final bool isDownloaded;

  /// Returns a copy of this coffee picture with the given values updated.
  ///
  /// {@macro coffeePicture}
  CoffeePicture copyWith({
    String? id,
    String? file,
    bool? isDownloaded,
  }) {
    return CoffeePicture(
      id: id ?? this.id,
      file: file ?? this.file,
      isDownloaded: isDownloaded ?? this.isDownloaded,
    );
  }

  /// Deserializes the given [JsonMap] into a [CoffeePicture].
  static CoffeePicture fromJson(JsonMap json) => _$CoffeePictureFromJson(json);

  /// Converts this [CoffeePicture] into a [JsonMap].
  JsonMap toJson() => _$CoffeePictureToJson(this);

  @override
  List<Object> get props => [id, file, isDownloaded];
}
