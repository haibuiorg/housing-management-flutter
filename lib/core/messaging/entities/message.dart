import 'package:equatable/equatable.dart';

import '../models/message_model.dart';

class Message extends Equatable {
  final int createdOn;
  final String? id;
  final String message;
  final String senderId;
  final String senderName;
  final int? updatedOn;
  final List<String>? seenBy;

  const Message(
      {required this.createdOn,
      this.id,
      required this.message,
      required this.senderId,
      required this.senderName,
      this.updatedOn,
      this.seenBy});

  MessageModel toModel({String? id}) => MessageModel(
      created_on: createdOn,
      id: id ?? this.id,
      message: message,
      sender_id: senderId,
      sender_name: senderName,
      updated_on: updatedOn,
      seen_by: seenBy);

  @override
  List<Object?> get props =>
      [createdOn, id, message, senderId, senderName, updatedOn, seenBy];

  factory Message.modelToEntity(MessageModel messageModel) => Message(
      updatedOn: messageModel.updated_on,
      seenBy: messageModel.seen_by,
      createdOn:
          messageModel.created_on ?? DateTime.now().millisecondsSinceEpoch,
      id: messageModel.id,
      message: messageModel.message ?? '',
      senderId: messageModel.sender_id ?? '',
      senderName: messageModel.sender_name ?? '');
}
