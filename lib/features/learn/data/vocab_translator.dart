import 'package:drift/drift.dart' show Value;
import '../../../../core/database/database.dart';

class VocabTranslator {
  // English -> Urdu Translation Dictionaries
  static const Map<String, String> _englishToUrduWordMap = {
    'Hello': 'سلام (Salam)',
    'Good morning': 'صبح بخیر (Subah BaKhair)',
    'Good afternoon': 'دوپہر بخیر (Dopahar BaKhair)',
    'Good night': 'شب بخیر (Shab BaKhair)',
    'Goodbye': 'خدا حافظ (Khuda Hafiz)',
    'See you later': 'پھر ملیں گے (Phir Milengay)',
    'How are you': 'آپ کیسے ہیں (Aap Kaise Hain)',
    'Thank you': 'شکریہ (Shukriya)',
    'Please': 'برائے مہربانی (Baraye Mehrbani)',
    'You are welcome': 'کوئی بات نہیں (Koi Baat Nahi)',
    'Well / Good': 'بہت اچھا (Boht Acha)',
    'Bad': 'برا (Bura)',
    'Yes': 'جی ہاں (Ji Haan)',
    'No': 'جی نہیں (Ji Nahi)',
    'Sorry': 'معاف کیجیے (Maaf Kijiyay)',
    'Excuse me': 'معذرت (Maazrat)',
    'Welcome': 'خوش آمدید (Khush Aamdeed)',
    'Thank you very much': 'بہت بہت شکریہ (Boht Boht Shukriya)',
    'See you tomorrow': 'کل ملیں گے (Kal Milengay)',
    'Take care': 'اپنا خیال رکھیں (Apna Khayal Rakhein)',
    'What\'s up / How\'s it going': 'کیا حال ہے (Kya Haal Hai)',
    'Pleased to meet you': 'آپ سے مل کر خوشی ہوئی',
    'What is your name': 'آپ کا نام کیا ہے (Aap Ka Naam Kya Hai)',
    'My name is': 'میرا نام ... ہے (Mera Naam ... Hai)',
    'Nice to meet you': 'مل کر خوشی ہوئی (Mil Kar Khushi Hui)',
    'Where are you from': 'آپ کہاں سے ہیں (Aap Kahan Se Hain)',
    'I am from': 'میں ... سے ہوں (Mein ... Se Hoon)',
    'Friend': 'دوست (Dost)',
    'Mister / Sir': 'جناب (Janab)',
    'Ma\'am / Madam': 'محترمہ (Mohtarma)',
    'I speak': 'میں بولتا ہوں (Mein Bolta Hoon)',
    'I understand': 'میں سمجھتا ہوں (Mein Samajhta Hoon)',
    'Student': 'طالب علم (Taleb-e-Ilm)',
    'Teacher': 'استاد (Ustaad)',
    'Language': 'زبان (Zaban)',
    'Country': 'ملک (Mulk)',
    'City': 'شہر (Shehar)',
    'One': 'ایک (Ek)',
    'Two': 'دو (Do)',
    'Three': 'تین (Teen)',
    'Four': 'چار (Char)',
    'Five': 'پانچ (Paanch)',
    'Six': 'چھ (Chhe)',
    'Seven': 'سات (Saat)',
    'Eight': 'آٹھ (Aath)',
    'Nine': 'نو (Nau)',
    'Ten': 'دس (Das)',
    'Bread': 'روٹی (Roti)',
    'Water': 'پانی (Paani)',
    'Apple': 'سیب (Saeb)',
    'Coffee': 'کافی (Coffee)',
    'Milk': 'دودھ (Doodh)',
    'Cheese': 'پنیر (Paneer)',
    'Rice': 'چاول (Chawal)',
    'Chicken': 'مرغی (Murghi)',
    'Restaurant': 'ریسٹورنٹ (Restaurant)',
    'Food': 'کھانا (Khana)',
    'Mother': 'امی (Ammi)',
    'Padre': 'ابو (Abbu)',
    'Brother': 'بھائی (Bhai)',
    'Sister': 'بہن (Behan)',
    'Son': 'بیٹا (Beta)',
    'Daughter': 'بیٹی (Beti)',
    'Grandfather': 'دادا (Dada)',
    'Grandmother': 'دادی (Dadi)',
    'Family': 'خاندان (Khandan)',
    'Home': 'گھر (Ghar)',
  };

