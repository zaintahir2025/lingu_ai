import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../../../../core/database/database.dart';

import '../../../../core/storage/onboarding_storage.dart';

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
        
        batch.insertAll(_db.vocabWords, [
          // Lesson 1: Greetings (10 words)
          VocabWordsCompanion.insert(id: const Value(1), lessonId: 1, word: 'Hola', translation: 'Hello'),
          VocabWordsCompanion.insert(id: const Value(2), lessonId: 1, word: 'Buenos días', translation: 'Good morning'),
          VocabWordsCompanion.insert(id: const Value(3), lessonId: 1, word: 'Buenas tardes', translation: 'Good afternoon'),
          VocabWordsCompanion.insert(id: const Value(4), lessonId: 1, word: 'Buenas noches', translation: 'Good night'),
          VocabWordsCompanion.insert(id: const Value(5), lessonId: 1, word: 'Adiós', translation: 'Goodbye'),
          VocabWordsCompanion.insert(id: const Value(6), lessonId: 1, word: 'Hasta luego', translation: 'See you later'),
          VocabWordsCompanion.insert(id: const Value(7), lessonId: 1, word: 'Cómo estás', translation: 'How are you'),
          VocabWordsCompanion.insert(id: const Value(8), lessonId: 1, word: 'Gracias', translation: 'Thank you'),
          VocabWordsCompanion.insert(id: const Value(9), lessonId: 1, word: 'Por favor', translation: 'Please'),
          VocabWordsCompanion.insert(id: const Value(10), lessonId: 1, word: 'De nada', translation: 'You are welcome'),
          VocabWordsCompanion.insert(id: const Value(201), lessonId: 1, word: 'Bien', translation: 'Well / Good'),
          VocabWordsCompanion.insert(id: const Value(202), lessonId: 1, word: 'Mal', translation: 'Bad'),
          VocabWordsCompanion.insert(id: const Value(203), lessonId: 1, word: 'Sí', translation: 'Yes'),
          VocabWordsCompanion.insert(id: const Value(204), lessonId: 1, word: 'No', translation: 'No'),
          VocabWordsCompanion.insert(id: const Value(205), lessonId: 1, word: 'Perdón', translation: 'Sorry'),
          VocabWordsCompanion.insert(id: const Value(206), lessonId: 1, word: 'Disculpe', translation: 'Excuse me'),
          VocabWordsCompanion.insert(id: const Value(207), lessonId: 1, word: 'Bienvenido', translation: 'Welcome'),
          VocabWordsCompanion.insert(id: const Value(208), lessonId: 1, word: 'Muchas gracias', translation: 'Thank you very much'),
          VocabWordsCompanion.insert(id: const Value(209), lessonId: 1, word: 'Hasta mañana', translation: 'See you tomorrow'),
          VocabWordsCompanion.insert(id: const Value(210), lessonId: 1, word: 'Cuídate', translation: 'Take care'),

          // Lesson 2: Introductions (10 words)
          VocabWordsCompanion.insert(id: const Value(11), lessonId: 2, word: 'Cómo te llamas', translation: 'What is your name'),
          VocabWordsCompanion.insert(id: const Value(12), lessonId: 2, word: 'Me llamo', translation: 'My name is'),
          VocabWordsCompanion.insert(id: const Value(13), lessonId: 2, word: 'Mucho gusto', translation: 'Nice to meet you'),
          VocabWordsCompanion.insert(id: const Value(14), lessonId: 2, word: 'De dónde eres', translation: 'Where are you from'),
          VocabWordsCompanion.insert(id: const Value(15), lessonId: 2, word: 'Soy de', translation: 'I am from'),
          VocabWordsCompanion.insert(id: const Value(16), lessonId: 2, word: 'Amigo', translation: 'Friend'),
          VocabWordsCompanion.insert(id: const Value(17), lessonId: 2, word: 'Señor', translation: 'Mister / Sir'),
          VocabWordsCompanion.insert(id: const Value(18), lessonId: 2, word: 'Señora', translation: 'Ma\'am / Madam'),
          VocabWordsCompanion.insert(id: const Value(19), lessonId: 2, word: 'Hablo', translation: 'I speak'),
          VocabWordsCompanion.insert(id: const Value(20), lessonId: 2, word: 'Entiendo', translation: 'I understand'),

          // Lesson 3: Numbers (10 words)
          VocabWordsCompanion.insert(id: const Value(21), lessonId: 3, word: 'Uno', translation: 'One'),
          VocabWordsCompanion.insert(id: const Value(22), lessonId: 3, word: 'Dos', translation: 'Two'),
          VocabWordsCompanion.insert(id: const Value(23), lessonId: 3, word: 'Tres', translation: 'Three'),
          VocabWordsCompanion.insert(id: const Value(24), lessonId: 3, word: 'Cuatro', translation: 'Four'),
          VocabWordsCompanion.insert(id: const Value(25), lessonId: 3, word: 'Cinco', translation: 'Five'),
          VocabWordsCompanion.insert(id: const Value(26), lessonId: 3, word: 'Seis', translation: 'Six'),
          VocabWordsCompanion.insert(id: const Value(27), lessonId: 3, word: 'Siete', translation: 'Seven'),
          VocabWordsCompanion.insert(id: const Value(28), lessonId: 3, word: 'Ocho', translation: 'Eight'),
          VocabWordsCompanion.insert(id: const Value(29), lessonId: 3, word: 'Nueve', translation: 'Nine'),
          VocabWordsCompanion.insert(id: const Value(30), lessonId: 3, word: 'Diez', translation: 'Ten'),

          // Lesson 4: Food & Dining (10 words)
          VocabWordsCompanion.insert(id: const Value(31), lessonId: 4, word: 'Pan', translation: 'Bread'),
          VocabWordsCompanion.insert(id: const Value(32), lessonId: 4, word: 'Agua', translation: 'Water'),
          VocabWordsCompanion.insert(id: const Value(33), lessonId: 4, word: 'Manzana', translation: 'Apple'),
          VocabWordsCompanion.insert(id: const Value(34), lessonId: 4, word: 'Café', translation: 'Coffee'),
          VocabWordsCompanion.insert(id: const Value(35), lessonId: 4, word: 'Leche', translation: 'Milk'),
          VocabWordsCompanion.insert(id: const Value(36), lessonId: 4, word: 'Queso', translation: 'Cheese'),
          VocabWordsCompanion.insert(id: const Value(37), lessonId: 4, word: 'Arroz', translation: 'Rice'),
          VocabWordsCompanion.insert(id: const Value(38), lessonId: 4, word: 'Pollo', translation: 'Chicken'),
          VocabWordsCompanion.insert(id: const Value(39), lessonId: 4, word: 'Restaurante', translation: 'Restaurant'),
          VocabWordsCompanion.insert(id: const Value(40), lessonId: 4, word: 'Comida', translation: 'Food'),

          // Lesson 5: Family (10 words)
          VocabWordsCompanion.insert(id: const Value(41), lessonId: 5, word: 'Madre', translation: 'Mother'),
          VocabWordsCompanion.insert(id: const Value(42), lessonId: 5, word: 'Padre', translation: 'Father'),
          VocabWordsCompanion.insert(id: const Value(43), lessonId: 5, word: 'Hermano', translation: 'Brother'),
          VocabWordsCompanion.insert(id: const Value(44), lessonId: 5, word: 'Hermana', translation: 'Sister'),
          VocabWordsCompanion.insert(id: const Value(45), lessonId: 5, word: 'Hijo', translation: 'Son'),
          VocabWordsCompanion.insert(id: const Value(46), lessonId: 5, word: 'Hija', translation: 'Daughter'),
          VocabWordsCompanion.insert(id: const Value(47), lessonId: 5, word: 'Abuelo', translation: 'Grandfather'),
          VocabWordsCompanion.insert(id: const Value(48), lessonId: 5, word: 'Abuela', translation: 'Grandmother'),
          VocabWordsCompanion.insert(id: const Value(49), lessonId: 5, word: 'Familia', translation: 'Family'),
          VocabWordsCompanion.insert(id: const Value(50), lessonId: 5, word: 'Casa', translation: 'Home'),

          // Lesson 6: Travel (10 words)
          VocabWordsCompanion.insert(id: const Value(51), lessonId: 6, word: 'Aeropuerto', translation: 'Airport'),
          VocabWordsCompanion.insert(id: const Value(52), lessonId: 6, word: 'Hotel', translation: 'Hotel'),
          VocabWordsCompanion.insert(id: const Value(53), lessonId: 6, word: 'Maleta', translation: 'Suitcase'),
          VocabWordsCompanion.insert(id: const Value(54), lessonId: 6, word: 'Viaje', translation: 'Trip'),
          VocabWordsCompanion.insert(id: const Value(55), lessonId: 6, word: 'Boleto', translation: 'Ticket'),
          VocabWordsCompanion.insert(id: const Value(56), lessonId: 6, word: 'Taxi', translation: 'Taxi'),
          VocabWordsCompanion.insert(id: const Value(57), lessonId: 6, word: 'Tren', translation: 'Train'),
          VocabWordsCompanion.insert(id: const Value(58), lessonId: 6, word: 'Estación', translation: 'Station'),
          VocabWordsCompanion.insert(id: const Value(59), lessonId: 6, word: 'Mapa', translation: 'Map'),
          VocabWordsCompanion.insert(id: const Value(60), lessonId: 6, word: 'Pasaporte', translation: 'Passport'),

          // Lesson 7: Shopping (10 words)
          VocabWordsCompanion.insert(id: const Value(61), lessonId: 7, word: 'Camisa', translation: 'Shirt'),
          VocabWordsCompanion.insert(id: const Value(62), lessonId: 7, word: 'Tienda', translation: 'Store'),
          VocabWordsCompanion.insert(id: const Value(63), lessonId: 7, word: 'Descuento', translation: 'Discount'),
          VocabWordsCompanion.insert(id: const Value(64), lessonId: 7, word: 'Cuesta', translation: 'Costs'),
          VocabWordsCompanion.insert(id: const Value(65), lessonId: 7, word: 'Dinero', translation: 'Money'),
          VocabWordsCompanion.insert(id: const Value(66), lessonId: 7, word: 'Tarjeta', translation: 'Card'),
          VocabWordsCompanion.insert(id: const Value(67), lessonId: 7, word: 'Zapatos', translation: 'Shoes'),
          VocabWordsCompanion.insert(id: const Value(68), lessonId: 7, word: 'Precio', translation: 'Price'),
          VocabWordsCompanion.insert(id: const Value(69), lessonId: 7, word: 'Comprar', translation: 'To buy'),
          VocabWordsCompanion.insert(id: const Value(70), lessonId: 7, word: 'Barato', translation: 'Cheap'),

          // Lesson 8: Daily Routine (10 words)
          VocabWordsCompanion.insert(id: const Value(71), lessonId: 8, word: 'Despertar', translation: 'To wake up'),
          VocabWordsCompanion.insert(id: const Value(72), lessonId: 8, word: 'Duchar', translation: 'To shower'),
          VocabWordsCompanion.insert(id: const Value(73), lessonId: 8, word: 'Desayunar', translation: 'To eat breakfast'),
          VocabWordsCompanion.insert(id: const Value(74), lessonId: 8, word: 'Trabajar', translation: 'To work'),
          VocabWordsCompanion.insert(id: const Value(75), lessonId: 8, word: 'Estudiar', translation: 'To study'),
          VocabWordsCompanion.insert(id: const Value(76), lessonId: 8, word: 'Cenar', translation: 'To eat dinner'),
          VocabWordsCompanion.insert(id: const Value(77), lessonId: 8, word: 'Dormir', translation: 'To sleep'),
          VocabWordsCompanion.insert(id: const Value(78), lessonId: 8, word: 'Mañana', translation: 'Morning'),
          VocabWordsCompanion.insert(id: const Value(79), lessonId: 8, word: 'Noche', translation: 'Night'),
          VocabWordsCompanion.insert(id: const Value(80), lessonId: 8, word: 'Tiempo', translation: 'Time'),

          // Lesson 9: Weather (10 words)
          VocabWordsCompanion.insert(id: const Value(81), lessonId: 9, word: 'Sol', translation: 'Sun'),
          VocabWordsCompanion.insert(id: const Value(82), lessonId: 9, word: 'Lluvia', translation: 'Rain'),
          VocabWordsCompanion.insert(id: const Value(83), lessonId: 9, word: 'Viento', translation: 'Wind'),
          VocabWordsCompanion.insert(id: const Value(84), lessonId: 9, word: 'Nieve', translation: 'Snow'),
          VocabWordsCompanion.insert(id: const Value(85), lessonId: 9, word: 'Nube', translation: 'Cloud'),
          VocabWordsCompanion.insert(id: const Value(86), lessonId: 9, word: 'Calor', translation: 'Heat'),
          VocabWordsCompanion.insert(id: const Value(87), lessonId: 9, word: 'Frío', translation: 'Cold'),
          VocabWordsCompanion.insert(id: const Value(88), lessonId: 9, word: 'Verano', translation: 'Summer'),
          VocabWordsCompanion.insert(id: const Value(89), lessonId: 9, word: 'Invierno', translation: 'Winter'),
          VocabWordsCompanion.insert(id: const Value(90), lessonId: 9, word: 'Primavera', translation: 'Spring'),

          // Lesson 10: Home & Living (10 words)
          VocabWordsCompanion.insert(id: const Value(91), lessonId: 10, word: 'Mesa', translation: 'Table'),
          VocabWordsCompanion.insert(id: const Value(92), lessonId: 10, word: 'Silla', translation: 'Chair'),
          VocabWordsCompanion.insert(id: const Value(93), lessonId: 10, word: 'Cama', translation: 'Bed'),
          VocabWordsCompanion.insert(id: const Value(94), lessonId: 10, word: 'Cocina', translation: 'Kitchen'),
          VocabWordsCompanion.insert(id: const Value(95), lessonId: 10, word: 'Baño', translation: 'Bathroom'),
          VocabWordsCompanion.insert(id: const Value(96), lessonId: 10, word: 'Puerta', translation: 'Door'),
          VocabWordsCompanion.insert(id: const Value(97), lessonId: 10, word: 'Ventana', translation: 'Window'),
          VocabWordsCompanion.insert(id: const Value(98), lessonId: 10, word: 'Jardín', translation: 'Garden'),
          VocabWordsCompanion.insert(id: const Value(99), lessonId: 10, word: 'Habitación', translation: 'Room'),
          VocabWordsCompanion.insert(id: const Value(100), lessonId: 10, word: 'Luz', translation: 'Light'),

          // Lesson 11: Work & Office (10 words)
          VocabWordsCompanion.insert(id: const Value(101), lessonId: 11, word: 'Trabajo', translation: 'Work'),
          VocabWordsCompanion.insert(id: const Value(102), lessonId: 11, word: 'Estudiante', translation: 'Student'),
          VocabWordsCompanion.insert(id: const Value(103), lessonId: 11, word: 'Oficina', translation: 'Office'),
          VocabWordsCompanion.insert(id: const Value(104), lessonId: 11, word: 'Universidad', translation: 'University'),
          VocabWordsCompanion.insert(id: const Value(105), lessonId: 11, word: 'Jefe', translation: 'Boss'),
          VocabWordsCompanion.insert(id: const Value(106), lessonId: 11, word: 'Empresa', translation: 'Company'),
          VocabWordsCompanion.insert(id: const Value(107), lessonId: 11, word: 'Proyecto', translation: 'Project'),
          VocabWordsCompanion.insert(id: const Value(108), lessonId: 11, word: 'Reunión', translation: 'Meeting'),
          VocabWordsCompanion.insert(id: const Value(109), lessonId: 11, word: 'Informe', translation: 'Report'),
          VocabWordsCompanion.insert(id: const Value(110), lessonId: 11, word: 'Correo', translation: 'Mail'),

          // Lesson 12: Health & Wellness (10 words)
          VocabWordsCompanion.insert(id: const Value(111), lessonId: 12, word: 'Salud', translation: 'Health'),
          VocabWordsCompanion.insert(id: const Value(112), lessonId: 12, word: 'Médico', translation: 'Doctor'),
          VocabWordsCompanion.insert(id: const Value(113), lessonId: 12, word: 'Ejercicio', translation: 'Exercise'),
          VocabWordsCompanion.insert(id: const Value(114), lessonId: 12, word: 'Corazón', translation: 'Heart'),
          VocabWordsCompanion.insert(id: const Value(115), lessonId: 12, word: 'Hospital', translation: 'Hospital'),
          VocabWordsCompanion.insert(id: const Value(116), lessonId: 12, word: 'Medicina', translation: 'Medicine'),
          VocabWordsCompanion.insert(id: const Value(117), lessonId: 12, word: 'Dolor', translation: 'Pain'),
          VocabWordsCompanion.insert(id: const Value(118), lessonId: 12, word: 'Cuerpo', translation: 'Body'),
          VocabWordsCompanion.insert(id: const Value(119), lessonId: 12, word: 'Cabeza', translation: 'Head'),
          VocabWordsCompanion.insert(id: const Value(120), lessonId: 12, word: 'Fuerza', translation: 'Strength'),

          // Lesson 13: Technology (10 words)
          VocabWordsCompanion.insert(id: const Value(121), lessonId: 13, word: 'Computadora', translation: 'Computer'),
          VocabWordsCompanion.insert(id: const Value(122), lessonId: 13, word: 'Pantalla', translation: 'Screen'),
          VocabWordsCompanion.insert(id: const Value(123), lessonId: 13, word: 'Teléfono', translation: 'Phone'),
          VocabWordsCompanion.insert(id: const Value(124), lessonId: 13, word: 'Mensaje', translation: 'Message'),
          VocabWordsCompanion.insert(id: const Value(125), lessonId: 13, word: 'Internet', translation: 'Internet'),
          VocabWordsCompanion.insert(id: const Value(126), lessonId: 13, word: 'Aplicación', translation: 'Application'),
          VocabWordsCompanion.insert(id: const Value(127), lessonId: 13, word: 'Red', translation: 'Network'),
          VocabWordsCompanion.insert(id: const Value(128), lessonId: 13, word: 'Datos', translation: 'Data'),
          VocabWordsCompanion.insert(id: const Value(129), lessonId: 13, word: 'Archivo', translation: 'File'),
          VocabWordsCompanion.insert(id: const Value(130), lessonId: 13, word: 'Sistema', translation: 'System'),

          // Lesson 14: Culture & Arts (10 words)
          VocabWordsCompanion.insert(id: const Value(131), lessonId: 14, word: 'Cultura', translation: 'Culture'),
          VocabWordsCompanion.insert(id: const Value(132), lessonId: 14, word: 'Música', translation: 'Music'),
          VocabWordsCompanion.insert(id: const Value(133), lessonId: 14, word: 'Arte', translation: 'Art'),
          VocabWordsCompanion.insert(id: const Value(134), lessonId: 14, word: 'Pintura', translation: 'Painting'),
          VocabWordsCompanion.insert(id: const Value(135), lessonId: 14, word: 'Libro', translation: 'Book'),
          VocabWordsCompanion.insert(id: const Value(136), lessonId: 14, word: 'Teatro', translation: 'Theater'),
          VocabWordsCompanion.insert(id: const Value(137), lessonId: 14, word: 'Cine', translation: 'Cinema'),
          VocabWordsCompanion.insert(id: const Value(138), lessonId: 14, word: 'Poesía', translation: 'Poetry'),
          VocabWordsCompanion.insert(id: const Value(139), lessonId: 14, word: 'Danza', translation: 'Dance'),
          VocabWordsCompanion.insert(id: const Value(140), lessonId: 14, word: 'Historia', translation: 'History'),

          // Lesson 15: Emergency & Safety (10 words)
          VocabWordsCompanion.insert(id: const Value(141), lessonId: 15, word: 'Emergencia', translation: 'Emergency'),
          VocabWordsCompanion.insert(id: const Value(142), lessonId: 15, word: 'Ayuda', translation: 'Help'),
          VocabWordsCompanion.insert(id: const Value(143), lessonId: 15, word: 'Peligro', translation: 'Danger'),
          VocabWordsCompanion.insert(id: const Value(144), lessonId: 15, word: 'Fuego', translation: 'Fire'),
          VocabWordsCompanion.insert(id: const Value(145), lessonId: 15, word: 'Policía', translation: 'Police'),
          VocabWordsCompanion.insert(id: const Value(146), lessonId: 15, word: 'Ambulancia', translation: 'Ambulance'),
          VocabWordsCompanion.insert(id: const Value(147), lessonId: 15, word: 'Seguridad', translation: 'Safety'),
          VocabWordsCompanion.insert(id: const Value(148), lessonId: 15, word: 'Urgencia', translation: 'Urgency'),
          VocabWordsCompanion.insert(id: const Value(149), lessonId: 15, word: 'Salida', translation: 'Exit'),
          VocabWordsCompanion.insert(id: const Value(150), lessonId: 15, word: 'Precaución', translation: 'Caution'),
        ]);
      });
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
