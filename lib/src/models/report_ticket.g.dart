// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_ticket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportTicket _$ReportTicketFromJson(Map<String, dynamic> json) => ReportTicket(
      id: json['id'] as String,
      userInfo: User.fromJson(json['user_info'] as Map<String, dynamic>),
      blogInfo: Blog.fromJson(json['blog_info'] as Map<String, dynamic>?),
      ticketType: $enumDecode(_$ReportTicketTypeEnumMap, json['ticket_type']),
      title: json['title'] as String,
      description: json['description'] as String,
      createdAt:
          const _TimestampEpochConverter().fromJson(json['created_at'] as int),
    );

Map<String, dynamic> _$ReportTicketToJson(ReportTicket instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_info': instance.userInfo,
      'blog_info': instance.blogInfo,
      'ticket_type': _$ReportTicketTypeEnumMap[instance.ticketType]!,
      'title': instance.title,
      'description': instance.description,
      'created_at': const _TimestampEpochConverter().toJson(instance.createdAt),
    };

const _$ReportTicketTypeEnumMap = {
  ReportTicketType.copyright: 'copyright',
  ReportTicketType.spam: 'spam',
  ReportTicketType.childAbuse: 'childAbuse',
  ReportTicketType.pornography: 'pornography',
  ReportTicketType.violence: 'violence',
  ReportTicketType.fakeAccount: 'fakeAccount',
  ReportTicketType.other: 'other',
};
