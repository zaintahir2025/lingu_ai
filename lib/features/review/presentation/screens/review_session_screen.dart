import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_constants.dart';
import '../../../../core/widgets/shared/progress_bar.dart';
import '../../../../core/database/database.dart';
import 'package:drift/drift.dart' hide Column;
import '../../../../core/algorithms/sm2.dart';
import '../../../../core/sync/sync_service.dart';
import '../../../../core/network/connectivity_provider.dart';
import '../../../../core/storage/onboarding_storage.dart';
import '../../../../main.dart';
import '../../../learn/data/vocab_translator.dart';
import '../../../progress/presentation/providers/progress_controller.dart';
import 'package:lingu_ai/l10n/app_localizations.dart';
import '../../domain/review_level_config.dart';
import '../../../../core/local_storage/local_storage_provider.dart';
import '../../../learn/domain/repositories/learn_repository.dart';

class ReviewSessionScreen extends ConsumerStatefulWidget {
  final int level;
  const ReviewSessionScreen({super.key, this.level = 1});

  @override
  ConsumerState<ReviewSessionScreen> createState() =>
      _ReviewSessionScreenState();
}

class _ReviewSessionScreenState extends ConsumerState<ReviewSessionScreen> {
  bool _isFlipped = false;
  List<VocabWord> _queue = [];
  int _currentIndex = 0;
  bool _isLoading = true;
  bool _completionAwarded = false;

  @override
  void initState() {
    super.initState();
    _loadDueItems();
  }

  Future<void> _loadDueItems() async {
    final db = ref.read(databaseProvider);
    await ref.read(learnRepositoryProvider).syncLessonsIfEmpty();
    final now = DateTime.now();
    final targetQuota = reviewWordQuota(widget.level);
    final eligibleLessonCount = reviewEligibleLessonCount(widget.level);

    final box = ref.read(localStorageProvider);
    final draft = box.get('review_draft_level_${widget.level}');
    if (draft is Map) {
      final ids =
          (draft['queueIds'] as List?)
              ?.map((id) => int.tryParse(id.toString()))
              .whereType<int>()
              .toList() ??
          const <int>[];
      final savedIndex = (draft['currentIndex'] as int?) ?? 0;
      if (ids.isNotEmpty && savedIndex >= 0 && savedIndex < ids.length) {
        final restored = await (db.select(
          db.vocabWords,
        )..where((word) => word.id.isIn(ids))).get();
        final byId = {for (final word in restored) word.id: word};
        final ordered = ids
            .map((id) => byId[id])
            .whereType<VocabWord>()
            .toList();
        if (ordered.length == ids.length) {
          await _setTranslatedQueue(ordered, currentIndex: savedIndex);
          return;
        }
      }
    }

    var items =
        await (db.select(db.vocabWords)
              ..where(
                (t) =>
                    t.lessonId.isSmallerOrEqualValue(eligibleLessonCount) &
                    (t.nextReviewDate.isNull() |
                        t.nextReviewDate.isSmallerOrEqualValue(now)),
              )
              ..orderBy([
                (t) => OrderingTerm.asc(t.nextReviewDate),
                (t) => OrderingTerm.asc(t.lessonId),
              ]))
            .get();

    // Fill from the previous-lesson pool so every level has its promised quota.
    if (items.length < targetQuota) {
      final allWords =
          await (db.select(db.vocabWords)
                ..where(
                  (t) => t.lessonId.isSmallerOrEqualValue(eligibleLessonCount),
                )
                ..orderBy([(t) => OrderingTerm.asc(t.lessonId)]))
              .get();
      final existingIds = items.map((e) => e.id).toSet();
      for (final w in allWords) {
        if (!existingIds.contains(w.id)) {
          items.add(w);
          if (items.length >= targetQuota) break;
        }
      }
    }

    if (items.length > targetQuota) {
      items = items.take(targetQuota).toList();
    }

    await _setTranslatedQueue(items);
  }

  Future<void> _setTranslatedQueue(
    List<VocabWord> items, {
    int currentIndex = 0,
  }) async {
    final targetLang =
        ref.read(onboardingStorageProvider).targetLanguage ?? 'es';
    final uiLocale = ref.read(localeProvider).languageCode;
    final translated = VocabTranslator.translateList(
      items,
      targetLang,
      uiLocale,
    );

    if (mounted) {
      setState(() {
        _queue = translated;
        _currentIndex = currentIndex;
        _isLoading = false;
      });
    }
  }

