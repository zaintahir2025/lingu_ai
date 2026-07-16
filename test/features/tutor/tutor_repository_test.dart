import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:lingu_ai/features/tutor/data/repositories/tutor_repository.dart';

void main() {
  group('TutorRepository SSE Tests', () {
    test('Mock stream yields tokens correctly', () async {
      final repo = TutorRepository(Dio());
      
      final stream = repo.mockStreamTutorMessage('hello', ['word1', 'word2']);
      final tokens = await stream.toList();

      expect(tokens, isNotEmpty);
      expect(tokens.join(''), contains('word1'));
      expect(tokens.join(''), contains('word2'));
      expect(tokens.join(''), contains('Hi there!'));
    });
  });
}
