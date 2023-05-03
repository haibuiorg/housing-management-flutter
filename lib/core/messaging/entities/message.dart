import 'package:equatable/equatable.dart';
import 'package:priorli/core/messaging/entities/translation.dart';
import 'package:priorli/core/storage/entities/storage_item.dart';

import '../models/message_model.dart';

class Message extends Equatable {
  final int createdOn;
  final String? id;
  final String message;
  final String senderId;
  final String senderName;
  final int? updatedOn;
  final List<String>? seenBy;
  final List<StorageItem>? storageItems;
  final List<Translation>? translatedMessage;

  const Message(
      {required this.createdOn,
      this.id,
      required this.message,
      required this.senderId,
      required this.senderName,
      this.storageItems,
      this.updatedOn,
      this.translatedMessage,
      this.seenBy});

  Message copyWith({
    int? createdOn,
    String? id,
    String? message,
    String? senderId,
    String? senderName,
    int? updatedOn,
    List<String>? seenBy,
    List<Translation>? translatedMessage,
    List<StorageItem>? storageItems,
  }) =>
      Message(
          createdOn: createdOn ?? this.createdOn,
          id: id ?? this.id,
          translatedMessage: translatedMessage ?? this.translatedMessage,
          message: message ?? this.message,
          senderId: senderId ?? this.senderId,
          senderName: senderName ?? this.senderName,
          storageItems: storageItems ?? this.storageItems,
          updatedOn: updatedOn ?? this.updatedOn,
          seenBy: seenBy ?? this.seenBy);

  @override
  List<Object?> get props => [
        createdOn,
        id,
        message,
        senderId,
        senderName,
        updatedOn,
        seenBy,
        storageItems,
        translatedMessage
      ];

  factory Message.modelToEntity(MessageModel messageModel) => Message(
      updatedOn: messageModel.updated_on,
      seenBy: messageModel.seen_by,
      translatedMessage: messageModel.translated_message
          ?.map((e) => Translation.modelToEntity(e))
          .toList(),
      storageItems: messageModel.storage_items
          ?.map((e) => StorageItem.modelToEntity(e))
          .toList(),
      createdOn:
          messageModel.created_on ?? DateTime.now().millisecondsSinceEpoch,
      id: messageModel.id,
      message: messageModel.message ?? '',
      senderId: messageModel.sender_id ?? '',
      senderName: messageModel.sender_name ?? '');
}