  static const Map<String, String> _englishToUrduSentenceMap = {
    'Hello! How are you?': 'سلام! آپ کیسے ہیں؟',
    'Good morning, sir.': 'صبح بخیر، جناب۔',
    'Good afternoon everyone.': 'آپ سب کو دوپہر بخیر۔',
    'Good night, sleep well.': 'شب بخیر، اچھی نیند سوئیں۔',
    'Goodbye, see you tomorrow.': 'خدا حافظ، کل ملتے ہیں۔',
    'I have to go, see you later.': 'مجھے جانا ہے، پھر ملیں گے۔',
    'Hello Maria, how are you?': 'سلام ماریا، آپ کیسی ہیں؟',
    'Thank you very much for your help.': 'آپ کی مدد کا بہت بہت شکریہ۔',
    'A coffee, please.': 'ایک کافی، برائے مہربانی۔',
    '- Thank you. - You are welcome.': '- شکریہ۔ - کوئی بات نہیں۔',
    'I am very well, thank you.': 'میں بالکل ٹھیک ہوں، شکریہ۔',
    'Today I feel a bit bad.': 'آج میں تھوڑا برا محسوس کر رہا ہوں۔',
    'Yes, I would like to go.': 'جی ہاں، میں جانا پسند کروں گا۔',
    'No, I do not want more.': 'جی نہیں، مجھے اور نہیں چاہیے۔',
    'Sorry, I didn\'t hear you.': 'معاف کیجیے، میں نے آپ کو نہیں سنا۔',
    'Excuse me, where is the bathroom?': 'معذرت، باتھ روم کہاں ہے؟',
    'Welcome to our home!': 'ہمارے گھر میں خوش آمدید!',
    'Thank you very much for the gift.': 'تحفے کا بہت بہت شکریہ۔',
    'It is late, see you tomorrow.': 'دیر ہو گئی ہے، کل ملتے ہیں۔',
    'Goodbye friend, take care.': 'خدا حافظ دوست، اپنا خیال رکھنا۔',
    'Hello Pedro! How is everything going?': 'سلام پیڈرو! سب کیسا چل رہا ہے؟',
    'Pleased to meet you.': 'آپ سے مل کر خوشی ہوئی۔',
    'Hello, what is your name?': 'سلام، آپ کا نام کیا ہے؟',
    'My name is Pedro.': 'میرا نام پیڈرو ہے۔',
    'Nice to meet you.': 'آپ سے مل کر خوشی ہوئی۔',
    'Where are you from?': 'آپ کہاں سے ہیں؟',
    'I am from Spain.': 'میں اسپین سے ہوں۔',
    'He is my best friend.': 'وہ میرا بہترین دوست ہے۔',
    'Mr. Garcia is not here.': 'مسٹر گارسیہ یہاں نہیں ہیں۔',
    'Good morning, Mrs. Lopez.': 'صبح بخیر، مسز لوپیز۔',
    'I speak a little Spanish.': 'میں تھوڑی سی زبان بولتا ہوں۔',
    'I do not understand what you are saying.': 'میں نہیں سمجھا کہ آپ کیا کہہ رہے ہیں۔',
    'I am a medical student.': 'میں طب کا طالب علم ہوں۔',
    'My teacher is very strict.': 'میرے استاد بہت سخت ہیں۔',
    'I want to learn a new language.': 'میں ایک نئی زبان سیکھنا چاہتا ہوں۔',
    'Mexico is a beautiful country.': 'میکسیکو ایک خوبصورت ملک ہے۔',
    'I live in a big city.': 'میں ایک بڑے شہر میں رہتا ہوں۔',
  };

