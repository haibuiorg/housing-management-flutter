import 'package:equatable/equatable.dart';
import 'package:priorli/core/apartment/entities/apartment.dart';

class ApartmentManagementState extends Equatable {
  final Apartment? apartment;
  final Apartment? pendingApartment;
  final bool? deleted;

  const ApartmentManagementState(
      {this.apartment, this.pendingApartment, this.deleted});

  ApartmentManagementState copyWith({
    Apartment? apartment,
    Apartment? pendingApartment,
    bool? deleted,
  }) =>
      ApartmentManagementState(
          deleted: deleted ?? this.deleted,
          apartment: apartment ?? this.apartment,
          pendingApartment: pendingApartment ?? this.pendingApartment);

  @override
  List<Object?> get props => [apartment, pendingApartment, deleted];
}
