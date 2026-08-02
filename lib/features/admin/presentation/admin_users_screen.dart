import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/l10n/display_localizer.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/widgets/widgets.dart';
import '../../../shared/models/models.dart';
import '../../../shared/providers/providers.dart';

/// Bundles a base [UserModel] account together with whichever role-specific
/// profile (talent or recruiter) it's linked to, so the admin list can
/// render one unified row regardless of account type.
class _AdminUserRow {
  const _AdminUserRow({required this.user, this.talent, this.recruiter});

  final UserModel user;
  final TalentModel? talent;
  final RecruiterModel? recruiter;

  String get displayName {
    if (talent != null) return talent!.fullName;
    if (recruiter != null) {
      return recruiter!.fullName.isNotEmpty ? recruiter!.fullName : recruiter!.companyName;
    }
    return user.fullName;
  }

  String? get avatarUrl {
    if (talent != null && talent!.headshotUrl.isNotEmpty) return talent!.headshotUrl;
    if (recruiter != null && recruiter!.avatarUrl.isNotEmpty) return recruiter!.avatarUrl;
    return user.avatarUrl;
  }

  String get subtitle {
    if (talent != null) return '${talent!.category.label} · ${DisplayLocalizer.t(talent!.city)}';
    if (recruiter != null) return '${recruiter!.companyType.label} · ${DisplayLocalizer.t(recruiter!.city)}';
    return user.email;
  }
}

