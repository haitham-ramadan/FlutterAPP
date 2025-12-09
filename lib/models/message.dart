import 'package:hive/hive.dart';

part 'message.g.dart';

@HiveType(typeId: 0)
class Message extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String text;

  @HiveField(2)
  final DateTime timestamp;

  @HiveField(3)
  final bool isUser;

  Message({
    required this.id,
    required this.text,
    required this.timestamp,
    required this.isUser,
  });
}
