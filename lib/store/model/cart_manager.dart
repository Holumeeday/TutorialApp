import 'package:basicpractices/store/model/product_model.dart';

class CartManager {
  static final List<Product> _cart = [];
  static List<Product> get cartItems => _cart;

  static void addToCart(Product product){
    _cart.add(product);
  }

  static void removeFromCart(Product product){
    _cart.remove(product);
  }

static double get totalPrice {
    return _cart.fold(0, (sum, item) => sum + item.price);
  }
}