import 'package:equatable/equatable.dart';
import 'package:priorli/core/apartment/entities/apartment.dart';

class ApartmentManagementState extends Equatable {
  final Apartment? apartment;
  final Apartment? pendingApartment;

  const ApartmentManagementState({this.apartment, this.pendingApartment});

  ApartmentManagementState copyWith({
    Apartment? apartment,
    Apartment? pendingApartment,
  }) =>
      ApartmentManagementState(
          apartment: apartment ?? this.apartment,
          pendingApartment: pendingApartment ?? this.pendingApartment);

  @override
  List<Object?> get props => [apartment, pendingApartment];
}
