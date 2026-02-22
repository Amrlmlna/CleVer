class NotificationEntity {
  final String id;
  final String? title;
  final String body;
  final DateTime timestamp;
  final bool isRead;
  final String? payload;

  NotificationEntity({
    required this.id,
    this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
    this.payload,
  });

  NotificationEntity copyWith({
    bool? isRead,
    String? title,
  }) {
    return NotificationEntity(
      id: id,
      title: title ?? this.title,
      body: body,
      timestamp: timestamp,
      isRead: isRead ?? this.isRead,
      payload: payload,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'timestamp': timestamp.toIso8601String(),
    'isRead': isRead,
    'payload': payload,
  };

  factory NotificationEntity.fromJson(Map<String, dynamic> json) => NotificationEntity(
    id: json['id'],
    title: json['title'],
    body: json['body'],
    timestamp: DateTime.parse(json['timestamp']),
    isRead: json['isRead'],
    payload: json['payload'],
  );
}
