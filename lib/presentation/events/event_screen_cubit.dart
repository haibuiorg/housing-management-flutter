import 'package:bloc/bloc.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/event/entities/event.dart';
import 'package:priorli/core/event/entities/event_type.dart';
import 'package:priorli/core/event/entities/repeat.dart';
import 'package:priorli/core/event/usecases/create_event.dart';
import 'package:priorli/core/event/usecases/edit_event.dart';
import 'package:priorli/core/event/usecases/get_event.dart';
import 'package:priorli/core/event/usecases/response_to_event.dart';
import 'package:priorli/core/housing/entities/housing_company.dart';
import 'package:priorli/core/housing/usecases/get_housing_company.dart';
import 'package:priorli/core/user/entities/user.dart';
import 'package:priorli/core/user/usecases/get_user_info.dart';
import 'package:priorli/presentation/events/event_screen_state.dart';

class EventScreenCubit extends Cubit<EventScreenState> {
  final GetEvent _getEvent;
  final CreateEvent _createEvent;
  final EditEvent _editEvent;
  final GetUserInfo _getUserInfo;
  final GetHousingCompany _getHousingCompany;
  final ResponseToEvent _responseToEvent;
  EventScreenCubit(this._getEvent, this._createEvent, this._editEvent,
      this._getUserInfo, this._getHousingCompany, this._responseToEvent)
      : super(const EventScreenState());
  Future<void> init(
      {String? eventId, String? companyId, String? apartmentId}) async {
    getUserData();

    if (eventId != null) {
      final getEventResult = await _getEvent(GetEventParams(id: eventId));
      if (getEventResult is ResultSuccess<Event>) {
        getCompanyData(getEventResult.data.companyId ?? '');
        await Future.delayed(const Duration(milliseconds: 100));
        emit(state.copyWith(
            event: getEventResult.data,
            apartmentId: getEventResult.data.apartmentId,
            companyId: getEventResult.data.companyId,
            isInitializing: false));

        return;
      }
    }
    getCompanyData(companyId ?? '').then((value) => emit(state.copyWith(
        companyId: companyId,
        apartmentId: apartmentId,
        isInitializing: state.company?.isUserManager == false)));
  }

  Future<void> getUserData() async {
    final getUserResult = await _getUserInfo(NoParams());
    if (getUserResult is ResultSuccess<User>) {
      emit(state.copyWith(userId: getUserResult.data.userId));
    }
  }

  Future<void> getCompanyData(String companyId) async {
    final getCompanyResult = await _getHousingCompany(
        GetHousingCompanyParams(housingCompanyId: companyId));
    if (getCompanyResult is ResultSuccess<HousingCompany>) {
      emit(
          state.copyWith(company: getCompanyResult.data, companyId: companyId));
    }
  }

  Future<Event?> createEvent(
      {required String name,
      required String description,
      required int startTime,
      required int endTime,
      required EventType type,
      required List<String> invitees,
      List<int>? reminders,
      int? repeatUntil,
      Repeat? repeat}) async {
    final createEventResult = await _createEvent(CreateEventParams(
        name: name,
        description: description,
        startTime: startTime,
        endTime: endTime,
        type: type,
        repeat: repeat,
        invitees: invitees,
        reminders: reminders,
        repeatUntil: repeatUntil,
        companyId: state.companyId,
        apartmentId: state.apartmentId));
    if (createEventResult is ResultSuccess<Event>) {
      emit(state.copyWith(event: createEventResult.data));

      return createEventResult.data;
    }
    return state.event;
  }

  Future<Event?> editEvent(
      {String? name,
      String? description,
      int? startTime,
      int? endTime,
      EventType? type,
      List<int>? reminders,
      int? repeatUntil,
      Repeat? repeat}) async {
    final editEventResult = await _editEvent(EditEventParams(
        name: name,
        description: description,
        startTime: startTime,
        endTime: endTime,
        type: type,
        reminders: reminders,
        repeatUntil: repeatUntil,
        repeat: repeat,
        eventId: state.event?.id ?? ''));
    if (editEventResult is ResultSuccess<Event>) {
      emit(state.copyWith(event: editEventResult.data));
      return editEventResult.data;
    }
    return state.event;
  }

  Future<Event?> deleteEvent({
    required String eventId,
  }) async {
    final editEventResult =
        await _editEvent(EditEventParams(deleted: true, eventId: eventId));
    if (editEventResult is ResultSuccess<Event>) {
      emit(state.copyWith(event: editEventResult.data));
      return editEventResult.data;
    }

    return state.event;
  }

  Future<Event?> responseToEvent(bool? accepted) async {
    final responseToEventResult = await _responseToEvent(ResponseToEventParams(
        eventId: state.event?.id ?? '', accepted: accepted));
    if (responseToEventResult is ResultSuccess<Event>) {
      emit(state.copyWith(event: responseToEventResult.data));
      return responseToEventResult.data;
    }
    return state.event;
  }
}
