import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/widgets.dart';
import '../../../shared/models/models.dart';
import '../../../shared/providers/providers.dart';

class _ShellTab {
  const _ShellTab({
    required this.branchIndex,
    required this.icon,
    required this.label,
  });

  final int branchIndex;
  final IconData icon;
  final String label;
}

// Branch order in app_router.dart:
// 0 home · 1 discover · 2 castings · 3 dashboard · 4 search · 5 post-casting
// 6 messages · 7 profile.
List<_ShellTab> get _talentTabs => [
      _ShellTab(branchIndex: 0, icon: Iconsax.home_2, label: AppStrings.navHome),
      _ShellTab(branchIndex: 1, icon: Iconsax.discover, label: AppStrings.navDiscover),
      _ShellTab(branchIndex: 2, icon: Iconsax.briefcase, label: AppStrings.navCastings),
      _ShellTab(branchIndex: 6, icon: Iconsax.message, label: AppStrings.navMessages),
      _ShellTab(branchIndex: 7, icon: Iconsax.user, label: AppStrings.navProfile),
    ];

List<_ShellTab> get _recruiterTabs => [
      _ShellTab(branchIndex: 3, icon: Iconsax.home_2, label: AppStrings.navDashboard),
      _ShellTab(branchIndex: 4, icon: Iconsax.search_normal, label: AppStrings.navTalent),
      _ShellTab(branchIndex: 5, icon: Iconsax.add_circle, label: AppStrings.navPost),
      _ShellTab(branchIndex: 6, icon: Iconsax.message, label: AppStrings.navMessages),
      _ShellTab(branchIndex: 7, icon: Iconsax.user, label: AppStrings.navProfile),
    ];

List<_ShellTab> get _adminTabs => [
      _ShellTab(branchIndex: 0, icon: Iconsax.chart_2, label: AppStrings.navOverview),
      _ShellTab(branchIndex: 1, icon: Iconsax.people, label: AppStrings.navUsers),
      _ShellTab(branchIndex: 2, icon: Iconsax.briefcase, label: AppStrings.navCastings),
      _ShellTab(branchIndex: 6, icon: Iconsax.message, label: AppStrings.navMessages),
      _ShellTab(branchIndex: 7, icon: Iconsax.user, label: AppStrings.navProfile),
    ];

List<_ShellTab> get _guestTabs => [
      _ShellTab(branchIndex: 0, icon: Iconsax.home_2, label: AppStrings.navHome),
      _ShellTab(branchIndex: 1, icon: Iconsax.discover, label: AppStrings.navDiscover),
      _ShellTab(branchIndex: 2, icon: Iconsax.briefcase, label: AppStrings.navCastings),
      _ShellTab(branchIndex: 7, icon: Iconsax.user, label: AppStrings.navProfile),
    ];

List<_ShellTab> _tabsFor(UserRole? role) {
  switch (role) {
    case UserRole.recruiter:
      return _recruiterTabs;
    case UserRole.admin:
      return _adminTabs;
    case UserRole.guest:
      return _guestTabs;
    case UserRole.talent:
    case null:
      return _talentTabs;
  }
}

class ShellScreen extends ConsumerWidget {
  const ShellScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final role = auth.isGuest ? UserRole.guest : auth.user?.role;
    final tabs = _tabsFor(role);

    final userId = auth.user?.id;
    final unread = userId == null ? 0 : ref.watch(totalUnreadMessagesProvider(userId));

    var visibleIndex = tabs.indexWhere((t) => t.branchIndex == navigationShell.currentIndex);
    if (visibleIndex < 0) visibleIndex = 0;

    return Scaffold(
      extendBody: false,
      backgroundColor: AppColors.background,
      body: navigationShell,
      bottomNavigationBar: _KrBottomNav(
        tabs: tabs,
        currentIndex: visibleIndex,
        unreadMessages: unread,
        onTap: (index) {
          final branchIndex = tabs[index].branchIndex;
          navigationShell.goBranch(
            branchIndex,
            initialLocation: branchIndex == navigationShell.currentIndex,
          );
        },
      ),
    );
  }
}

class _KrBottomNav extends StatelessWidget {
  const _KrBottomNav({
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
    this.unreadMessages = 0,
  });

  final List<_ShellTab> tabs;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final int unreadMessages;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(top: BorderSide(color: AppColors.border)),
        boxShadow: AppShadows.bottomSheet,
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 62,
          child: Row(
            children: List.generate(tabs.length, (index) {
              final tab = tabs[index];
              final selected = index == currentIndex;
              final showBadge = tab.branchIndex == 6 && unreadMessages > 0;
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTap(index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.gold.withValues(alpha: 0.14)
                                  : Colors.transparent,
                              borderRadius: AppRadius.radiusFull,
                            ),
                            child: Icon(
                              tab.icon,
                              size: 22,
                              color: selected ? AppColors.gold : AppColors.textMuted,
                            ),
                          ),
                          if (showBadge)
                            Positioned(
                              top: -2,
                              right: 2,
                              child: CountBadge(count: unreadMessages, size: 16),
                            ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        tab.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: selected ? AppColors.gold : AppColors.textMuted,
                          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                          fontSize: 10,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