/// Full admin user-management console: Talents / Recruiters / All Users
/// tabs, live search, and verify / ban / edit / delete actions wired
/// straight into [userProvider] (plus the linked talent/recruiter record).
class AdminUsersScreen extends ConsumerStatefulWidget {
  const AdminUsersScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  ConsumerState<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends ConsumerState<AdminUsersScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(length: 3, vsync: this);
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<_AdminUserRow> _rowsFor(UserRole? role) {
    final users = ref.watch(userProvider);
    final talents = ref.watch(talentProvider);
    final recruiters = ref.watch(recruiterProvider);

    var filtered = role == null ? users : users.where((u) => u.role == role).toList();
    if (_query.trim().isNotEmpty) {
      final q = _query.trim().toLowerCase();
      filtered = filtered.where((u) {
        final talent = talents.firstWhereOrNull((t) => t.userId == u.id);
        final recruiter = recruiters.firstWhereOrNull((r) => r.userId == u.id);
        final name = talent?.fullName ?? recruiter?.fullName ?? u.fullName;
        return name.toLowerCase().contains(q) ||
            u.email.toLowerCase().contains(q) ||
            (recruiter?.companyName.toLowerCase().contains(q) ?? false);
      }).toList();
    }

    final rows = filtered.map((u) {
      return _AdminUserRow(
        user: u,
        talent: talents.firstWhereOrNull((t) => t.userId == u.id),
        recruiter: recruiters.firstWhereOrNull((r) => r.userId == u.id),
      );
    }).toList();
    rows.sort((a, b) => a.displayName.compareTo(b.displayName));
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: AppStrings.manageUsers,
        showBackButton: !widget.embedded,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: AppStrings.talents),
            Tab(text: AppStrings.recruiters),
            Tab(text: AppStrings.allUsers),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.sm),
            child: KrSearchBar(
              controller: _searchController,
              hintText: AppStrings.searchUsersHint,
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _UserListView(rows: _rowsFor(UserRole.talent)),
                _UserListView(rows: _rowsFor(UserRole.recruiter)),
                _UserListView(rows: _rowsFor(null)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UserListView extends ConsumerWidget {
  const _UserListView({required this.rows});

  final List<_AdminUserRow> rows;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (rows.isEmpty) {
      return Center(
        child: EmptyState(
          icon: Iconsax.profile_2user,
          title: AppStrings.noUsersFound,
          subtitle: AppStrings.noUsersFoundSubtitle,
          compact: true,
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xxxl),
      itemCount: rows.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final row = rows[index];
        return _UserRowCard(row: row).animate().fadeIn(delay: (25 * (index % 12)).ms, duration: 260.ms);
      },
    );
  }
}

class _UserRowCard extends ConsumerWidget {
  const _UserRowCard({required this.row});

  final _AdminUserRow row;

  Future<void> _handleAction(BuildContext context, WidgetRef ref, String action) async {
    final user = row.user;
    switch (action) {
      case 'view':
        _showDetails(context);
        break;
      case 'verify':
        final newValue = !user.isVerified;
        ref.read(userProvider.notifier).setVerified(user.id, newValue);
        if (row.talent != null) {
          ref.read(talentProvider.notifier).update(row.talent!.copyWith(isVerified: newValue));
        }
        if (row.recruiter != null) {
          ref.read(recruiterProvider.notifier).update(row.recruiter!.copyWith(isVerified: newValue));
        }
        context.showSnack(
          newValue
              ? AppStrings.isNowVerified(row.displayName)
              : AppStrings.isNowUnverified(row.displayName),
        );
        break;
      case 'ban':
        final banning = user.status != UserStatus.banned;
        if (banning) {
          final confirmed = await ConfirmationSheet.show(
            context,
            title: AppStrings.banNamed(row.displayName),
            body: AppStrings.confirmBanBody,
            icon: Iconsax.shield_cross,
            confirmLabel: AppStrings.banUser,
          );
          if (!confirmed) return;
          ref.read(userProvider.notifier).ban(user.id);
          if (row.talent != null) {
            ref.read(talentProvider.notifier).update(row.talent!.copyWith(isArchived: true));
          }
          if (context.mounted) context.showSnack(AppStrings.hasBeenBanned(row.displayName), isError: true);
        } else {
          ref.read(userProvider.notifier).unban(user.id);
          if (row.talent != null) {
            ref.read(talentProvider.notifier).update(row.talent!.copyWith(isArchived: false));
          }
          if (context.mounted) context.showSnack(AppStrings.hasBeenUnbanned(row.displayName));
        }
        break;
      case 'edit':
        _showEditDialog(context, ref);
        break;
      case 'delete':
        final confirmed = await ConfirmationSheet.show(
          context,
          title: AppStrings.deleteNamed(row.displayName),
          body: AppStrings.deleteUserBody,
        );
        if (!confirmed) return;
        ref.read(userProvider.notifier).delete(user.id);
        if (row.talent != null) ref.read(talentProvider.notifier).delete(row.talent!.id);
        if (row.recruiter != null) ref.read(recruiterProvider.notifier).delete(row.recruiter!.id);
        if (context.mounted) context.showSnack(AppStrings.wasDeleted(row.displayName), isError: true);
        break;
    }
  }

  void _showDetails(BuildContext context) {
    showKrBottomSheet(
      context,
      builder: (context) => _UserDetailsSheet(row: row),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (context) => _EditUserDialog(row: row),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = row.user;
    final banned = user.status == UserStatus.banned;

    return AnimatedCard(
      onTap: () => _showDetails(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          KrAvatar(
            imageUrl: row.avatarUrl,
            initials: row.displayName.initials,
            verified: user.isVerified,
            online: user.isOnline,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  row.displayName,
                  style: AppTextStyles.cardTitle.copyWith(fontSize: 15),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(row.subtitle, style: AppTextStyles.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    StatusBadge.gold(user.role.label),
                    _statusBadge(user.status),
                    if (user.isVerified) VerifiedBadge(label: AppStrings.talentVerified, compact: true),
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (action) => _handleAction(context, ref, action),
            itemBuilder: (context) => [
              PopupMenuItem(value: 'view', child: _MenuRow(icon: Iconsax.eye, label: AppStrings.view)),
              PopupMenuItem(
                value: 'verify',
                child: _MenuRow(
                  icon: user.isVerified ? Iconsax.shield_cross : Iconsax.shield_tick,
                  label: user.isVerified ? AppStrings.unverify : AppStrings.verify,
                ),
              ),
              PopupMenuItem(value: 'edit', child: _MenuRow(icon: Iconsax.edit_2, label: AppStrings.edit)),
              PopupMenuItem(
                value: 'ban',
                child: _MenuRow(
                  icon: banned ? Iconsax.shield_tick : Iconsax.shield_cross,
                  label: banned ? AppStrings.unban : AppStrings.ban,
                  color: banned ? AppColors.success : AppColors.error,
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: _MenuRow(icon: Iconsax.trash, label: AppStrings.delete, color: AppColors.error),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(UserStatus status) {
    switch (status) {
      case UserStatus.active:
        return StatusBadge.success(status.label);
      case UserStatus.banned:
        return StatusBadge.error(status.label);
      case UserStatus.suspended:
        return StatusBadge.warning(status.label);
      case UserStatus.pendingVerification:
        return StatusBadge.info(status.label);
    }
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({required this.icon, required this.label, this.color});

  final IconData icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.textPrimary;
    return Row(
      children: [
        Icon(icon, size: 17, color: c),
        const SizedBox(width: AppSpacing.sm),
        Text(label, style: AppTextStyles.body.copyWith(fontSize: 14, color: c)),
      ],
    );
  }
}

class _UserDetailsSheet extends StatelessWidget {
  const _UserDetailsSheet({required this.row});

  final _AdminUserRow row;

  @override
  Widget build(BuildContext context) {
    final user = row.user;
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.md, AppSpacing.xl, AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: KrAvatar(
              imageUrl: row.avatarUrl,
              initials: row.displayName.initials,
              size: KrAvatarSize.xl,
              verified: user.isVerified,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Center(
            child: Text(row.displayName, style: AppTextStyles.sectionTitle.copyWith(fontSize: 22)),
          ),
          const SizedBox(height: 4),
          Center(child: Text(user.email, style: AppTextStyles.bodyMuted)),
          const SizedBox(height: AppSpacing.lg),
          _DetailRow(label: AppStrings.role, value: user.role.label),
          _DetailRow(label: AppStrings.status, value: user.status.label),
          _DetailRow(label: AppStrings.phone, value: user.phone.orPlaceholder('—')),
          _DetailRow(label: AppStrings.joined, value: user.createdAt.formattedDate),
          _DetailRow(label: AppStrings.lastSeen, value: user.lastSeen.timeAgo),
          if (row.talent != null) ...[
            _DetailRow(label: AppStrings.category, value: row.talent!.category.label),
            _DetailRow(label: AppStrings.city, value: DisplayLocalizer.t(row.talent!.city)),
            _DetailRow(label: AppStrings.rating, value: row.talent!.rating.toStringAsFixed(1)),
          ],
          if (row.recruiter != null) ...[
            _DetailRow(label: AppStrings.company, value: row.recruiter!.companyName),
            _DetailRow(label: AppStrings.city, value: DisplayLocalizer.t(row.recruiter!.city)),
            _DetailRow(label: AppStrings.castingsPosted, value: '${row.recruiter!.castingCount}'),
          ],
          const SizedBox(height: AppSpacing.lg),
          PremiumButton.ghost(label: AppStrings.close, fullWidth: true, onPressed: () => Navigator.of(context).pop()),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text(label, style: AppTextStyles.bodySmall)),
          Expanded(
            child: Text(value, style: AppTextStyles.body.copyWith(fontSize: 14), textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }
}

class _EditUserDialog extends ConsumerStatefulWidget {
  const _EditUserDialog({required this.row});

  final _AdminUserRow row;

  @override
  ConsumerState<_EditUserDialog> createState() => _EditUserDialogState();
}

class _EditUserDialogState extends ConsumerState<_EditUserDialog> {
  late final _firstNameController = TextEditingController(text: widget.row.user.firstName);
  late final _lastNameController = TextEditingController(text: widget.row.user.lastName);
  late UserStatus _status = widget.row.user.status;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _save() {
    final user = widget.row.user;
    final updated = user.copyWith(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      status: _status,
    );
    ref.read(userProvider.notifier).update(updated);

    if (widget.row.talent != null) {
      ref.read(talentProvider.notifier).update(widget.row.talent!.copyWith(
            firstName: updated.firstName,
            lastName: updated.lastName,
          ));
    }
    if (widget.row.recruiter != null) {
      ref.read(recruiterProvider.notifier).update(widget.row.recruiter!.copyWith(
            firstName: updated.firstName,
            lastName: updated.lastName,
          ));
    }

    Navigator.of(context).pop();
    context.showSnack(AppStrings.profileUpdatedShort);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppStrings.editUser),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _firstNameController,
              style: AppTextStyles.input,
              decoration: InputDecoration(labelText: AppStrings.firstName),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _lastNameController,
              style: AppTextStyles.input,
              decoration: InputDecoration(labelText: AppStrings.lastName),
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<UserStatus>(
              value: _status,
              dropdownColor: AppColors.cardElevated,
              decoration: InputDecoration(labelText: AppStrings.status),
              items: UserStatus.values
                  .map((s) => DropdownMenuItem(value: s, child: Text(s.label)))
                  .toList(),
              onChanged: (v) {
                if (v != null) setState(() => _status = v);
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(AppStrings.cancel)),
        ElevatedButton(onPressed: _save, child: Text(AppStrings.save)),
      ],
    );
  }
}
