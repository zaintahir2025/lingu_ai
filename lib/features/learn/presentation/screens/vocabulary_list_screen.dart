import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/database/database.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_constants.dart';
import 'package:lingu_ai/l10n/app_localizations.dart';
import 'package:shimmer/shimmer.dart';

final vocabularyListProvider = FutureProvider<List<VocabWord>>((ref) async {
  final db = ref.read(databaseProvider);
  return await db.select(db.vocabWords).get();
});

class VocabularyListScreen extends ConsumerStatefulWidget {
  const VocabularyListScreen({super.key});

  @override
  ConsumerState<VocabularyListScreen> createState() => _VocabularyListScreenState();
}

class _VocabularyListScreenState extends ConsumerState<VocabularyListScreen> with SingleTickerProviderStateMixin {
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
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: AppConstants.space8),
                  Text(
                    'Complete lessons to unlock vocabulary.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          return TabBarView(
            controller: _tabController,
            children: [
              _buildList(context, words),
              _buildList(context, words.where((w) => w.interval < 21 && w.repetitions > 0).toList()),
              _buildList(context, words.where((w) => w.interval >= 21).toList()),
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
    );
  }

  Widget _buildList(BuildContext context, List<VocabWord> words) {
    if (words.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context)!.noWordsCategory));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.space16),
      itemCount: words.length,
      itemBuilder: (context, index) {
        final word = words[index];
        final isMastered = word.interval >= 21;
        
        return Card(
          margin: const EdgeInsets.only(bottom: AppConstants.space8),
          child: ListTile(
            title: Text(
              word.word,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(word.translation),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isMastered ? AppColors.primaryGreen.withAlpha(25) : AppColors.streakOrange.withAlpha(25),
                borderRadius: BorderRadius.circular(AppConstants.radius12),
              ),
              child: Text(
                isMastered ? AppLocalizations.of(context)!.masteredTab : AppLocalizations.of(context)!.learningTab,
                style: TextStyle(
                  color: isMastered ? AppColors.primaryGreen : AppColors.streakOrange,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
