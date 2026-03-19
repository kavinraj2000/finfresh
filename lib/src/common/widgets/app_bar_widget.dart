import 'package:finfresh/app/route_name.dart';
import 'package:finfresh/src/auth/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showLogout;

  const CommonAppBar({super.key, required this.title, this.showLogout = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentLocation = GoRouterState.of(context).uri.toString();
    final isDashboard =
        currentLocation == RouteName.dashboard; // adjust to your route name

    return AppBar(
      backgroundColor: theme.colorScheme.surface,
      elevation: 0,
      title: Row(
        children: [
          Icon(
            Icons.account_balance_wallet_rounded,
            color: theme.colorScheme.primary,
            size: 22,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
            isDashboard ? Icons.receipt_long_rounded : Icons.dashboard_rounded,
          ),
          tooltip: isDashboard ? 'Transactions' : 'Dashboard',
          onPressed: () {
            if (isDashboard) {
              context.goNamed(RouteName.transaction);
            } else {
              context.goNamed(RouteName.dashboard);
            }
          },
        ),
        if (showLogout)
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Logout',
            onPressed: () {
              context.read<AuthBloc>().add(const LogoutRequested());
              context.go(RouteName.login);
            },
          ),

        const SizedBox(width: 4),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
