import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/common/utils.dart';
import 'package:flutter_application_2/data/product.dart';
import 'package:flutter_application_2/data/repo/banner_repository.dart';
import 'package:flutter_application_2/data/repo/product_repository.dart';
import 'package:flutter_application_2/ui/home/bloc/home_bloc.dart';
import 'package:flutter_application_2/ui/list/list.dart';
import 'package:flutter_application_2/ui/product/product.dart';
import 'package:flutter_application_2/ui/widgets/error.dart';
import 'package:flutter_application_2/ui/widgets/slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final homeBloc = HomeBloc(
            bannerRepository: bannerRepository,
            productRepository: productRepository);
        homeBloc.add(HomeStarted());
        return homeBloc;
      },
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<HomeBloc, HomeState>(builder: ((context, state) {
            if (state is HomeSuccess) {
              return ListView.builder(
                  physics: defaultScrollPhysics,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    switch (index) {
                      case 0:
                        return Column(
                          children: [
                            Container(
                              height: 56,
                              alignment: Alignment.center,
                              child: Image.asset(
                                'assets/img/nike_logo.png',
                                fit: BoxFit.fitHeight,
                                height: 24,
                              ),
                            ),
                            Container(
                              height: 56,
                              margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  label: const Text('جستجو'),
                                  prefixIcon: IconButton(
                                    onPressed: () {
                                      _search(context);
                                    },
                                    icon: const Padding(
                                      padding: EdgeInsets.only(left: 8),
                                      child: Icon(CupertinoIcons.search),
                                    ),
                                  ),
                                  isCollapsed: false,
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(28),
                                      borderSide: BorderSide(
                                          width: 1,
                                          color:
                                              Theme.of(context).dividerColor)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(28),
                                      borderSide: BorderSide(
                                          width: 2,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary)),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                ),
                                textInputAction: TextInputAction.search,
                                style: Theme.of(context).textTheme.bodyMedium,
                                onSubmitted: (value) {
                                  _search(context);
                                },
                              ),
                            )
                          ],
                        );
                      case 2:
                        return BannerSlider(
                          banners: state.banners,
                        );
                      case 3:
                        return _HorizontalProductList(
                          title: 'جدیدترین',
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const ProductListScreen(
                                    sort: ProductSort.latest)));
                          },
                          products: state.latestProducts,
                        );
                      case 4:
                        return _HorizontalProductList(
                          title: 'پربازدیدترین',
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const ProductListScreen(
                                    sort: ProductSort.popular)));
                          },
                          products: state.popularProducts,
                        );
                      default:
                        return Container();
                    }
                  });
            } else if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HomeError) {
              return AppErrorWidget(
                exception: state.exception,
                onPressed: () {
                  BlocProvider.of<HomeBloc>(context).add(HomeRefresh());
                },
              );
            } else {
              throw Exception('state is not supported');
            }
          })),
        ),
      ),
    );
  }

  void _search(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            ProductListScreen.search(searchTerm: _searchController.text)));
  }
}

class _HorizontalProductList extends StatelessWidget {
  final String title;
  final GestureTapCallback onTap;
  final List<ProductEntity> products;
  const _HorizontalProductList({
    required this.title,
    required this.onTap,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              TextButton(onPressed: onTap, child: const Text('مشاهده همه'))
            ],
          ),
        ),
        SizedBox(
          height: 290,
          child: ListView.builder(
              physics: defaultScrollPhysics,
              itemCount: products.length,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 8, right: 8),
              itemBuilder: ((context, index) {
                final product = products[index];
                return ProductItem(
                  product: product,
                  borderRadius: BorderRadius.circular(12),
                );
              })),
        )
      ],
    );
  }
}
