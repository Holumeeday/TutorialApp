import 'package:basicpractices/store/view/cart_screen.dart';
import 'package:flutter/material.dart';
import '../model/cart_manager.dart';
import '../model/product_model.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(product.image, height: 200),
              ),
              const SizedBox(height: 20),
              Text(
                product.title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                "\$${product.price}",
                style: const TextStyle(fontSize: 18, color: Colors.green),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber),
                  const SizedBox(width: 5),
                  Text(
                      "${product.rating.rate} (${product.rating.count} reviews)"),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                product.description,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: Colors.deepOrangeAccent,
            borderRadius: BorderRadius.circular(15)
          ),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.transparent,
            onPressed: (){
               CartManager.addToCart(product);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("${product.title} added to cart!"),
                  duration: const Duration(seconds: 2),
                ),
              );
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              );
            },
            icon: Icon(Icons.shopping_cart_checkout, color: Colors.white),
            label:  Text(
              'Add to Cart',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
        
            ),
        ),
      ),
    );
  }
}
