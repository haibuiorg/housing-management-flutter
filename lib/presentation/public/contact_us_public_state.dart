import 'package:equatable/equatable.dart';

class ContactUsPublicState extends Equatable {
  final String? languageCode;
  final String? formType;

  const ContactUsPublicState({this.languageCode, this.formType});

  @override
  List<Object?> get props => [languageCode, formType];
}
