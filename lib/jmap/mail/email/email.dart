import 'package:equatable/equatable.dart';
import 'package:jmap_dart_client/http/converter/email/email_body_value_converter.dart';
import 'package:jmap_dart_client/http/converter/email/email_mailbox_ids_converter.dart';
import 'package:jmap_dart_client/http/converter/email_id_converter.dart';
import 'package:jmap_dart_client/http/converter/id_nullable_converter.dart';
import 'package:jmap_dart_client/http/converter/email/email_keyword_identifier_converter.dart';
import 'package:jmap_dart_client/http/converter/message_ids_header_value_converter.dart';
import 'package:jmap_dart_client/http/converter/thread_id_nullable_converter.dart';
import 'package:jmap_dart_client/http/converter/unsigned_int_nullable_converter.dart';
import 'package:jmap_dart_client/http/converter/utc_date_nullable_converter.dart';
import 'package:jmap_dart_client/jmap/core/id.dart';
import 'package:jmap_dart_client/jmap/core/properties/properties.dart';
import 'package:jmap_dart_client/jmap/core/reference_id.dart';
import 'package:jmap_dart_client/jmap/core/unsigned_int.dart';
import 'package:jmap_dart_client/jmap/core/utc_date.dart';
import 'package:jmap_dart_client/jmap/mail/email/email_address.dart';
import 'package:jmap_dart_client/jmap/mail/email/email_body_part.dart';
import 'package:jmap_dart_client/jmap/mail/email/email_body_value.dart';
import 'package:jmap_dart_client/jmap/mail/email/email_header.dart';
import 'package:jmap_dart_client/jmap/mail/email/keyword_identifier.dart';
import 'package:jmap_dart_client/jmap/mail/mailbox/mailbox.dart';

class Email with EquatableMixin {
  static Properties allProperties = Properties({
    'id', 'subject','from', 'to', 'cc', 'bcc', 'keywords', 'size', 'receivedAt',
    'sentAt', 'replyTo', 'preview', 'hasAttachment'
  });

  final EmailId id;
  final Id? blobId;
  final ThreadId? threadId;
  final Map<MailboxId, bool>? mailboxIds;
  final Map<KeyWordIdentifier, bool>? keywords;
  final UnsignedInt? size;
  final UTCDate? receivedAt;
  final Set<EmailHeader>? headers;
  final MessageIdsHeaderValue? messageId;
  final MessageIdsHeaderValue? inReplyTo;
  final MessageIdsHeaderValue? references;
  final String? subject;
  final UTCDate? sentAt;
  final bool? hasAttachment;
  final String? preview;
  final Set<EmailAddress>? sender;
  final Set<EmailAddress>? from;
  final Set<EmailAddress>? to;
  final Set<EmailAddress>? cc;
  final Set<EmailAddress>? bcc;
  final Set<EmailAddress>? replyTo;
  final Set<EmailBodyPart>? textBody;
  final Set<EmailBodyPart>? htmlBody;
  final Set<EmailBodyPart>? attachments;
  final EmailBodyPart? bodyStructure;
  final Map<PartId, EmailBodyValue>? bodyValues;

  Email(
    this.id,
    {this.blobId,
    this.threadId,
    this.mailboxIds,
    this.keywords,
    this.size,
    this.receivedAt,
    this.headers,
    this.messageId,
    this.inReplyTo,
    this.references,
    this.subject,
    this.sentAt,
    this.hasAttachment,
    this.preview,
    this.sender,
    this.from,
    this.to,
    this.cc,
    this.bcc,
    this.replyTo,
    this.textBody,
    this.htmlBody,
    this.attachments,
    this.bodyStructure,
    this.bodyValues,
  });

