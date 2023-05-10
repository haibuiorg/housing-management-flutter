import 'package:equatable/equatable.dart';
import 'package:priorli/core/apartment/entities/apartment_invitation.dart';

import '../../core/user/entities/user.dart';

class TenantManagementState extends Equatable {
  final List<User>? tenants;
  final List<String>? owners;
  final int? limit;
  final String? companyId;
  final String? apartmentId;

  final List<ApartmentInvitation>? pendingInvitations;

  const TenantManagementState(
      {this.pendingInvitations,
      this.tenants,
      this.owners,
      this.limit = 4,
      this.companyId,
      this.apartmentId});
  TenantManagementState copyWith({
    List<User>? tenants,
    int? limit,
    String? companyId,
    List<String>? owners,
    String? apartmentId,
    List<ApartmentInvitation>? pendingInvitations,
  }) =>
      TenantManagementState(
          owners: owners ?? this.owners,
          tenants: tenants ?? this.tenants,
          limit: limit ?? this.limit,
          companyId: companyId ?? this.companyId,
          apartmentId: apartmentId ?? this.apartmentId,
          pendingInvitations: pendingInvitations ?? this.pendingInvitations);

  @override
  List<Object?> get props =>
      [tenants, pendingInvitations, limit, companyId, apartmentId, owners];
}
