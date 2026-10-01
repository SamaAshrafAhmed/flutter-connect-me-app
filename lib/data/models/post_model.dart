import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectme_app/domain/entities/post.dart';

class PostModel extends Post {
  new({
    required super.id,
    required super.authorId,
    required super.authorName,
    required super.content,
    required super.timestamp,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    final timestamp = json['timestamp'];
    DateTime postTime;

    if (timestamp is Timestamp) {
      postTime = timestamp.toDate();
    } else if (timestamp is DateTime) {
      postTime = timestamp;
    } else {
      postTime = DateTime.now();
    }
    return PostModel(
      id: json['id'] ?? '',
      authorId: json['auhtorId'] ?? '',
      authorName: json['authorName'] ?? '',
      content: json['content'] ?? '',
      timestamp: postTime,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'auhtorId': authorId,
    'authorName': authorName,
    'content': content,
    'timestamp': Timestamp.fromDate(timestamp),
  };
}
