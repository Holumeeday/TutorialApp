import 'package:basicpractices/store/services/api_services.dart';
import 'package:basicpractices/store/view/productdetailsScreen.dart';
import 'package:flutter/material.dart';

import '../model/product_model.dart';

class ProductlistScreen extends StatefulWidget {
  const ProductlistScreen({super.key});

  @override
  State<ProductlistScreen> createState() => _ProductlistScreenState();
}

class _ProductlistScreenState extends State<ProductlistScreen> {
  late Future<List<Product>> futureProducts;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    futureProducts = ApiServices.fetchProduct();
    print(futureProducts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'AJ Mall',
                  style: TextStyle(fontSize: 23),
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 40,
                      child: CircleAvatar(
                        radius: 50,
                        child: Text(
                          "AO",
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Icon(Icons.shopping_cart_checkout_outlined),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ],
            ),
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.amber,
                // image: DecorationImage(
                //   image: AssetImage("assets/images/banner.jpg"),
                //   fit: BoxFit.cover,
                // ),
              ),
              
            ),
             SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search products...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
              ),
            ),

            FutureBuilder(
                future: ApiServices.fetchProduct(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                      color: Colors.deepOrangeAccent,
                    ));
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Error: ${snapshot.error}",
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No products found 🚀"));
                  }

                  final products = snapshot.data!
                  .where((p)=> p.title.toLowerCase().contains(searchQuery)).toList();

                   if (products.isEmpty) {
                    return const Center(child: Text("No matching products ☹️"));
                  }

                  return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 2 items per row
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.7, // Adjust card height
                      ),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetailsScreen(product: product),
                              )),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 7),
                            child: Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Image.network(
                                      product.image,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          product.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          "\$${product.price}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.deepOrangeAccent,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          product.rating.rate > 4.0
                                              ? 'Trending Now'
                                              : 'Out of Stock',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: product.rating.rate > 4.0
                                                ? Colors.green
                                                : Colors.grey,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                }),
          ],
        ),
      ),
    );
  }
}
