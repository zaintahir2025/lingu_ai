import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/repositories/learn_repository.dart';
import 'lesson_node.dart';
import '../../../../core/widgets/mascot/lingu_mascot.dart';
import 'package:shimmer/shimmer.dart';

class LessonPathView extends ConsumerStatefulWidget {
  const LessonPathView({super.key});

  @override
  ConsumerState<LessonPathView> createState() => _LessonPathViewState();
}

class _LessonPathViewState extends ConsumerState<LessonPathView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(learnRepositoryProvider).syncLessonsIfEmpty();
    });
  }

  @override
  Widget build(BuildContext context) {
    final stream = ref.read(learnRepositoryProvider).watchLessons();
    
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            itemCount: 5,
            itemBuilder: (context, index) {
              final alignment = index % 2 == 0 ? AlignmentDirectional.centerStart : AlignmentDirectional.centerEnd;
              final padding = index % 2 == 0 ? const EdgeInsetsDirectional.only(start: 40) : const EdgeInsetsDirectional.only(end: 40);
              return Align(
                alignment: alignment,
                child: Padding(
                  padding: padding.copyWith(bottom: 40),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
        
        final lessons = snapshot.data ?? [];
        if (lessons.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.map_outlined, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  "No lessons available yet.",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Text(
                  "Your learning path will appear here.",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          itemCount: lessons.length,
          itemBuilder: (context, index) {
            final lesson = lessons[index];
            final isCurrent = !lesson.isLocked && !lesson.isCompleted;
            
            final alignment = index % 2 == 0 ? AlignmentDirectional.centerStart : AlignmentDirectional.centerEnd;
            final padding = index % 2 == 0 ? const EdgeInsetsDirectional.only(start: 40) : const EdgeInsetsDirectional.only(end: 40);

            return Align(
              alignment: alignment,
              child: Padding(
                padding: padding.copyWith(bottom: 40),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isCurrent && index % 2 != 0) 
                      const Padding(
                        padding: EdgeInsetsDirectional.only(end: 16.0),
                        child: LinguMascot(size: 80, pose: MascotPose.encouraging),
                      ),
                    LessonNode(
                      lesson: lesson,
                      isCurrent: isCurrent,
                      onTap: () {
                        context.push('/module/${lesson.id}');
                      },
                    ),
                    if (isCurrent && index % 2 == 0) 
                      const Padding(
                        padding: EdgeInsetsDirectional.only(start: 16.0),
                        child: LinguMascot(size: 80, pose: MascotPose.encouraging),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
