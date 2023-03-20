import 'package:equatable/equatable.dart';
import 'package:priorli/core/apartment/entities/apartment.dart';

class JoinApartmentState extends Equatable {
  final String? code;
  final Apartment? addedToApartment;

  const JoinApartmentState({this.code, this.addedToApartment});

  JoinApartmentState copyWith({String? code, Apartment? addedToApartment}) =>
      JoinApartmentState(
          code: code ?? this.code,
          addedToApartment: addedToApartment ?? this.addedToApartment);

  @override
  List<Object?> get props => [code, addedToApartment];
}
