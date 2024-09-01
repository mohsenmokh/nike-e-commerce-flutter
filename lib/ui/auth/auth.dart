// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_application_2/data/repo/auth_repository.dart';
import 'package:flutter_application_2/data/repo/cart_repository.dart';
import 'package:flutter_application_2/ui/auth/bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController usernameController =
      TextEditingController(text: 'test@gmail.com');
  final TextEditingController passwordController =
      TextEditingController(text: '123456');

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    const onBackground = Colors.white;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Theme(
        data: themeData.copyWith(
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  minimumSize: WidgetStateProperty.all(
                    const Size.fromHeight(56),
                  ),
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  )),
                  backgroundColor: WidgetStateProperty.all(onBackground),
                  foregroundColor:
                      WidgetStateProperty.all(themeData.colorScheme.secondary)),
            ),
            inputDecorationTheme: InputDecorationTheme(
                labelStyle: const TextStyle(
                  color: onBackground,
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: onBackground),
                  borderRadius: BorderRadius.circular(12),
                ))),
        child: Scaffold(
          backgroundColor: themeData.colorScheme.secondary,
          body: BlocProvider(
            create: (context) {
              final bloc =
                  AuthBloc(authRepository, cartRepository: cartRepository);
              bloc.stream.forEach((state) {
                if (state is AuthSuccess) {
                  Navigator.of(context).pop();
                } else if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.exception.message)));
                }
              });
              bloc.add(AuthStarted());
              return bloc;
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 48, right: 48),
              child: BlocBuilder<AuthBloc, AuthState>(
                buildWhen: (previous, current) {
                  return current is AuthLoading ||
                      current is AuthError ||
                      current is AuthInitial;
                },
                builder: (context, state) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/img/nike_logo.png',
                        color: Colors.white,
                        width: 120,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Text(
                        state.isLoginMode ? 'خوش آمدید' : 'ثبت نام',
                        style:
                            const TextStyle(color: onBackground, fontSize: 22),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        state.isLoginMode
                            ? 'لطفا وارد حساب کاربری خود شوید'
                            : 'ایمیل و رمز عبور خود را تعیین کنید',
                        style:
                            const TextStyle(color: onBackground, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      TextField(
                        controller: usernameController,
                        style: const TextStyle(color: onBackground),
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          label: Text('آدرس ایمیل'),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      _PasswordTextField(
                        onBackground: onBackground,
                        controller: passwordController,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          BlocProvider.of<AuthBloc>(context).add(
                              AuthButtonIsClicked(usernameController.text,
                                  passwordController.text));
                        },
                        child: state is AuthLoading
                            ? const CircularProgressIndicator()
                            : Text(
                                state.isLoginMode ? 'ورود' : 'ثبت نام',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      GestureDetector(
                        onTap: () {
                          BlocProvider.of<AuthBloc>(context)
                              .add(AuthChangeModeIsClicked());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.isLoginMode
                                  ? 'حساب کاربری ندارید؟'
                                  : 'حساب کاربری دارید؟',
                              style: TextStyle(
                                  color: onBackground.withOpacity(0.7)),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              state.isLoginMode ? 'ثبت نام' : 'ورود',
                              style: TextStyle(
                                  color: themeData.colorScheme.primary,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final Color onBackground;
  const _PasswordTextField({
    required this.onBackground,
    required this.controller,
  });

  @override
  State<_PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<_PasswordTextField> {
  bool obsecureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      style: const TextStyle(color: Colors.white),
      keyboardType: TextInputType.visiblePassword,
      obscureText: obsecureText,
      decoration: InputDecoration(
        suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                obsecureText = !obsecureText;
              });
            },
            icon: Icon(
              obsecureText
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: widget.onBackground.withOpacity(0.6),
            )),
        label: const Text('رمز عبور'),
      ),
    );
  }
}
