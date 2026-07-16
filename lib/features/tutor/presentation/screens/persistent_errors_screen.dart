import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/database/database.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_constants.dart';
import '../../../home/presentation/home_screen.dart';
import '../providers/tutor_controller.dart';

final persistentErrorsProvider = FutureProvider<List<VocabWord>>((ref) async {
  final db = ref.read(databaseProvider);
  return await db.getRecentMistakes(limit: 10);
});

class PersistentErrorsScreen extends ConsumerWidget {
  const PersistentErrorsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final errorsAsync = ref.watch(persistentErrorsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Persistent Errors'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: errorsAsync.when(
        data: (errors) {
          if (errors.isEmpty) {
            return const Center(
              child: Text(
                'Great job! You have no persistent errors.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(AppConstants.space16),
            itemCount: errors.length,
            itemBuilder: (context, index) {
              final word = errors[index];
              return Card(
                margin: const EdgeInsets.only(bottom: AppConstants.space8),
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.space16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              word.word,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            const SizedBox(height: 4),
                            Text(word.translation),
                            const SizedBox(height: 4),
                            Text(
                              'Easiness: ${word.easinessFactor.toStringAsFixed(2)}',
                              style: const TextStyle(color: AppColors.softErrorText, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.chat_bubble_outline),
                        label: const Text('Discuss'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          // Send prompt to tutor and navigate to tutor tab
                          final prompt = 'Can you explain why I keep struggling with the word "${word.word}" (${word.translation})? Break it down for me.';
                          ref.read(tutorControllerProvider.notifier).sendMessage(prompt);
                          
                          // Set home tab to Tutor (index 2)
                          ref.read(homeTabProvider.notifier).state = 2;
                          // Go back to home
                          context.go('/');
                        },
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
