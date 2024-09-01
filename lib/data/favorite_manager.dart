import 'package:flutter/foundation.dart';
import 'package:flutter_application_2/data/product.dart';
import 'package:hive_flutter/adapters.dart';

final favoriteManager = FavoriteManager();

class FavoriteManager {
  static const _boxName = 'favorite';
  ValueListenable<Box<ProductEntity>> get listenable =>
      Hive.box<ProductEntity>(_boxName).listenable();

  final _box = Hive.box(_boxName);

  static init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ProductEntityAdapter());
    Hive.openBox<ProductEntity>(_boxName);
  }

  void addFavorite(ProductEntity product) {
    _box.put(product.id, product);
  }

  void delete(ProductEntity product) {
    _box.delete(product.id);
  }

  List get favorites => _box.values.toList();

  bool isFavoirte(ProductEntity product) {
    return _box.containsKey(product.id);
  }
}