  static const Map<String, Map<String, String>> _targetWordMap = {
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
      'Uno': 'Un',
      'Dos': 'Deux',
      'Tres': 'Trois',
      'Cuatro': 'Quatre',
      'Cinco': 'Cinq',
      'Pan': 'Pain',
      'Agua': 'Eau',
      'Manzana': 'Pomme',
      'Café': 'Café',
      'Leche': 'Lait',
      'Madre': 'Mère',
      'Padre': 'Père',
    },
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
      'Cómo te llamas': 'お名前は何ですか',
      'Me llamo': '私の名前は',
      'Mucho gusto': 'はじめまして',
      'De dónde eres': 'どこから来ましたか',
      'Soy de': '私は〜出身です',
      'Amigo': '友達',
      'Señor': '〜さん',
      'Uno': '一 (Ichi)',
      'Dos': '二 (Ni)',
      'Tres': '三 (San)',
      'Pan': 'パン (Pan)',
      'Agua': '水 (Mizu)',
      'Manzana': 'りんご (Ringo)',
      'Café': 'コーヒー (Koohii)',
      'Madre': '母 (Haha)',
      'Padre': '父 (Chichi)',
    },
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
      'Madre': 'Mutter',
      'Padre': 'Vater',
    },
  };

  static const Map<String, Map<String, String>> _targetSentenceMap = {
    'fr': {
      '¡Hola! ¿Cómo estás?': 'Bonjour! Comment allez-vous?',
      'Buenos días, señor.': 'Bonjour, monsieur.',
      'Buenas tardes a todos.': 'Bon après-midi à tous.',
      'Buenas noches, que duermas bien.': 'Bonne nuit, dors bien.',
      'Adiós, nos vemos mañana.': 'Au revoir, à demain.',
      'Me tengo que ir, hasta luego.': 'Je dois y aller, à bientôt.',
      'Hola María, ¿cómo estás?': 'Bonjour Maria, comment allez-vous?',
      'Muchas gracias por tu ayuda.': 'Merci beaucoup pour votre aide.',
      'Un café, por favor.': 'Un café, s\'il vous plaît.',
      '- Gracias. - De nada.': '- Merci. - De rien.',
    },
    'ja': {
      '¡Hola! ¿Cómo estás?': 'こんにちは！お元気ですか？',
      'Buenos días, señor.': 'おはようございます、先生。',
      'Buenas tardes a todos.': '皆さん、こんにちは。',
      'Buenas noches, que duermas bien.': 'おやすみなさい、よく眠ってください。',
      'Adiós, nos vemos mañana.': 'さようなら、また明日。',
      'Un café, por favor.': 'コーヒーをお願いします。',
    },
    'de': {
      '¡Hola! ¿Cómo estás?': 'Hallo! Wie geht es dir?',
      'Buenos días, señor.': 'Guten Morgen, Mein Herr.',
      'Buenas noches, que duermas bien.': 'Gute Nacht, schlaf gut.',
      'Un café, por favor.': 'Einen Kaffee, bitte.',
    },
  };

  static VocabWord translate(VocabWord word, String targetLang, String uiLocale) {
    String finalWord = word.word;
    String? finalSentence = word.exampleSentence;
    String finalTranslation = word.translation;
    String? finalExampleTranslation = word.exampleTranslation;

    final targetLangCode = targetLang.toLowerCase();
    if (targetLangCode != 'es') {
      final langWords = _targetWordMap[targetLangCode];
      if (langWords != null && langWords.containsKey(word.word)) {
        finalWord = langWords[word.word]!;
      }
      final langSentences = _targetSentenceMap[targetLangCode];
      if (langSentences != null && word.exampleSentence != null && langSentences.containsKey(word.exampleSentence)) {
        finalSentence = langSentences[word.exampleSentence]!;
      }
    }

    if (uiLocale.toLowerCase() == 'ur') {
      if (_englishToUrduWordMap.containsKey(word.translation)) {
        finalTranslation = _englishToUrduWordMap[word.translation]!;
      }
      if (word.exampleTranslation != null && _englishToUrduSentenceMap.containsKey(word.exampleTranslation)) {
        finalExampleTranslation = _englishToUrduSentenceMap[word.exampleTranslation]!;
      }
    }

    return word.copyWith(
      word: finalWord,
      exampleSentence: finalSentence != null ? Value(finalSentence) : const Value.absent(),
      translation: finalTranslation,
      exampleTranslation: finalExampleTranslation != null ? Value(finalExampleTranslation) : const Value.absent(),
    );
  }

  static List<VocabWord> translateList(List<VocabWord> words, String targetLang, String uiLocale) {
    return words.map((w) => translate(w, targetLang, uiLocale)).toList();
  }
}
