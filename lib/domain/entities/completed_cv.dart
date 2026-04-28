import 'dart:convert';

class CompletedCV {
  final String id;
  final String jobTitle;
  final String templateId;
  final String pdfPath;
  final String? remotePdfUrl;
  final String? remotePath;
  final String? thumbnailPath;
  final DateTime generatedAt;

  const CompletedCV({
    required this.id,
    required this.jobTitle,
    required this.templateId,
    required this.pdfPath,
    this.remotePdfUrl,
    this.remotePath,
    this.thumbnailPath,
    required this.generatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'jobTitle': jobTitle,
    'templateId': templateId,
    'pdfPath': pdfPath,
    'remotePdfUrl': remotePdfUrl,
    'remotePath': remotePath,
    'thumbnailPath': thumbnailPath,
    'generatedAt': generatedAt.toIso8601String(),
  };

  factory CompletedCV.fromJson(Map<String, dynamic> json) => CompletedCV(
    id: json['id'] as String,
    jobTitle: json['jobTitle'] as String,
    templateId: json['templateId'] as String,
    pdfPath: json['pdfPath'] as String,
    remotePdfUrl: json['remotePdfUrl'] as String?,
    remotePath: json['remotePath'] as String?,
    thumbnailPath: json['thumbnailPath'] as String?,
    generatedAt: DateTime.parse(json['generatedAt'] as String),
  );

  CompletedCV copyWith({
    String? id,
    String? jobTitle,
    String? templateId,
    String? pdfPath,
    String? remotePdfUrl,
    String? remotePath,
    String? thumbnailPath,
    DateTime? generatedAt,
  }) {
    return CompletedCV(
      id: id ?? this.id,
      jobTitle: jobTitle ?? this.jobTitle,
      templateId: templateId ?? this.templateId,
      pdfPath: pdfPath ?? this.pdfPath,
      remotePdfUrl: remotePdfUrl ?? this.remotePdfUrl,
      remotePath: remotePath ?? this.remotePath,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      generatedAt: generatedAt ?? this.generatedAt,
    );
  }

  static List<CompletedCV> listFromJsonString(String jsonString) {
    final list = jsonDecode(jsonString) as List;
    return list
        .map((e) => CompletedCV.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static String listToJsonString(List<CompletedCV> cvs) {
    return jsonEncode(cvs.map((e) => e.toJson()).toList());
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompletedCV &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          jobTitle == other.jobTitle &&
          templateId == other.templateId &&
          pdfPath == other.pdfPath &&
          remotePdfUrl == other.remotePdfUrl &&
          remotePath == other.remotePath &&
          thumbnailPath == other.thumbnailPath &&
          generatedAt == other.generatedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      jobTitle.hashCode ^
      templateId.hashCode ^
      pdfPath.hashCode ^
      remotePdfUrl.hashCode ^
      remotePath.hashCode ^
      thumbnailPath.hashCode ^
      generatedAt.hashCode;
}
