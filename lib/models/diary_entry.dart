class DiaryEntry {
  final int? id;
  final String title;
  final String content;
  final String? imageUrl;
  final DateTime date;

  DiaryEntry({
    this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'date': date.toIso8601String(),
    };
  }

  factory DiaryEntry.fromMap(Map<String, dynamic> map) {
    return DiaryEntry(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      imageUrl: map['imageUrl'],
      date: DateTime.parse(map['date']),
    );
  }
}
