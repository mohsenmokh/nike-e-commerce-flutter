import 'package:flutter/material.dart';
import 'package:flutter_application_2/common/http_client.dart';
import 'package:flutter_application_2/data/auth_info.dart';
import 'package:flutter_application_2/data/source/auth_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authRepository = AuthRepository(AuthRemoteDataSource(httpClient));

abstract class IAuthRepository {
  Future<void> login(String username, String password);
  Future<void> signUp(String username, String password);
  Future<void> refreshToken();
  Future<void> signOut();
}

class AuthRepository implements IAuthRepository {
  static final ValueNotifier<AuthInfo?> authChangeNotifier =
      ValueNotifier(null);
  final IAuthDataSource dataSource;

  AuthRepository(
    this.dataSource,
  );

  static bool isUserLoggedIn() {
    return authChangeNotifier.value != null &&
        authChangeNotifier.value!.accessToken != null &&
        authChangeNotifier.value!.accessToken.isNotEmpty;
  }

  @override
  Future<void> login(String username, String password) async {
    final AuthInfo authInfo = await dataSource.login(username, password);
    _persisAuthTokens(authInfo);
    debugPrint("access token is: ${authInfo.accessToken}");
  }

  @override
  Future<void> signUp(String username, String password) async {
    final AuthInfo authInfo = await dataSource.signUp(username, password);
    _persisAuthTokens(authInfo);
    debugPrint("access token is: ${authInfo.accessToken}");
  }

  @override
  Future<void> refreshToken() async {
    if (authChangeNotifier.value != null) {
      final AuthInfo authInfo =
          await dataSource.refreshToken(authChangeNotifier.value!.refreshToken);
      debugPrint("refresh token is :${authInfo.refreshToken}");
      _persisAuthTokens(authInfo);
    }
  }

  @override
  Future<void> signOut() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.clear();
    authChangeNotifier.value = null;
  }

  Future<void> _persisAuthTokens(AuthInfo authInfo) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString("access_token", authInfo.accessToken);
    sharedPreferences.setString("refresh_token", authInfo.refreshToken);
    sharedPreferences.setString("email", authInfo.email);
    loadAuthInfo();
  }

  Future<void> loadAuthInfo() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final String accessToken =
        sharedPreferences.getString("access_token") ?? '';

    final String refreshToken =
        sharedPreferences.getString("refresh_token") ?? '';
    if (accessToken.isNotEmpty && refreshToken.isNotEmpty) {
      authChangeNotifier.value = AuthInfo(accessToken, refreshToken,
          sharedPreferences.getString("email") ?? '');
    }
  }
}
