import 'package:flutter/material.dart';
import 'package:flutter_application_2/common/utils.dart';
import 'package:flutter_application_2/data/favorite_manager.dart';
import 'package:flutter_application_2/data/product.dart';
import 'package:flutter_application_2/theme.dart';
import 'package:flutter_application_2/ui/product/detail.dart';
import 'package:flutter_application_2/ui/widgets/image.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FavoriteListScreen extends StatelessWidget {
  const FavoriteListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لیست علاقه مندی ها'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<Box<ProductEntity>>(
          valueListenable: favoriteManager.listenable,
          builder: (context, box, child) {
            final products = box.values.toList();
            return ListView.builder(
                padding: const EdgeInsets.only(top: 8, bottom: 100),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              DetailsProductScreen(product: product)));
                    },
                    onLongPress: () {
                      favoriteManager.delete(product);
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 110,
                            height: 110,
                            child: ImageLoadingService(
                                imageUrl: product.imageUrl,
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                          color: LightThemeColors
                                              .primaryTextColor),
                                ),
                                const SizedBox(
                                  height: 24,
                                ),
                                Text(
                                  product.previousPrice.withPriceLabel,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          decoration:
                                              TextDecoration.lineThrough),
                                ),
                                Text(product.price.withPriceLabel)
                              ],
                            ),
                          ))
                        ],
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
