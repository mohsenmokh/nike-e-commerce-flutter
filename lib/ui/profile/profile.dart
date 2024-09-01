import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/data/auth_info.dart';
import 'package:flutter_application_2/data/repo/auth_repository.dart';
import 'package:flutter_application_2/data/repo/cart_repository.dart';
import 'package:flutter_application_2/ui/auth/auth.dart';
import 'package:flutter_application_2/ui/favorites/favorites.dart';
import 'package:flutter_application_2/ui/order/order_history.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('پروفایل'),
      ),
      body: ValueListenableBuilder<AuthInfo?>(
          valueListenable: AuthRepository.authChangeNotifier,
          builder: (context, authInfo, child) {
            final isLogin = authInfo != null && authInfo.accessToken.isNotEmpty;
            return Center(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 32, bottom: 8),
                    padding: const EdgeInsets.all(8),
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            width: 1, color: Theme.of(context).dividerColor)),
                    child: Image.asset(
                      'assets/img/nike_logo.png',
                    ),
                  ),
                  Text(isLogin ? authInfo.email : 'کاربر میهمان'),
                  const SizedBox(
                    height: 32,
                  ),
                  const Divider(
                    height: 1,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const FavoriteListScreen()));
                    },
                    child: Container(
                      height: 56,
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: const Row(
                        children: [
                          Icon(CupertinoIcons.heart),
                          SizedBox(
                            width: 16,
                          ),
                          Text('لیست علاقه مندی ها')
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    height: 1,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const OrderHistoryScreen()));
                    },
                    child: Container(
                      height: 56,
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: const Row(
                        children: [
                          Icon(CupertinoIcons.cart),
                          SizedBox(
                            width: 16,
                          ),
                          Text('سوابق سفارش')
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    height: 1,
                  ),
                  InkWell(
                    onTap: () {
                      if (isLogin) {
                        showDialog(
                            useRootNavigator: true,
                            context: context,
                            builder: (context) {
                              return Directionality(
                                textDirection: TextDirection.rtl,
                                child: AlertDialog(
                                  title: const Text('خروج از حساب کاربری'),
                                  content: const Text(
                                      'آیا میخواهید از حساب خود خارج شوید؟'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('بله')),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          CartRepository
                                              .cartItemCountNotifier.value = 0;
                                          authRepository.signOut();
                                        },
                                        child: const Text('خیر'))
                                  ],
                                ),
                              );
                            });
                      } else {
                        Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                                builder: (context) => const AuthScreen()));
                      }
                    },
                    child: Container(
                      height: 56,
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Row(
                        children: [
                          Icon(isLogin
                              ? CupertinoIcons.arrow_right_square
                              : CupertinoIcons.arrow_left_square),
                          const SizedBox(
                            width: 16,
                          ),
                          Text(isLogin
                              ? 'خروج از حساب کاربری'
                              : 'ورود به حساب کاربری')
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    height: 1,
                  ),
                ],
              ),
            );
          }),
    );
  }
}
