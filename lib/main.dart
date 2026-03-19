import 'package:finfresh/app/app.dart';
import 'package:finfresh/src/auth/repo/auth_repository.dart';
import 'package:flutter/material.dart';

final authRepository = AuthRepository();


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await authRepository.tryAutoLogin();
  runApp(App(authRepository: authRepository));
}
