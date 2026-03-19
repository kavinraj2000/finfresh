import 'dart:async';
import 'dart:convert';
import 'package:finfresh/src/common/consants/constants.dart';
import 'package:finfresh/src/domain/service/storage_service.dart';
import 'package:finfresh/src/domain/models/user_model.dart';
import 'package:flutter/services.dart';
import 'package:logger/web.dart';
import 'package:uuid/uuid.dart'; 

class AuthRepository {
  final log = Logger();
  final StorageService _storage = StorageService.instance;
  final _uuid = const Uuid();

  static const _sessionDuration = Duration(minutes: 1);

  UserModel? _currentUser;
  Timer? _sessionTimer;
  void Function()? onSessionExpired;

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _findUser(email);
      final token = _uuid.v4(); 
      await _saveToSecureStorage(email, password, user, token);
      _currentUser = user;
      _startSessionTimer();
      log.i('Login success → ${user.email} | token: $token');
      return user;
    } catch (e) {
      log.e('Login failed: $e');
      rethrow;
    }
  }

  Future<UserModel?> tryAutoLogin() async {
    try {
      final email = await _storage.read(key: Constants.APP.keyEmail);
      final password = await _storage.read(key: Constants.APP.keyPassword);

      if (email == null || password == null) {
        log.i('No saved credentials found');
        return null;
      }

      log.i('Saved credentials found → attempting auto-login');
      return await login(email: email, password: password);
    } catch (e) {
      log.w('Auto-login failed: $e');
      await clearSecureStorage();
      return null;
    }
  }

  Future<UserModel> _findUser(String email) async {
    final jsonString = await rootBundle.loadString(Constants.API.auth);
    final jsonData = jsonDecode(jsonString);
    final List<dynamic> users = jsonData['users'] ?? [jsonData];

    final match = users.firstWhere(
      (u) => u['email'] == email,
      orElse: () => throw Exception('User not found for email: $email'),
    );

    return UserModel.fromJson(match);
  }

  Future<void> _saveToSecureStorage(
    String email,
    String password,
    UserModel user,
    String token,
  ) async {
    await Future.wait([
      _storage.write(key: Constants.APP.keyEmail, value: email),
      _storage.write(key: Constants.APP.keyPassword, value: password),
      _storage.write(key: Constants.APP.keyUser, value: jsonEncode(user.toJson())),
      _storage.write(key: Constants.APP.keyToken, value: token), 
    ]);
    log.d('Credentials + token saved to secure storage');
  }

  Future<void> clearSecureStorage() async {
    await Future.wait([
      _storage.delete(key: Constants.APP.keyEmail),
      _storage.delete(key: Constants.APP.keyPassword),
      _storage.delete(key: Constants.APP.keyUser),
      _storage.delete(key: Constants.APP.keyToken), // clear token too
    ]);
    log.d('Secure storage cleared');
  }

  void _startSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = Timer(_sessionDuration, () {
      log.w('Session expired after 1 minute → auto logout');
      logout();
      onSessionExpired?.call();
    });
  }

  void resetSessionTimer() {
    if (_currentUser != null) {
      log.d('Session timer reset');
      _startSessionTimer();
    }
  }

  Future<String?> get token => _storage.read(key: Constants.APP.keyToken);
  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  Future<void> logout() async {
    _sessionTimer?.cancel();
    _sessionTimer = null;
    _currentUser = null;
    await clearSecureStorage();
    log.i('Logged out → secure storage cleared');
  }
}