  factory Email.fromJson(Map<String, dynamic> json) {
    return Email(
      const EmailIdConverter().fromJson(json['id'] as String),
      blobId: const IdNullableConverter().fromJson(json['blobId'] as String?),
      threadId: const ThreadIdNullableConverter().fromJson(json['threadId'] as String?),
      mailboxIds: (json['mailboxIds'] as Map<String, dynamic>?)?.map((key, value) => EmailMailboxIdsConverter().parseEntry(key, value)),
      keywords: (json['keywords'] as Map<String, dynamic>?)?.map((key, value) => EmailKeywordIdentifierConverter().parseEntry(key, value)),
      size: const UnsignedIntNullableConverter().fromJson(json['size'] as int?),
      receivedAt: const UTCDateNullableConverter().fromJson(json['receivedAt'] as String?),
      headers: (json['headers'] as List<dynamic>?)?.map((json) => EmailHeader.fromJson(json)).toSet(),
      messageId: json['messageId'] == null
          ? null
          : const MessageIdsHeaderValueConverter().fromJson((json['messageId'] as List<dynamic>)),
      inReplyTo: json['inReplyTo'] == null
          ? null
          : const MessageIdsHeaderValueConverter().fromJson((json['inReplyTo'] as List<dynamic>)),
      references: json['references'] == null
          ? null
          : const MessageIdsHeaderValueConverter().fromJson((json['references'] as List<dynamic>)),
      subject: json['subject'] as String?,
      sentAt: const UTCDateNullableConverter().fromJson(json['sentAt'] as String?),
      hasAttachment: json['hasAttachment'] as bool?,
      preview: json['preview'] as String?,
      sender: (json['sender'] as List<dynamic>?)?.map((json) => EmailAddress.fromJson(json)).toSet(),
      from: (json['from'] as List<dynamic>?)?.map((json) => EmailAddress.fromJson(json)).toSet(),
      to: (json['to'] as List<dynamic>?)?.map((json) => EmailAddress.fromJson(json)).toSet(),
      cc: (json['cc'] as List<dynamic>?)?.map((json) => EmailAddress.fromJson(json)).toSet(),
      bcc: (json['bcc'] as List<dynamic>?)?.map((json) => EmailAddress.fromJson(json)).toSet(),
      replyTo: (json['replyTo'] as List<dynamic>?)?.map((json) => EmailAddress.fromJson(json)).toSet(),
      textBody: (json['textBody'] as List<dynamic>?)?.map((json) => EmailBodyPart.fromJson(json)).toSet(),
      htmlBody: (json['htmlBody'] as List<dynamic>?)?.map((json) => EmailBodyPart.fromJson(json)).toSet(),
      attachments: (json['attachments'] as List<dynamic>?)?.map((json) => EmailBodyPart.fromJson(json)).toSet(),
      bodyStructure: json['bodyStructure'] == null
          ? null
          : EmailBodyPart.fromJson(json['bodyStructure'] as Map<String, dynamic>),
      bodyValues: (json['bodyValues'] as Map<String, dynamic>?)?.map((key, value) => EmailBodyValueConverter().parseEntry(key, value)),
    );
  }

  Map<String, dynamic> toJson() {
    final val = <String, dynamic>{
      'id': const EmailIdConverter().toJson(id),
    };

    void writeNotNull(String key, dynamic value) {
      if (value != null) {
        val[key] = value;
      }
    }

    writeNotNull('blobId', const IdNullableConverter().toJson(blobId));
    writeNotNull('threadId', const ThreadIdNullableConverter().toJson(threadId));
    writeNotNull('mailboxIds', mailboxIds?.map((key, value) => EmailMailboxIdsConverter().toJson(key, value)));
    writeNotNull('keywords', keywords?.map((key, value) => EmailKeywordIdentifierConverter().toJson(key, value)));
    writeNotNull('size', const UnsignedIntNullableConverter().toJson(size));
    writeNotNull('receivedAt', const UTCDateNullableConverter().toJson(receivedAt));
    writeNotNull('headers', headers?.toList(),);
    writeNotNull('messageId', messageId != null ? const MessageIdsHeaderValueConverter().toJson(messageId!) : null);
    writeNotNull('inReplyTo', inReplyTo != null ? const MessageIdsHeaderValueConverter().toJson(inReplyTo!) : null);
    writeNotNull('references', references != null ? const MessageIdsHeaderValueConverter().toJson(references!) : null);
    writeNotNull('subject', subject);
    writeNotNull('sentAt', const UTCDateNullableConverter().toJson(sentAt));
    writeNotNull('hasAttachment', hasAttachment);
    writeNotNull('preview', preview);
    writeNotNull('sender', sender?.map((sender) => sender.toJson()).toList());
    writeNotNull('from', from?.map((from) => from.toJson()).toList());
    writeNotNull('to', to?.map((to) => to.toJson()).toList());
    writeNotNull('cc', cc?.map((cc) => cc.toJson()).toList());
    writeNotNull('bcc', bcc?.map((bcc) => bcc.toJson()).toList());
    writeNotNull('replyTo', replyTo?.map((replyTo) => replyTo.toJson()).toList());
    writeNotNull('textBody', textBody?.map((text) => text.toJson()).toList());
    writeNotNull('htmlBody', htmlBody?.map((html) => html.toJson()).toList());
    writeNotNull('attachments', attachments?.map((attachment) => attachment.toJson()).toList());
    writeNotNull('bodyStructure', bodyStructure?.toJson());
    writeNotNull('bodyValues', bodyValues?.map((key, value) => EmailBodyValueConverter().toJson(key, value)));
    return val;
  }

  @override
  List<Object?> get props => [
    id,
    subject,
    from,
    to,
    cc,
    bcc,
    keywords,
    size,
    receivedAt,
    sentAt,
    replyTo,
    preview,
    hasAttachment,
  ];
}

class EmailId with EquatableMixin {
  final Id id;

  EmailId(this.id);

  @override
  String toString() {
    if (id is ReferenceId) {
      return '${(id as ReferenceId).prefix.value}${(id as ReferenceId).id.value}';
    }
    return super.toString();
  }

  @override
  List<Object?> get props => [id];
}

class ThreadId with EquatableMixin {
  final Id id;

  ThreadId(this.id);

  @override
  List<Object?> get props => [id];
}

class MessageIdsHeaderValue with EquatableMixin {
  final Set<Id> ids;

  MessageIdsHeaderValue(this.ids);

  @override
  List<Object?> get props => [ids];
}