import 'package:finfresh/app/routes.dart';
import 'package:finfresh/src/auth/bloc/auth_bloc.dart';
import 'package:finfresh/src/auth/repo/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

class App extends StatelessWidget {
  final AuthRepository authRepository;

  App({super.key, required this.authRepository});

  late final AuthBloc authBloc = AuthBloc(authRepository: authRepository);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: authBloc..add(const AppStarted()),
      child: MaterialApp.router(
        builder: (context, child) => ResponsiveBreakpoints.builder(
          child: child!,
          breakpoints: const [
            Breakpoint(start: 375, end: 450, name: MOBILE),
            Breakpoint(start: 451, end: 800, name: TABLET),
            Breakpoint(start: 801, end: 1920, name: DESKTOP),
            Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
        ),
        debugShowCheckedModeBanner: false,

        routerConfig: Routes(authBloc).router,
      ),
    );
  }
}
