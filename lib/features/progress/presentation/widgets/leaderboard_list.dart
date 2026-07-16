import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_constants.dart';

class LeaderboardList extends StatefulWidget {
  final int currentXp;

  const LeaderboardList({super.key, required this.currentXp});

  @override
  State<LeaderboardList> createState() => _LeaderboardListState();
}

class _LeaderboardListState extends State<LeaderboardList> {
  final ScrollController _scrollController = ScrollController();
  late List<Map<String, dynamic>> _leaderboard;
  int _myIndex = -1;

  @override
  void initState() {
    super.initState();
    _generateLeaderboard();
    
    // Auto-scroll to current user
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_myIndex != -1 && _scrollController.hasClients) {
        // Calculate offset (rough estimate: 72 pixels per tile)
        final offset = (_myIndex * 72.0) - (150); // Try to center it
        _scrollController.animateTo(
          offset > 0 ? offset : 0,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  void _generateLeaderboard() {
    // Generate mock users
    _leaderboard = [
      {'name': 'Sarah', 'xp': 2450, 'trend': 1},
      {'name': 'John', 'xp': 2100, 'trend': -1},
      {'name': 'Emma', 'xp': 1650, 'trend': 0},
      {'name': 'Mike', 'xp': 1200, 'trend': 1},
      {'name': 'Alex', 'xp': 950, 'trend': -1},
      {'name': 'David', 'xp': 800, 'trend': 1},
      {'name': 'Lisa', 'xp': 650, 'trend': 0},
      {'name': 'Tom', 'xp': 400, 'trend': -1},
      {'name': 'Anna', 'xp': 200, 'trend': 1},
    ];

    // Add current user
    _leaderboard.add({'name': 'You', 'xp': widget.currentXp, 'isMe': true, 'trend': 1});

    // Sort by XP descending
    _leaderboard.sort((a, b) => (b['xp'] as int).compareTo(a['xp'] as int));

    // Find my index
    _myIndex = _leaderboard.indexWhere((user) => user['isMe'] == true);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350, // Fixed height for scrollable area
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radius16),
        border: Border.all(color: AppColors.divider),
      ),
      child: ListView.separated(
        controller: _scrollController,
        itemCount: _leaderboard.length,
        separatorBuilder: (context, index) => const Divider(height: 1, indent: 56),
        itemBuilder: (context, index) {
          final user = _leaderboard[index];
          final isMe = user['isMe'] == true;
          final rank = index + 1;
          final trend = user['trend'] as int;

          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: AppConstants.space16, vertical: 4),
            tileColor: isMe ? AppColors.primaryGreen.withAlpha(25) : null,
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 24,
                  child: Text(
                    rank.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isMe ? AppColors.primaryGreen : Colors.grey.shade600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: isMe ? AppColors.primaryGreen : Colors.grey.shade200,
                  child: Text(
                    user['name'][0],
                    style: TextStyle(
                      color: isMe ? Colors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            title: Text(
              user['name'],
              style: TextStyle(
                fontWeight: isMe ? FontWeight.bold : FontWeight.w500,
                color: isMe ? AppColors.primaryGreen : AppColors.textPrimary,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${user['xp']} XP',
                  style: const TextStyle(
                    color: AppColors.xpGold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  trend > 0 ? Icons.arrow_drop_up : (trend < 0 ? Icons.arrow_drop_down : Icons.remove),
                  color: trend > 0 ? AppColors.primaryGreen : (trend < 0 ? AppColors.softErrorText : Colors.grey),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
