import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/shared/premium_badge.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../data/admin_repository.dart';

class AdminPanelScreen extends ConsumerStatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  ConsumerState<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends ConsumerState<AdminPanelScreen> {
  late Future<AdminDashboardData> _dashboard;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _dashboard = ref.read(adminRepositoryProvider).loadDashboard();
  }

  void _refresh() => setState(_reload);

  Future<void> _reply(AdminSupportTicket ticket) async {
    final controller = TextEditingController(text: ticket.reply);
    final reply = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reply to ${ticket.userEmail}'),
        content: TextField(
          controller: controller,
          minLines: 4,
          maxLines: 8,
          maxLength: 5000,
          decoration: const InputDecoration(
            labelText: 'Official response',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final value = controller.text.trim();
              if (value.length >= 2) Navigator.pop(context, value);
            },
            child: const Text('Send reply'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (reply == null || !mounted) return;
    try {
      await ref.read(adminRepositoryProvider).replyToTicket(ticket.id, reply);
      _refresh();
    } catch (error) {
      if (mounted) _showError(error);
    }
  }

  Future<void> _delete(AdminSupportTicket ticket) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete support ticket?'),
        content: Text('This permanently deletes “${ticket.subject}”.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      await ref.read(adminRepositoryProvider).deleteTicket(ticket.id);
      _refresh();
    } catch (error) {
      if (mounted) _showError(error);
    }
  }

  Future<void> _setUserDisabled(AdminUser user, bool disabled) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(disabled ? 'Suspend account?' : 'Restore account?'),
        content: Text(
          disabled
              ? '${user.email} will be signed out and blocked from using the app.'
              : '${user.email} will be able to sign in again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(disabled ? 'Suspend' : 'Restore'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      await ref
          .read(adminRepositoryProvider)
          .setUserDisabled(user.id, disabled);
      _refresh();
    } catch (error) {
      if (mounted) _showError(error);
    }
  }

  Future<void> _deleteUser(AdminUser user) async {
    final controller = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permanently delete account?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This deletes the account and all associated progress, subscriptions, tokens, and support records. This cannot be undone.',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Type ${user.email} to confirm',
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(
              context,
              controller.text.trim().toLowerCase() == user.email.toLowerCase(),
            ),
            child: const Text('Delete permanently'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (confirmed != true || !mounted) return;
    try {
      await ref.read(adminRepositoryProvider).deleteUser(user.id, user.email);
      _refresh();
    } catch (error) {
      if (mounted) _showError(error);
    }
  }

  void _showError(Object error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error.toString().replaceFirst('Exception: ', ''))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('System administration'),
        actions: [
          IconButton(
            onPressed: _refresh,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: FutureBuilder<AdminDashboardData>(
        future: _dashboard,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.cloud_off_rounded,
                      size: 48,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      snapshot.error.toString().replaceFirst('Exception: ', ''),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: _refresh,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }
          final data = snapshot.requireData;
          return RefreshIndicator(
            onRefresh: () async {
              _refresh();
              await _dashboard;
            },
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _summary(data),
                if (data.system.testingAdminAccess) ...[
                  const SizedBox(height: 12),
                  Card(
                    color: Colors.amber.shade50,
                    child: const ListTile(
                      leading: Icon(
                        Icons.science_rounded,
                        color: Colors.orange,
                      ),
                      title: Text('Testing admin access is enabled'),
                      subtitle: Text(
                        'Every authenticated account can use this panel. Disable TESTING_ADMIN_ACCESS before launch.',
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                Text(
                  'Registered accounts',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                if (data.users.isEmpty)
                  const _EmptyCard(message: 'No registered accounts exist.')
                else
                  ...data.users.map(_userCard),
                const SizedBox(height: 24),
                Text(
                  'Support queue',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                if (data.tickets.isEmpty)
                  const _EmptyCard(
                    message: 'No support tickets have been submitted.',
                  )
                else
                  ...data.tickets.map(_ticketCard),
                const SizedBox(height: 24),
                Text(
                  'System integrations',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _systemCard(data.system),
                const SizedBox(height: 24),
                Text(
                  'Recent audit activity',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                if (data.auditEvents.isEmpty)
                  const _EmptyCard(
                    message: 'No administrative actions recorded yet.',
                  )
                else
                  ...data.auditEvents.take(10).map(_auditCard),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _summary(AdminDashboardData data) {
    final premium = data.users.where((user) => user.premium).length;
    final open = data.tickets.where((ticket) => ticket.status == 'open').length;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryGreen, AppColors.primaryGreenDark],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Wrap(
        spacing: 28,
        runSpacing: 12,
        children: [
          _metric(Icons.people_alt_rounded, '${data.users.length}', 'accounts'),
          _metric(Icons.workspace_premium_rounded, '$premium', 'premium'),
          _metric(Icons.support_agent_rounded, '$open', 'open tickets'),
        ],
      ),
    );
  }

  Widget _metric(IconData icon, String value, String label) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, color: Colors.white),
      const SizedBox(width: 8),
      Text(
        '$value $label',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );

  Widget _userCard(AdminUser user) => Card(
    child: ListTile(
      leading: CircleAvatar(
        child: Text(
          (user.username?.isNotEmpty == true
                  ? user.username![0]
                  : user.email[0])
              .toUpperCase(),
        ),
      ),
      title: Row(
        children: [
          Flexible(child: Text(user.username ?? user.email.split('@').first)),
          if (user.premium) ...[const SizedBox(width: 8), const PremiumBadge()],
        ],
      ),
      subtitle: Text(
        '${user.email}\nCreated ${_date(user.createdAt)} • ${user.isEmailVerified ? "Verified" : "Unverified"} • ${user.role} • ${user.isDisabled ? "Suspended" : "Active"}',
      ),
      isThreeLine: true,
      trailing: _userActions(user),
    ),
  );

  Widget _userActions(AdminUser user) {
    final currentId = ref.read(authControllerProvider).user?.id;
    return PopupMenuButton<String>(
      tooltip: 'Account actions',
      onSelected: (action) {
        if (action == 'status') {
          _setUserDisabled(user, !user.isDisabled);
        } else if (action == 'premium') {
          _toggleUserPremium(user, !user.premium);
        } else if (action == 'delete') {
          _deleteUser(user);
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'premium',
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              user.premium
                  ? Icons.workspace_premium_outlined
                  : Icons.workspace_premium,
              color: user.premium ? Colors.orange : AppColors.primaryGreen,
            ),
            title: Text(
              user.premium ? 'Remove Premium' : 'Grant Premium',
            ),
          ),
        ),
        PopupMenuItem(
          value: 'status',
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(user.isDisabled ? Icons.lock_open : Icons.block),
            title: Text(
              user.isDisabled ? 'Restore account' : 'Suspend account',
            ),
          ),
        ),
        if (currentId != user.id)
          const PopupMenuItem(
            value: 'delete',
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.delete_forever, color: Colors.red),
              title: Text('Delete account', style: TextStyle(color: Colors.red)),
            ),
          ),
      ],
    );
  }

  Future<void> _toggleUserPremium(AdminUser user, bool grant) async {
    try {
      await ref.read(adminRepositoryProvider).setUserPremium(user.id, grant);
      final currentId = ref.read(authControllerProvider).user?.id;
      if (currentId == user.id || currentId == null) {
        await ref.read(premiumStorageProvider.notifier).setPremium(grant);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              grant
                  ? 'Granted Premium membership to ${user.email}'
                  : 'Removed Premium membership from ${user.email}',
            ),
            backgroundColor: grant ? AppColors.primaryGreen : Colors.orange,
          ),
        );
        _refresh();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _systemCard(AdminSystemStatus system) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Environment: ${system.environment}'),
          Text('Recorded admin actions: ${system.auditEvents}'),
          const Divider(height: 24),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: system.integrations.entries
                .map(
                  (entry) => Chip(
                    avatar: Icon(
                      entry.value ? Icons.check_circle : Icons.error_outline,
                      color: entry.value ? Colors.green : Colors.orange,
                      size: 18,
                    ),
                    label: Text(
                      '${entry.key.toUpperCase()}: ${entry.value ? "configured" : "missing configuration"}',
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    ),
  );

  Widget _auditCard(AdminAuditEvent event) => Card(
    child: ListTile(
      leading: const Icon(Icons.history_rounded),
      title: Text(event.action),
      subtitle: Text('${event.actorEmail} • ${event.targetType}'),
      trailing: Text(_date(event.createdAt)),
    ),
  );

  Widget _ticketCard(AdminSupportTicket ticket) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (ticket.priority == 'priority') ...[
                const PremiumBadge(),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  '[${ticket.category}] ${ticket.subject}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                _date(ticket.createdAt),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${ticket.username ?? 'Learner'} • ${ticket.userEmail}',
            style: const TextStyle(color: AppColors.primaryGreenDark),
          ),
          const SizedBox(height: 10),
          Text(ticket.message),
          if (ticket.reply != null) ...[
            const Divider(height: 24),
            Text(
              'Reply: ${ticket.reply}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () => _reply(ticket),
                icon: const Icon(Icons.reply),
                label: Text(ticket.reply == null ? 'Reply' : 'Edit reply'),
              ),
              IconButton(
                onPressed: () => _delete(ticket),
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                tooltip: 'Delete',
              ),
            ],
          ),
        ],
      ),
    ),
  );

  String _date(DateTime value) =>
      '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Center(child: Text(message)),
    ),
  );
}
