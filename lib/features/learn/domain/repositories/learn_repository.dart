import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../../../../core/database/database.dart';

import '../../../../core/storage/onboarding_storage.dart';
import '../../data/vocab_data.dart';

class LearnRepository {
  final AppDatabase _db;
  final OnboardingStorage? _onboardingStorage;

  LearnRepository(this._db, [this._onboardingStorage]);

  Future<void> syncLessonsIfEmpty() async {
    final count = await _db.select(_db.lessons).get();
    if (count.isEmpty) {
      await _db.batch((batch) {
        batch.insertAll(_db.lessons, [
          LessonsCompanion.insert(id: const Value(1), topic: 'Greetings & Salutations', cefrLevel: 'A1', orderIndex: 1, isLocked: const Value(false), isCompleted: const Value(false)),
          LessonsCompanion.insert(id: const Value(2), topic: 'Introductions & Names', cefrLevel: 'A1', orderIndex: 2, isLocked: const Value(false), isCompleted: const Value(false)),
          LessonsCompanion.insert(id: const Value(3), topic: 'Numbers & Counting', cefrLevel: 'A1', orderIndex: 3, isLocked: const Value(false), isCompleted: const Value(false)),
          LessonsCompanion.insert(id: const Value(4), topic: 'Food & Dining', cefrLevel: 'A1', orderIndex: 4, isLocked: const Value(false), isCompleted: const Value(false)),
          LessonsCompanion.insert(id: const Value(5), topic: 'Family & Relations', cefrLevel: 'A1', orderIndex: 5, isLocked: const Value(false), isCompleted: const Value(false)),
          LessonsCompanion.insert(id: const Value(6), topic: 'Travel & Directions', cefrLevel: 'A2', orderIndex: 6, isLocked: const Value(true), isCompleted: const Value(false)),
          LessonsCompanion.insert(id: const Value(7), topic: 'Shopping & Prices', cefrLevel: 'A2', orderIndex: 7, isLocked: const Value(true), isCompleted: const Value(false)),
          LessonsCompanion.insert(id: const Value(8), topic: 'Daily Routine', cefrLevel: 'A2', orderIndex: 8, isLocked: const Value(true), isCompleted: const Value(false)),
          LessonsCompanion.insert(id: const Value(9), topic: 'Weather & Seasons', cefrLevel: 'A2', orderIndex: 9, isLocked: const Value(true), isCompleted: const Value(false)),
          LessonsCompanion.insert(id: const Value(10), topic: 'Home & Living', cefrLevel: 'A2', orderIndex: 10, isLocked: const Value(true), isCompleted: const Value(false)),
          LessonsCompanion.insert(id: const Value(11), topic: 'Work & Office', cefrLevel: 'B1', orderIndex: 11, isLocked: const Value(true), isCompleted: const Value(false)),
          LessonsCompanion.insert(id: const Value(12), topic: 'Health & Wellness', cefrLevel: 'B1', orderIndex: 12, isLocked: const Value(true), isCompleted: const Value(false)),
          LessonsCompanion.insert(id: const Value(13), topic: 'Technology & Media', cefrLevel: 'B2', orderIndex: 13, isLocked: const Value(true), isCompleted: const Value(false)),
          LessonsCompanion.insert(id: const Value(14), topic: 'Culture & Arts', cefrLevel: 'B2', orderIndex: 14, isLocked: const Value(true), isCompleted: const Value(false)),
          LessonsCompanion.insert(id: const Value(15), topic: 'Emergency & Safety', cefrLevel: 'B2', orderIndex: 15, isLocked: const Value(true), isCompleted: const Value(false)),
        ]);
        
        batch.insertAllOnConflictUpdate(_db.vocabWords, seedVocabWords);
      });
    } else {
      // Sync any missing vocab words into existing database instances
      final existingVocabCount = await _db.select(_db.vocabWords).get();
      if (existingVocabCount.length < seedVocabWords.length) {
        await _db.batch((batch) {
          batch.insertAllOnConflictUpdate(_db.vocabWords, seedVocabWords);
        });
      }
    }
  }

