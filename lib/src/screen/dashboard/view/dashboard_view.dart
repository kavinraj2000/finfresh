import 'package:finfresh/src/screen/dashboard/bloc/dashboard_bloc.dart';
import 'package:finfresh/src/screen/dashboard/repo/dashboard_repository.dart';
import 'package:finfresh/src/screen/dashboard/view/desktop/dashboard_desktop_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          DashboardBloc(repo: DashboardRepository())
            ..add(const LoadDashboard()),
      child: ResponsiveValue<Widget>(
        context,
        defaultValue: DashboardDesktopview(),
        conditionalValues: const [
          Condition.smallerThan(name: MOBILE, value: DashboardDesktopview()),
        ],
      ).value,
    );
  }
}
