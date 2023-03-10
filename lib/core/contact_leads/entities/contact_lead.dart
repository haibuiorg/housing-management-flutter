import 'package:equatable/equatable.dart';

import '../models/contact_lead_model.dart';

class ContactLead extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String message;
  final int? createdOn;
  final String status;
  final String type;

  const ContactLead({
    required this.id,
    required this.name,
    required this.email,
    required this.message,
    required this.createdOn,
    required this.phone,
    required this.status,
    required this.type,
  });

  factory ContactLead.modelToEntity(ContactLeadModel model) {
    return ContactLead(
      id: model.id,
      name: model.name ?? '',
      email: model.email ?? '',
      message: model.message ?? '',
      createdOn: model.created_on ?? DateTime.now().millisecondsSinceEpoch,
      phone: model.phone ?? '',
      status: model.status,
      type: model.type,
    );
  }

  @override
  List<Object?> get props =>
      [id, name, email, message, createdOn, type, status, phone];
}