  Future<void> completeLesson(int lessonId) async {
    await (_db.update(_db.lessons)
          ..where((t) => t.id.equals(lessonId)))
        .write(const LessonsCompanion(isCompleted: Value(true)));

    await (_db.update(_db.lessons)
          ..where((t) => t.id.equals(lessonId + 1)))
        .write(const LessonsCompanion(isLocked: Value(false)));
  }

  Stream<List<Lesson>> watchLessons() {
    return (_db.select(_db.lessons)..orderBy([(t) => OrderingTerm(expression: t.orderIndex)])).watch();
  }

  Future<List<VocabWord>> getVocabForLesson(int lessonId) async {
    final defaultWords = await (_db.select(_db.vocabWords)..where((t) => t.lessonId.equals(lessonId))).get();
    final langCode = _onboardingStorage?.targetLanguage?.toLowerCase() ?? 'es';

    if (langCode == 'es') return defaultWords;

    // Multi-Language Translations Map for Japanese, French, German, Urdu, English
    final Map<String, Map<String, String>> multiLangMap = {
      // Japanese (ja)
      'ja': {
        'Hola': 'こんにちは (Konnichiwa)',
        'Buenos días': 'おはようございます (Ohayou)',
        'Buenas tardes': 'こんにちは (Konnichiwa)',
        'Buenas noches': 'おやすみなさい (Oyasumi)',
        'Adiós': 'さようなら (Sayounara)',
        'Hasta luego': 'またね (Mata ne)',
        'Cómo estás': 'お元気ですか (Ogenki desu ka)',
        'Gracias': 'ありがとう (Arigatou)',
        'Por favor': 'お願いします (Onegai shimasu)',
        'De nada': 'どういたしまして (Douitashimashite)',
        'Cómo te llamas': 'お名前は何ですか (Onamae wa)',
        'Me llamo': '私の名前は (Watashi no namae wa)',
        'Mucho gusto': 'はじめまして (Hajimemashite)',
        'De dónde eres': 'どこから来ましたか (Doko kara)',
        'Soy de': '私は〜出身です (Watashi wa)',
        'Amigo': '友達 (Tomodachi)',
        'Señor': '〜さん (San)',
        'Señora': '〜さん (San)',
        'Hablo': '話します (Hanashimasu)',
        'Entiendo': '理解します (Rikai shimasu)',
        'Uno': '一 (Ichi)',
        'Dos': '二 (Ni)',
        'Tres': '三 (San)',
        'Cuatro': '四 (Yon)',
        'Cinco': '五 (Go)',
        'Seis': '六 (Roku)',
        'Siete': '七 (Nana)',
        'Ocho': '八 (Hachi)',
        'Nueve': '九 (Kyuu)',
        'Diez': '十 (Juu)',
        'Pan': 'パン (Pan)',
        'Agua': '水 (Mizu)',
        'Manzana': 'りんご (Ringo)',
        'Café': 'コーヒー (Koohii)',
        'Leche': '牛乳 (Gyūnyū)',
        'Queso': 'チーズ (Chiizu)',
        'Arroz': 'ご飯 (Gohan)',
        'Pollo': '鶏肉 (Toriniku)',
        'Restaurante': 'レストラン (Resutoran)',
        'Comida': '食べ物 (Tabemono)',
        'Madre': '母 (Haha)',
        'Padre': '父 (Chichi)',
        'Hermano': '兄 / 弟 (Kyōdai)',
        'Hermana': '姉 / 妹 (Shimai)',
        'Hijo': '息子 (Musuko)',
        'Hija': '娘 (Musume)',
        'Abuelo': '祖父 (Sofu)',
        'Abuela': '祖母 (Sobo)',
        'Familia': '家族 (Kazoku)',
        'Casa': '家 (Ie)',
      },
      // French (fr)
      'fr': {
        'Hola': 'Bonjour',
        'Buenos días': 'Bonjour',
        'Buenas tardes': 'Bon après-midi',
        'Buenas noches': 'Bonne nuit',
        'Adiós': 'Au revoir',
        'Hasta luego': 'À bientôt',
        'Cómo estás': 'Comment allez-vous',
        'Gracias': 'Merci',
        'Por favor': 'S\'il vous plaît',
        'De nada': 'De rien',
        'Cómo te llamas': 'Comment vous appelez-vous',
        'Me llamo': 'Je m\'appelle',
        'Mucho gusto': 'Enchanté',
        'De dónde eres': 'D\'où venez-vous',
        'Soy de': 'Je viens de',
        'Amigo': 'Ami',
        'Señor': 'Monsieur',
        'Señora': 'Madame',
        'Pan': 'Pain',
        'Agua': 'Eau',
        'Manzana': 'Pomme',
        'Café': 'Café',
        'Leche': 'Lait',
        'Restaurante': 'Restaurant',
        'Madre': 'Mère',
        'Padre': 'Père',
        'Hermano': 'Frère',
        'Hermana': 'Sœur',
        'Familia': 'Famille',
      },
      // German (de)
      'de': {
        'Hola': 'Hallo',
        'Buenos días': 'Guten Morgen',
        'Buenas tardes': 'Guten Tag',
        'Buenas noches': 'Gute Nacht',
        'Adiós': 'Auf Wiedersehen',
        'Hasta luego': 'Bis später',
        'Cómo estás': 'Wie geht es dir',
        'Gracias': 'Danke',
        'Por favor': 'Bitte',
        'De nada': 'Gern geschehen',
        'Pan': 'Brot',
        'Agua': 'Wasser',
        'Manzana': 'Apfel',
        'Café': 'Kaffee',
        'Leche': 'Milch',
        'Madre': 'Mutter',
        'Padre': 'Vater',
        'Hermano': 'Bruder',
        'Hermana': 'Schwester',
      },
      // Urdu (ur)
      'ur': {
        'Hola': 'سلام (Salam)',
        'Buenos días': 'صبح بخیر (Subah BaKhair)',
        'Buenas tardes': 'دوپہر بخیر (Dopahar BaKhair)',
        'Buenas noches': 'شب بخیر (Shab BaKhair)',
        'Adiós': 'خدا حافظ (Khuda Hafiz)',
        'Hasta luego': 'پھر ملیں گے (Phir Milengay)',
        'Cómo estás': 'آپ کیسے ہیں (Aap Kaise Hain)',
        'Gracias': 'شکریہ (Shukriya)',
        'Por favor': 'برائے مہربانی (Baraye Mehrbani)',
        'De nada': 'کوئی بات نہیں (Koi Baat Nahi)',
        'Pan': 'روٹی (Roti)',
        'Agua': 'پانی (Paani)',
        'Manzana': 'سیب (Saeb)',
        'Café': 'کافی (Coffee)',
        'Leche': 'دودھ (Doodh)',
        'Madre': 'امی (Ammi)',
        'Padre': 'ابو (Abbu)',
        'Hermano': 'بھائی (Bhai)',
        'Hermana': 'بہن (Behan)',
        'Familia': 'خاندان (Khandan)',
      },
    };

    final langTranslations = multiLangMap[langCode];
    if (langTranslations == null) return defaultWords;

    return defaultWords.map((item) {
      final translatedWord = langTranslations[item.word];
      if (translatedWord != null) {
        return item.copyWith(word: translatedWord);
      }
      return item;
    }).toList();
  }
}

final learnRepositoryProvider = Provider<LearnRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final onboardingStorage = ref.watch(onboardingStorageProvider);
  return LearnRepository(db, onboardingStorage);
});
