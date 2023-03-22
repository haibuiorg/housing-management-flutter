import 'package:equatable/equatable.dart';

import '../models/legal_document_model.dart';

class LegalDocument extends Equatable {
  final String id;
  final String type;
  final bool isActive;
  final int createdOn;
  final String countryCode;
  final String countryId;
  final String? storageLink;
  final String webUrl;
  final String? url;

  const LegalDocument({
    required this.id,
    required this.type,
    required this.isActive,
    required this.createdOn,
    required this.countryCode,
    required this.countryId,
    this.storageLink,
    required this.webUrl,
    this.url,
  });

  factory LegalDocument.modelToEntity(LegalDocumentModel model) =>
      LegalDocument(
          id: model.id,
          type: model.type,
          isActive: model.is_active,
          createdOn: model.created_on,
          countryCode: model.country_code,
          countryId: model.country_id,
          storageLink: model.storage_link,
          webUrl: model.web_url,
          url: model.url);

  @override
  List<Object?> get props => [
        id,
        type,
        isActive,
        createdOn,
        countryCode,
        countryId,
        storageLink,
        webUrl,
        url
      ];
}
