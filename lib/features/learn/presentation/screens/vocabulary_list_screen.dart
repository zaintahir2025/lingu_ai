import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/database/database.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_constants.dart';
import '../../../../core/widgets/shared/duolingo_audio_buttons.dart';
import '../../../../core/widgets/shared/duolingo_word_strength_meter.dart';
import '../../../../main.dart';
import '../../data/vocab_translator.dart';
import 'package:lingu_ai/l10n/app_localizations.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/providers/target_language_provider.dart';
import '../../../../core/ads/ad_service.dart';

final vocabularyListProvider = FutureProvider<List<VocabWord>>((ref) async {
  final db = ref.read(databaseProvider);
  final items = await db.select(db.vocabWords).get();
  final targetLang = ref.watch(targetLanguageProvider);
  final uiLocale = ref.read(localeProvider).languageCode;
  return VocabTranslator.translateList(items, targetLang, uiLocale);
});

class VocabularyListScreen extends ConsumerStatefulWidget {
  const VocabularyListScreen({super.key});

  @override
  ConsumerState<VocabularyListScreen> createState() =>
      _VocabularyListScreenState();
}

class _VocabularyListScreenState extends ConsumerState<VocabularyListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vocabAsync = ref.watch(vocabularyListProvider);
    final targetLang = ref.watch(targetLanguageProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.vocabularyList),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryGreen,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primaryGreen,
          tabs: [
            Tab(text: AppLocalizations.of(context)!.allTab),
            Tab(text: AppLocalizations.of(context)!.learningTab),
            Tab(text: AppLocalizations.of(context)!.masteredTab),
          ],
        ),
      ),
      body: vocabAsync.when(
        data: (words) {
          if (words.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.menu_book, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: AppConstants.space16),
                  Text(
                    AppLocalizations.of(context)!.noVocabFound,
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: AppConstants.space8),
                  Text(
                    'Complete lessons to unlock vocabulary.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          return TabBarView(
            controller: _tabController,
            children: [
              _buildList(context, words, targetLang),
              _buildList(context, words.where((w) => w.interval < 21).toList(), targetLang),
              _buildList(
                context,
                words.where((w) => w.interval >= 21).toList(),
                targetLang,
              ),
            ],
          );
        },
        loading: () => ListView.builder(
          padding: const EdgeInsets.all(AppConstants.space16),
          itemCount: 10,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(bottom: AppConstants.space8),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppConstants.radius12),
                ),
              ),
            ),
          ),
        ),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ref.read(adServiceProvider).buildLessonAdBanner(context),
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<VocabWord> words, String targetLang) {
    if (words.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context)!.noWordsCategory));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.space16),
      itemCount: words.length,
      itemBuilder: (context, index) {
        final word = words[index];
        final strengthBars = word.interval >= 21
            ? 4
            : (word.interval >= 10 ? 3 : (word.interval >= 3 ? 2 : 1));

        return Container(
          margin: const EdgeInsets.only(bottom: AppConstants.space12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppConstants.radius16),
            border: Border.all(color: AppColors.divider, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              // Duolingo Dual Audio Control (🔊 Normal + 🐢 Slow)
              DuolingoAudioButtons(
                text: word.word,
                targetLanguage: targetLang,
                size: 44,
              ),
              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      word.word,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      word.translation,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    DuolingoWordStrengthMeter(strength: strengthBars),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
