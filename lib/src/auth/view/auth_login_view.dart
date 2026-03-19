import 'package:finfresh/src/auth/view/desktop/auth_login_desktop_view.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AuthLoginView extends StatelessWidget {
  const AuthLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveValue<Widget>(
      context,
      defaultValue: AuthLoginDesktopview(),
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: AuthLoginDesktopview()),
      ],
    ).value;
  }
}
