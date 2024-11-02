class DiaryEntry {
  final String id;
  final DateTime date;
  final String title;
  final String content;
  final String imageUrl;

  const DiaryEntry({
    required this.id,
    required this.date,
    required this.title,
    required this.content,
    required this.imageUrl,
  });

  // JSON 변환을 위한 메서드들
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
    };
  }

  factory DiaryEntry.fromJson(Map<String, dynamic> json) {
    return DiaryEntry(
      id: json['id'],
      date: DateTime.parse(json['date']),
      title: json['title'],
      content: json['content'],
      imageUrl: json['imageUrl'],
    );
  }
}
