import 'package:equatable/equatable.dart';
import 'package:priorli/core/country/entities/country.dart';
import 'package:priorli/core/messaging/entities/conversation.dart';

class HelpState extends Equatable {
  final Conversation? createdConversation;
  final List<Country>? supportCountries;
  final String? selectedCountryCode;
  final String? selectedLanguageCode;

  const HelpState({
    this.createdConversation,
    this.supportCountries,
    this.selectedCountryCode,
    this.selectedLanguageCode,
  });

  HelpState copyWith(
          {Conversation? createdConversation,
          List<Country>? supportCountries,
          String? selectedCountryCode,
          String? selectedLanguageCode}) =>
      HelpState(
          selectedCountryCode: selectedCountryCode ?? this.selectedCountryCode,
          selectedLanguageCode:
              selectedLanguageCode ?? this.selectedCountryCode,
          createdConversation: createdConversation ?? this.createdConversation,
          supportCountries: supportCountries ?? this.supportCountries);

  @override
  List<Object?> get props => [
        createdConversation,
        supportCountries,
        selectedCountryCode,
        selectedLanguageCode
      ];
}
