import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/native.dart';
import 'package:lingu_ai/core/database/database.dart';
import 'package:lingu_ai/features/progress/presentation/providers/progress_controller.dart';
import 'package:drift/drift.dart' hide isNull;

void main() { TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase db;
  late ProviderContainer container;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
      ],
    );
  });

  tearDown(() async {
    await db.close();
    container.dispose();
  });

  test('calculateLevel returns correct thresholds', () {
    final controller = container.read(progressControllerProvider.notifier);
    expect(controller.calculateLevel(0), 1);
    expect(controller.calculateLevel(49), 1);
    expect(controller.calculateLevel(50), 2);
    expect(controller.calculateLevel(149), 2);
    expect(controller.calculateLevel(150), 3);
    expect(controller.calculateLevel(300), 4);
    expect(controller.calculateLevel(500), 5);
    expect(controller.calculateLevel(1100), 6);
  });

  test('Initial activity starts streak and adds daily bonus', () async {
    final controller = container.read(progressControllerProvider.notifier);
    DateTime mockTime = DateTime(2023, 1, 1, 10, 0); // Day 1
    controller.setClock(() => mockTime);

    // Initial state is loaded
    await container.read(progressControllerProvider.future);

    // Add 10 XP
    await controller.addXp(10);
    
    final state = container.read(progressControllerProvider).value!;
    // 10 base + 5 daily bonus
    expect(state.progress.totalXp, 15);
    expect(state.progress.currentStreak, 1);
    expect(state.addedXp, 15); 
  });

  test('Same day activity does not increase streak but adds XP without daily bonus', () async {
    final controller = container.read(progressControllerProvider.notifier);
    DateTime mockTime = DateTime(2023, 1, 1, 10, 0); // Day 1
    controller.setClock(() => mockTime);

    await container.read(progressControllerProvider.future);
    await controller.addXp(10); // Day 1: +15 total
    
    // Same day later
    mockTime = DateTime(2023, 1, 1, 15, 0);
    await controller.addXp(10); // +10 only

    final state = container.read(progressControllerProvider).value!;
    expect(state.progress.totalXp, 25);
    expect(state.progress.currentStreak, 1);
    expect(state.addedXp, 10); 
  });

  test('Next day activity increases streak and adds daily bonus', () async {
    final controller = container.read(progressControllerProvider.notifier);
    DateTime mockTime = DateTime(2023, 1, 1, 10, 0); // Day 1
    controller.setClock(() => mockTime);

    await container.read(progressControllerProvider.future);
    await controller.addXp(10); // Day 1: +15
    
    // Next day
    mockTime = DateTime(2023, 1, 2, 10, 0); // Day 2
    await controller.addXp(10); // Day 2: +15

    final state = container.read(progressControllerProvider).value!;
    expect(state.progress.totalXp, 30);
    expect(state.progress.currentStreak, 2);
  });

  test('Skipping a day resets streak if no freezes', () async {
    final controller = container.read(progressControllerProvider.notifier);
    DateTime mockTime = DateTime(2023, 1, 1, 10, 0); // Day 1
    controller.setClock(() => mockTime);

    await container.read(progressControllerProvider.future);
    await controller.addXp(10); // Day 1: +15
    
    // Skip to Day 3
    mockTime = DateTime(2023, 1, 3, 10, 0); 
    await controller.addXp(10); // Day 3: +15, but streak resets to 1

    final state = container.read(progressControllerProvider).value!;
    expect(state.progress.totalXp, 30);
    expect(state.progress.currentStreak, 1);
  });

  test('Skipping a day consumes freeze and increases streak', () async {
    // Manually insert a user with 1 freeze
    await db.into(db.userProgress).insert(UserProgressCompanion.insert(
      totalXp: const Value(0),
      level: const Value(1),
      currentStreak: const Value(0),
      streakFreezes: const Value(1), // Give 1 freeze
    ));

    final controller = container.read(progressControllerProvider.notifier);
    DateTime mockTime = DateTime(2023, 1, 1, 10, 0); // Day 1
    controller.setClock(() => mockTime);

    await container.read(progressControllerProvider.future);
    await controller.addXp(10); // Day 1: +15, streak 1
    
    // Skip to Day 3
    mockTime = DateTime(2023, 1, 3, 10, 0); 
    await controller.addXp(10); // Day 3: +15, freeze consumed, streak 2

    final state = container.read(progressControllerProvider).value!;
    expect(state.progress.totalXp, 30);
    expect(state.progress.currentStreak, 2);
    expect(state.progress.streakFreezes, 0);
  });
}
