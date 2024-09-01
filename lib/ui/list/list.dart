// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/data/product.dart';
import 'package:flutter_application_2/data/repo/product_repository.dart';
import 'package:flutter_application_2/ui/list/bloc/product_list_bloc.dart';
import 'package:flutter_application_2/ui/product/product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductListScreen extends StatefulWidget {
  final String searchTerm;
  final int sort;
  const ProductListScreen({super.key, required this.sort}) : searchTerm = "";
  const ProductListScreen.search({
    Key? key,
    required this.searchTerm,
  }) : sort = ProductSort.popular;

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

enum ViewType { grid, list }

class _ProductListScreenState extends State<ProductListScreen> {
  ViewType viewType = ViewType.grid;
  ProductListBloc? bloc;

  @override
  void dispose() {
    bloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.searchTerm.isEmpty
            ? 'کفش های ورزشی'
            : 'نتایج جستجو${widget.searchTerm}'),
      ),
      body: BlocProvider<ProductListBloc>(
        create: (context) {
          bloc = ProductListBloc(productRepository)
            ..add(ProductListStarted(widget.sort, widget.searchTerm));
          return bloc!;
        },
        child: BlocBuilder<ProductListBloc, ProductListState>(
          builder: (context, state) {
            if (state is ProductListSuccess) {
              final products = state.products;
              return Column(
                children: [
                  if (widget.searchTerm.isEmpty)
                    Container(
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(
                                  width: 1,
                                  color: Theme.of(context).dividerColor)),
                          color: Theme.of(context).colorScheme.surface,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 20)
                          ]),
                      height: 56,
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(32))),
                              context: context,
                              builder: (context) {
                                return SizedBox(
                                  height: 300,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 24, top: 24),
                                    child: Column(
                                      children: [
                                        Text(
                                          'انتخاب مرتب سازی',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                        Expanded(
                                          child: ListView.builder(
                                              itemCount: state.sortNames.length,
                                              itemBuilder: (context, index) {
                                                final selectedSortIndex =
                                                    state.sort;
                                                return InkWell(
                                                  onTap: () {
                                                    bloc!.add(
                                                        ProductListStarted(
                                                            index,
                                                            widget.searchTerm));
                                                    Navigator.pop(context);
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(16, 8, 16, 8),
                                                    child: SizedBox(
                                                      height: 32,
                                                      child: Row(
                                                        children: [
                                                          Text(state.sortNames[
                                                              index]),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          if (index ==
                                                              selectedSortIndex)
                                                            Icon(
                                                              CupertinoIcons
                                                                  .check_mark_circled_solid,
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .primary,
                                                            )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, right: 8),
                                child: Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                            CupertinoIcons.sort_down)),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('مرتب سازی'),
                                        Text(
                                          ProductSort.names[state.sort],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 1,
                              color: Theme.of(context).dividerColor,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      viewType = viewType == ViewType.grid
                                          ? ViewType.list
                                          : ViewType.grid;
                                    });
                                  },
                                  icon: const Icon(
                                      CupertinoIcons.square_grid_2x2)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  Expanded(
                    child: GridView.builder(
                      itemCount: products.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 0.65,
                          crossAxisCount: viewType == ViewType.grid ? 2 : 1),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductItem(
                            product: product, borderRadius: BorderRadius.zero);
                      },
                    ),
                  ),
                ],
              );
            } else if (state is ProductListError) {
              return Center(
                child: Text(state.exception.message),
              );
            } else if (state is ProductListEmpty) {
              return Center(
                child: Text(state.message),
              );
            } else if (state is ProductListLoading) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            } else {
              throw Exception('state is not valid');
            }
          },
        ),
      ),
    );
  }
}
