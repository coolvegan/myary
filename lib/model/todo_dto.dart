import 'dart:convert';

class TodoDto {
  String content;
  bool isComplete;
  String id;
  String userId;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<String> permissions = const [];

  factory TodoDto.fromJson(String str) => TodoDto.fromJson(json.decode(str));

  TodoDto({
    required this.content,
    this.isComplete = false,
    required this.id,
    required this.userId,
    this.createdAt,
    this.updatedAt,
    this.permissions = const [],
  });

  // u0024 ist das Dollar Zeichen $
  factory TodoDto.fromMap(Map<String, dynamic> json) => TodoDto(
        content: json["content"],
        isComplete: json["isComplete"],
        id: json["\u0024id"],
        userId: json["userId"],
        createdAt: DateTime.parse(json["\u0024createdAt"]),
        updatedAt: DateTime.parse(json["\u0024updatedAt"]),
        permissions: List<String>.from(json["\u0024permissions"].map((x) => x)),
      );

  Map<String, dynamic> toMap() {
    final map = {
      "content": content,
      "isComplete": isComplete,
      "userId": userId
    };

    return map;
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}
