import 'package:equatable/equatable.dart';
import 'package:priorli/core/apartment/entities/apartment.dart';

class JoinApartmentState extends Equatable {
  final String? companyId;
  final String? code;
  final Apartment? addedToApartment;

  const JoinApartmentState({this.code, this.companyId, this.addedToApartment});

  JoinApartmentState copyWith(
          {String? code, String? companyId, Apartment? addedToApartment}) =>
      JoinApartmentState(
          companyId: companyId ?? this.companyId,
          code: code ?? this.code,
          addedToApartment: addedToApartment ?? this.addedToApartment);

  @override
  List<Object?> get props => [code, companyId, addedToApartment];
}
