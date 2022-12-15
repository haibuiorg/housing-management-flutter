import 'package:bloc/bloc.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/country/entities/country.dart';
import 'package:priorli/core/country/usecases/get_support_countries.dart';
import 'package:priorli/core/messaging/entities/conversation.dart';
import 'package:priorli/core/messaging/usecases/start_support_conversation.dart';
import 'package:priorli/presentation/help/help_state.dart';

class HelpCubit extends Cubit<HelpState> {
  final StartSupportConversation _startSupportConversation;
  final GetSupportCountries _getSupportCountries;
  HelpCubit(this._startSupportConversation, this._getSupportCountries)
      : super(const HelpState());

  Future<void> init() async {
    final getSupportCountryResult = await _getSupportCountries(NoParams());
    if (getSupportCountryResult is ResultSuccess<List<Country>>) {
      emit(state.copyWith(
          supportCountries: getSupportCountryResult.data,
          selectedCountryCode: getSupportCountryResult.data.first.countryCode,
          selectedLanguageCode:
              getSupportCountryResult.data.first.supportLanguages.first));
    }
  }

  Future<void> startSupportConversation(String name) async {
    final conversationResult = await _startSupportConversation(
        StartSupportConversationParams(
            countryCode: state.selectedCountryCode ?? '',
            name: name,
            languageCode: state.selectedLanguageCode ?? ''));
    if (conversationResult is ResultSuccess<Conversation>) {
      emit(state.copyWith(createdConversation: conversationResult.data));
    }
  }

  chooseNewCountry(String countryCode) {
    emit(state.copyWith(
        selectedCountryCode: countryCode,
        selectedLanguageCode: state.supportCountries
            ?.where((element) => element.countryCode == countryCode)
            .first
            .supportLanguages
            .first));
  }

  chooseNewLanguage(String languageCode) {
    emit(state.copyWith(selectedLanguageCode: languageCode));
  }
}
