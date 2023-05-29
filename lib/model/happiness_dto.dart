import 'dart:convert';

class HappinessDto {
  String id;
  String userId;
  String text;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<String> permissions = const [];

  factory HappinessDto.fromJson(String str) =>
      HappinessDto.fromJson(json.decode(str));

  HappinessDto({
    required this.text,
    required this.id,
    required this.userId,
    this.createdAt,
    this.updatedAt,
    this.permissions = const [],
  });

  // u0024 ist das Dollar Zeichen $
  factory HappinessDto.fromMap(Map<String, dynamic> json) => HappinessDto(
        text: json["text"],
        createdAt: DateTime.parse(json["\u0024createdAt"]),
        updatedAt: DateTime.parse(json["\u0024updatedAt"]),
        id: json["\u0024id"],
        userId: json["userId"],
        permissions: List<String>.from(json["\u0024permissions"].map((x) => x)),
      );

  Map<String, dynamic> toMap() {
    final map = {"text": text};

    return map;
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}
