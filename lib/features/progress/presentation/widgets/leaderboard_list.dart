import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  final Dio _dio = Dio();
  final _storage = const FlutterSecureStorage();
  
  List<Map<String, dynamic>> _leaderboard = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLeaderboard();
  }

  Future<void> _fetchLeaderboard() async {
    try {
      final token = await _storage.read(key: 'jwt');
      // Assume Node.js backend handles this at /api/leaderboard
      final response = await _dio.get(
        'http://10.0.2.2:3000/api/leaderboard',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      
      final data = response.data['leaderboard'] as List;
      
      setState(() {
        _leaderboard = data.map((e) => e as Map<String, dynamic>).toList();
        _isLoading = false;
      });

      _scrollToMe();
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          
          // MOCK DATA since backend route is not ready yet:
          _leaderboard = [
            {'id': '1', 'name': 'Ahmed', 'xp': 1500, 'trend': 1, 'isMe': false},
            {'id': '2', 'name': 'Sara', 'xp': 1200, 'trend': -1, 'isMe': false},
            {'id': 'me', 'name': 'You', 'xp': widget.currentXp, 'trend': 0, 'isMe': true},
          ];
        });
      }
      _scrollToMe();
    }
  }

  void _scrollToMe() {
    int myIndex = _leaderboard.indexWhere((user) => user['isMe'] == true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (myIndex != -1 && _scrollController.hasClients && _scrollController.position.pixels == 0) {
        final offset = (myIndex * 72.0) - (150);
        _scrollController.animateTo(
          offset > 0 ? offset : 0,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radius16),
        border: Border.all(color: AppColors.divider),
      ),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
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
                          (user['name'] as String).isNotEmpty ? (user['name'] as String)[0].toUpperCase() : 'U',
                          style: TextStyle(
                            color: isMe ? Colors.white : AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  title: Text(
                    isMe ? 'You' : user['name'],
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
