import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectme_app/data/models/post_model.dart';
import 'package:connectme_app/data/models/user_builder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserBuilder', () {
    test('builds only the profile fields supplied by the caller', () {
      final user = UserBuilder()
          .setId('user-1')
          .setFullName('Maya Hassan')
          .setEmail('maya@example.com')
          .build();

      expect(user.id, 'user-1');
      expect(user.fullName, 'Maya Hassan');
      expect(user.email, 'maya@example.com');
      expect(user.profileImageUrl, isNull);
    });
  });

  group('PostModel', () {
    test('round trips Firestore JSON without losing the author id', () {
      final timestamp = DateTime.utc(2026, 1, 1, 12);
      final post = PostModel(
        id: 'post-1',
        authorId: 'user-1',
        authorName: 'Maya Hassan',
        content: 'Hello community',
        timestamp: timestamp,
      );

      final decoded = PostModel.fromJson(post.toJson());

      expect(decoded.id, post.id);
      expect(decoded.authorId, post.authorId);
      expect(decoded.authorName, post.authorName);
      expect(decoded.content, post.content);
      expect(decoded.timestamp.toUtc(), timestamp);
      expect(post.toJson()['timestamp'], isA<Timestamp>());
    });
  });
}
