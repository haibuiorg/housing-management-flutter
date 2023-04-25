import 'package:equatable/equatable.dart';
import 'package:priorli/core/apartment/entities/apartment.dart';
import 'package:priorli/core/user/entities/user.dart';

class ApartmentManagementState extends Equatable {
  final Apartment? apartment;
  final Apartment? pendingApartment;
  final bool? deleted;
  final List<User>? tenants;
  final List<User>? owners;

  const ApartmentManagementState(
      {this.apartment,
      this.pendingApartment,
      this.deleted,
      this.tenants,
      this.owners});

  ApartmentManagementState copyWith({
    Apartment? apartment,
    Apartment? pendingApartment,
    bool? deleted,
    List<User>? tenants,
    List<User>? owners,
  }) =>
      ApartmentManagementState(
          deleted: deleted ?? this.deleted,
          apartment: apartment ?? this.apartment,
          pendingApartment: pendingApartment ?? this.pendingApartment,
          tenants: tenants ?? this.tenants,
          owners: owners ?? this.owners);

  @override
  List<Object?> get props =>
      [apartment, pendingApartment, deleted, owners, tenants];
}
