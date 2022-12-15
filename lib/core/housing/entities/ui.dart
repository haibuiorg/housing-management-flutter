import 'package:equatable/equatable.dart';
import 'package:priorli/core/housing/models/ui_model.dart';

class UI extends Equatable {
  final String? seedColor;

  const UI({this.seedColor});

  factory UI.modelToEntity(UIModel? uiModel) =>
      UI(seedColor: uiModel?.seedColor);

  UI copyWith({String? seedColor}) =>
      UI(seedColor: seedColor ?? this.seedColor);

  @override
  List<Object?> get props => [seedColor];
}