  Future<void> _rateItem(int quality) async {
    final currentWord = _queue[_currentIndex];

    // 1. Calculate new SM-2 values
    final result = calculateSM2(
      quality: quality,
      repetitions: currentWord.repetitions,
      easinessFactor: currentWord.easinessFactor,
      interval: currentWord.interval,
    );

    // 2. Update database
    final db = ref.read(databaseProvider);
    final nextDate = DateTime.now().add(Duration(days: result.interval));

    await (db.update(
      db.vocabWords,
    )..where((t) => t.id.equals(currentWord.id))).write(
      VocabWordsCompanion(
        repetitions: Value(result.repetitions),
        easinessFactor: Value(result.easinessFactor),
        interval: Value(result.interval),
        nextReviewDate: Value<DateTime?>(nextDate),
        status: Value(
          (quality >= 4 || result.repetitions >= 2) ? 'mastered' : 'review',
        ),
      ),
    );

    // Log rating to SyncService
    final isOnline = ref.read(connectivityProvider).value ?? false;
    await ref
        .read(syncServiceProvider)
        .logReview(currentWord.id, quality, isOnline);

    // 3. Queue management
    if (quality < 3) {
      setState(() {
        _queue.add(currentWord);
      });
    }

    _nextCard();
  }

  void _nextCard() {
    setState(() {
      _currentIndex++;
      _isFlipped = false;
    });
    _saveDraft();
  }

  void _saveDraft() {
    ref.read(localStorageProvider).put('review_draft_level_${widget.level}', {
      'currentIndex': _currentIndex,
      'queueIds': _queue.map((word) => word.id).toList(),
    });
  }

  void _clearDraft() {
    ref.read(localStorageProvider).delete('review_draft_level_${widget.level}');
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final completed = _currentIndex >= _queue.length;
    if (completed) {
      if (!_completionAwarded) {
        _completionAwarded = true;
        _clearDraft();
        ref.read(progressControllerProvider.notifier).addXp(5);
      }
      return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.sessionCompleteTitle),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.sessionCompleteHeadline,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: AppConstants.space24),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: Text(AppLocalizations.of(context)!.backToHome),
              ),
            ],
          ),
        ),
      );
    }

    final currentWord = _queue[_currentIndex];
    final progress = _queue.isEmpty ? 0.0 : _currentIndex / _queue.length;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.space16,
                vertical: AppConstants.space24,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    tooltip: 'Close review session',
                    onPressed: () => context.go('/'),
                  ),
                  Expanded(child: ProgressBar(progress: progress)),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.space24),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isFlipped = true;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(
                        AppConstants.radius24,
                      ),
                      border: Border.all(color: AppColors.divider, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          currentWord.word,
                          style: Theme.of(context).textTheme.displayMedium,
                          textAlign: TextAlign.center,
                        ),
                        if (_isFlipped) ...[
                          const SizedBox(height: AppConstants.space32),
                          const Divider(
                            indent: AppConstants.space32,
                            endIndent: AppConstants.space32,
                          ),
                          const SizedBox(height: AppConstants.space32),
                          Text(
                            currentWord.translation,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(color: AppColors.primaryGreen),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (_isFlipped)
              Padding(
                padding: const EdgeInsets.all(AppConstants.space24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _RatingButton(
                      label: AppLocalizations.of(context)!.ratingAgain,
                      subtext: AppLocalizations.of(context)!.ratingSubtextAgain,
                      color: AppColors.softErrorText,
                      onPressed: () => _rateItem(0),
                    ),
                    _RatingButton(
                      label: AppLocalizations.of(context)!.ratingHard,
                      subtext: AppLocalizations.of(context)!.ratingSubtextNext,
                      color: AppColors.streakOrange,
                      onPressed: () => _rateItem(3),
                    ),
                    _RatingButton(
                      label: AppLocalizations.of(context)!.ratingGood,
                      subtext: AppLocalizations.of(context)!.ratingSubtextNext,
                      color: AppColors.primaryGreen,
                      onPressed: () => _rateItem(4),
                    ),
                    _RatingButton(
                      label: AppLocalizations.of(context)!.ratingEasy,
                      subtext: AppLocalizations.of(context)!.ratingSubtextNext,
                      color: Colors.blue,
                      onPressed: () => _rateItem(5),
                    ),
                  ],
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.all(AppConstants.space48),
                child: Text(AppLocalizations.of(context)!.tapToReveal),
              ),
          ],
        ),
      ),
    );
  }
}

class _RatingButton extends StatelessWidget {
  final String label;
  final String subtext;
  final Color color;
  final VoidCallback onPressed;

  const _RatingButton({
    required this.label,
    required this.subtext,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withValues(alpha: 0.1),
        foregroundColor: color,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radius12),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.space16,
          vertical: AppConstants.space12,
        ),
      ),
      onPressed: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtext, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
