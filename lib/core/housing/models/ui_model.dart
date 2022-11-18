import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'ui_model.g.dart';

@JsonSerializable()
class UIModel extends Equatable {
  @JsonKey(name: 'seed_color')
  final String? seedColor;

  const UIModel(this.seedColor);

  factory UIModel.fromJson(Map<String, dynamic> json) =>
      _$UIModelFromJson(json);

  @override
  List<Object?> get props => [seedColor];
}
