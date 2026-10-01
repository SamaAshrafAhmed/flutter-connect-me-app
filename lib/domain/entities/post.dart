class Post {
  final String id;
  final String authorId;
  final String authorName;
  final String content;
  final DateTime timestamp;

  new({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.content,
    required this.timestamp,
  });
}
