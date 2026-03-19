import 'package:finfresh/app/route_name.dart';
import 'package:finfresh/src/auth/bloc/auth_bloc.dart';
import 'package:finfresh/src/auth/view/auth_login_view.dart';
import 'package:finfresh/src/common/helper/refersh_stream.dart';
import 'package:finfresh/src/screen/dashboard/view/dashboard_view.dart';
import 'package:finfresh/src/screen/transactions/view/transaction_view.dart';
import 'package:go_router/go_router.dart';

class Routes {
  final AuthBloc authBloc;
  Routes(this.authBloc);
  GoRouter get router => GoRouter(
    initialLocation: RouteName.dashboard,
    routes: [
      GoRoute(
        path: RouteName.dashboard,
        name: RouteName.dashboard,
        builder: (context, state) {
          return DashboardView();
        },
      ),
      GoRoute(
        path: RouteName.transaction,
        name: RouteName.transaction,
        builder: (context, state) {
          return TransactionView();
        },
      ),
      GoRoute(
        path: RouteName.login,
        name: RouteName.login,
        builder: (context, state) {
          return AuthLoginView();
        },
      ),
    ],
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {

      final isLoggedIn = authBloc.state.status == AuthStatus.authenticated;

      final isLoginPage = state.matchedLocation == RouteName.login;

      if (!isLoggedIn && !isLoginPage) return RouteName.login;

      if (isLoggedIn && isLoginPage) return RouteName.dashboard;

      return null;
    },
  );
}
