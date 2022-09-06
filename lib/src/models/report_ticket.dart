import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egnimos/src/models/blog.dart';
import 'package:egnimos/src/models/user.dart';
import 'package:egnimos/src/utility/enum.dart';
import 'package:json_annotation/json_annotation.dart';

part 'report_ticket.g.dart';

@JsonSerializable()
@_TimestampEpochConverter()
class ReportTicket {
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'user_info')
  final User userInfo;
  @JsonKey(name: 'blog_info')
  final Blog blogInfo;
  @JsonKey(name: 'ticket_type')
  final ReportTicketType ticketType;
  @JsonKey(name: 'title')
  final String title;
  @JsonKey(name: 'description')
  final String description;
  @JsonKey(name: 'created_at')
  final Timestamp createdAt;

  ReportTicket({
    required this.id,
    required this.userInfo,
    required this.blogInfo,
    required this.ticketType,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  //toJson
  Map<String, dynamic> toJson() => _$ReportTicketToJson(this);

  //fromJson
  factory ReportTicket.fromJson(Map<String, dynamic> data) =>
      _$ReportTicketFromJson(data);
}

class _TimestampEpochConverter implements JsonConverter<Timestamp, int> {
  const _TimestampEpochConverter();

  @override
  Timestamp fromJson(int millisecond) =>
      Timestamp.fromMillisecondsSinceEpoch(millisecond);

  @override
  int toJson(Timestamp object) => object.millisecondsSinceEpoch;
}
