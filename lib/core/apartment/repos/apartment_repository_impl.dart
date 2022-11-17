import '../../base/exceptions.dart';
import '../../base/failure.dart';
import '../../base/result.dart';
import '../data/apartment_data_source.dart';
import '../entities/apartment.dart';
import '../entities/apartment_invitation.dart';
import 'apartment_repository.dart';

class ApartmentRepositoryImpl implements ApartmentRepository {
  final ApartmentDataSource apartmentDataSource;

  ApartmentRepositoryImpl({required this.apartmentDataSource});

  @override
  Future<Result<List<Apartment>>> addApartments(
      {required String housingCompanyId,
      required String building,
      List<String>? houseCodes}) async {
    try {
      final apartmentModels = await apartmentDataSource.addApartments(
          housingCompanyId: housingCompanyId,
          building: building,
          houseCodes: houseCodes);
      return ResultSuccess(
          apartmentModels.map((e) => Apartment.modelToEntity(e)).toList());
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<List<Apartment>>> getUserApartments({
    required String housingCompanyId,
  }) async {
    try {
      final apartmentModels = await apartmentDataSource.getUserApartments(
          housingCompanyId: housingCompanyId);
      return ResultSuccess(
          apartmentModels.map((e) => Apartment.modelToEntity(e)).toList());
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<ApartmentInvitation>> sendInvitationToApartment(
      {required String apartmentId,
      required String housingCompanyId,
      required int numberOfTenants,
      List<String>? emails}) async {
    try {
      final invitationModel =
          await apartmentDataSource.sendInvitationToApartment(
              housingCompanyId: housingCompanyId,
              apartmentId: apartmentId,
              numberOfTenants: numberOfTenants,
              emails: emails);
      return ResultSuccess(ApartmentInvitation.modelToEntity(invitationModel));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }
}
