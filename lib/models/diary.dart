class Diary {
  final int id;
  final String createdAt;
  final String title;
  final String content;
  final String imageUrl;
  final String userId;
  final String imageLocalPath;
  final String updatedAt;
  final String date;

  const Diary({
    required this.id,
    required this.createdAt,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.userId,
    required this.imageLocalPath,
    required this.updatedAt,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'userId': userId,
      'imageLocalPath': imageLocalPath,
      'updatedAt': updatedAt,
      'date': date,
    };
  }

  factory Diary.fromMap(Map<String, dynamic> map) {
    return Diary(
      id: map['id'],
      createdAt: map['createdAt'],
      title: map['title'],
      content: map['content'],
      imageUrl: map['imageUrl'],
      userId: map['userId'],
      imageLocalPath: map['imageLocalPath'],
      updatedAt: map['updatedAt'],
      date: map['date'],
    );
  }
}
