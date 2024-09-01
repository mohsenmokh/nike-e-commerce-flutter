// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/common/utils.dart';
import 'package:flutter_application_2/data/product.dart';
import 'package:flutter_application_2/data/repo/cart_repository.dart';
import 'package:flutter_application_2/ui/product/bloc/product_bloc.dart';
import 'package:flutter_application_2/ui/product/comment/comment_list.dart';
import 'package:flutter_application_2/ui/product/comment/insert/insert_comment_dialog.dart';
import 'package:flutter_application_2/ui/widgets/image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailsProductScreen extends StatefulWidget {
  final ProductEntity product;
  const DetailsProductScreen({super.key, required this.product});

  @override
  State<DetailsProductScreen> createState() => _DetailsProductScreenState();
}

class _DetailsProductScreenState extends State<DetailsProductScreen> {
  StreamSubscription<ProductState>? stateSubscription;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  @override
  void dispose() {
    stateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider<ProductBloc>(
        create: (context) {
          final bloc = ProductBloc(cartRepository);
          stateSubscription = bloc.stream.listen((state) {
            if (state is ProductAddToCartSuccess) {
              _scaffoldKey.currentState?.showSnackBar(const SnackBar(
                  content: Text('با موفقیت به سبد خرید شما اضافه شد')));
            } else if (state is ProductAddToCartError) {
              _scaffoldKey.currentState?.showSnackBar(
                  SnackBar(content: Text(state.exception.message)));
            }
          });
          return bloc;
        },
        child: ScaffoldMessenger(
          key: _scaffoldKey,
          child: Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: SizedBox(
              width: MediaQuery.of(context).size.width - 48,
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) => FloatingActionButton.extended(
                  onPressed: () {
                    BlocProvider.of<ProductBloc>(context)
                        .add(CartAddButtonClick(widget.product.id));
                  },
                  label: state is ProductAddToCartButtonLoading
                      ? const CupertinoActivityIndicator(
                          color: Colors.white,
                        )
                      : const Text('افزودن به سبد خرید'),
                ),
              ),
            ),
            body: CustomScrollView(
              physics: defaultScrollPhysics,
              slivers: [
                SliverAppBar(
                  actions: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(CupertinoIcons.heart))
                  ],
                  expandedHeight: MediaQuery.of(context).size.width * 0.8,
                  flexibleSpace: ImageLoadingService(
                    imageUrl: widget.product.imageUrl,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.product.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(fontSize: 18),
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  widget.product.previousPrice.withPriceLabel,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          decoration:
                                              TextDecoration.lineThrough),
                                ),
                                Text(widget.product.price.withPriceLabel),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        const Text(
                          'این کتونی شدیدا برای دویدن و راه رفتن مناسب هست و تقریبا. هیچ فشار مخربی رو نمیذارد به پا و زانوان شما انتقال داده شود',
                          style: TextStyle(height: 1.4),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'نظرات کاربران',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(fontSize: 16),
                            ),
                            TextButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                      useRootNavigator: true,
                                      context: context,
                                      builder: (context) => InsertCommentDialog(
                                            productId: widget.product.id,
                                            scaffoldMessanger:
                                                _scaffoldKey.currentState,
                                          ));
                                },
                                child: const Text('ثبت نظر'))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                CommentList(productId: widget.product.id)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
