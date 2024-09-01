import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/data/repo/auth_repository.dart';
import 'package:flutter_application_2/data/repo/cart_repository.dart';
import 'package:flutter_application_2/ui/auth/auth.dart';
import 'package:flutter_application_2/ui/cart/bloc/cart_bloc.dart';
import 'package:flutter_application_2/ui/cart/cart_item.dart';
import 'package:flutter_application_2/ui/cart/price_info.dart';
import 'package:flutter_application_2/ui/shipping/shipping.dart';
import 'package:flutter_application_2/ui/widgets/empty_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartBloc? cartBloc;
  StreamSubscription? stateStreamSubscription;
  final RefreshController refreshController = RefreshController();
  bool stateIsSuccess = false;
  @override
  void initState() {
    super.initState();
    AuthRepository.authChangeNotifier.addListener(authChangeNotifierListener);
  }

  void authChangeNotifierListener() {
    cartBloc?.add(CartAuthInfoChanged(AuthRepository.authChangeNotifier.value));
  }

  @override
  void dispose() {
    super.dispose();
    AuthRepository.authChangeNotifier
        .removeListener(authChangeNotifierListener);
    cartBloc?.close();
    stateStreamSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Visibility(
        visible: stateIsSuccess,
        child: Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 48, right: 48),
            child: FloatingActionButton.extended(
                onPressed: () {
                  final state = cartBloc!.state;
                  if (state is CartSuccess) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ShippingScreen(
                              payablePrice: state.cartResponse.payablePrice,
                              shippingCost: state.cartResponse.shippingCost,
                              totalPrice: state.cartResponse.totalPrice,
                            )));
                  }
                },
                label: const Text('پرداخت'))),
      ),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('سبد خرید'),
      ),

      body: BlocProvider<CartBloc>(
        create: (context) {
          final bloc = CartBloc(cartRepository);
          stateStreamSubscription = bloc.stream.listen((state) {
            setState(() {
              stateIsSuccess = state is CartSuccess;
            });
            if (refreshController.isRefresh) {
              if (state is CartSuccess) {
                refreshController.refreshCompleted();
              }
            } else if (state is CartError) {
              refreshController.refreshFailed();
            }
          });
          cartBloc = bloc;
          bloc.add(CartStarted(
            AuthRepository.authChangeNotifier.value,
          ));
          return bloc;
        },
        child: BlocBuilder<CartBloc, CartState>(builder: (context, state) {
          if (state is CartLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is CartError) {
            return Center(
              child: Text(state.exception.message),
            );
          } else if (state is CartSuccess) {
            return SmartRefresher(
              header: const ClassicHeader(
                completeText: 'با موفقیت انجام شد',
                refreshingText: 'در حال به روزرسانی',
                idleText: 'برای به روزرسانی پایین بکشید',
                releaseText: 'رها کنید',
                failedText: 'خطای نامشخص',
                spacing: 2,
                completeIcon: Icon(
                  CupertinoIcons.checkmark_circle,
                  color: Colors.grey,
                  size: 20,
                ),
              ),
              onRefresh: () {
                cartBloc?.add(CartStarted(
                    AuthRepository.authChangeNotifier.value,
                    isRefreshing: true));
              },
              controller: refreshController,
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: state.cartResponse.cartItems.length + 1,
                itemBuilder: (context, index) {
                  if (index < state.cartResponse.cartItems.length) {
                    final data = state.cartResponse.cartItems[index];
                    return CartItem(
                      data: data,
                      onDeleteButtonClick: () {
                        cartBloc?.add(CartDeleteButtonClicked(data.id));
                      },
                      onIncreaseButtonClick: () {
                        cartBloc?.add(CartIncreaseCountButtonClicked(data.id));
                      },
                      onDecreaseButtonClick: () {
                        if (data.count > 1) {
                          cartBloc
                              ?.add(CartDecreaseCountButtonClicked(data.id));
                        }
                      },
                    );
                  } else {
                    return PriceInfo(
                      payablePrice: state.cartResponse.payablePrice,
                      shippingCost: state.cartResponse.shippingCost,
                      totalPrice: state.cartResponse.totalPrice,
                    );
                  }
                },
              ),
            );
          } else if (state is CartAuthRequired) {
            return EmptyView(
                message: 'برای مشاهده سبد خرید ابتدا وارد حساب کاربری خود شوید',
                image: SvgPicture.asset(
                  'assets/img/auth_required.svg',
                  width: 150,
                ),
                callToAction: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const AuthScreen()));
                    },
                    child: const Text('ورود به حساب کاربری')));
          } else if (state is CartEmpty) {
            return EmptyView(
              message: 'تا کنون هیچ ایتمی به سبد خرید خود اضافه نکرده اید',
              image: SvgPicture.asset(
                'assets/img/empty_cart.svg',
                width: 200,
              ),
            );
          } else {
            throw Exception('current cart state is not valid');
          }
        }),
      ),
      // body: ValueListenableBuilder(
      //   valueListenable: AuthRepository.authChangeNotifier,
      //   builder: (context, authState, child) {
      //     bool isAuthenticated =
      //         authState != null && authState.accessToken.isNotEmpty;
      //     return SizedBox(
      //       width: MediaQuery.of(context).size.width,
      //       child: Column(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           crossAxisAlignment: CrossAxisAlignment.center,
      //           children: [
      //             Text(isAuthenticated
      //                 ? 'خوش آمدید'
      //                 : 'لطفا وارد حساب کاربری خود شوید'),
      //             isAuthenticated
      //                 ? ElevatedButton(
      //                     onPressed: () {
      //                       authRepository.signOut();
      //                     },
      //                     child: const Text('خروج'))
      //                 : ElevatedButton(
      //                     onPressed: () {
      //                       Navigator.of(context, rootNavigator: true).push(
      //                           MaterialPageRoute(
      //                               builder: (context) => const AuthScreen()));
      //                     },
      //                     child: const Text('ورود')),
      //             ElevatedButton(
      //                 onPressed: () {
      //                   authRepository.refreshToken();
      //                 },
      //                 child: const Text('Refresh Token'))
      //           ]),
      //     );
      //   },
      // ),
    );
  }
}
