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
          children: [
             Padding(
               padding: const EdgeInsets.all(10.0),
               child: Row(
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
                      SizedBox(width: 10,),
                      Icon(Icons.shopping_cart_checkout_outlined)
                    ],
                  ),
                ],
                           ),
             ),
            FutureBuilder(
              future: futureProducts, 
              builder: (context, snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator(
                    color: Colors.deepOrangeAccent,
                  ));
                } else if(snapshot.hasError){
                  return Center(child: Text("Error: ${snapshot.error}", style: TextStyle(color: Colors.red),),);
                }else if (!snapshot.hasData || snapshot.data!.isNotEmpty){
                  return const Center(child: Text("No products found 🚀"));
                }
            
                final products = snapshot.data!;
            
                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index){
                    final product = products[index];
                    return ListTile(
                      leading: Image.network(product.image, width: 60,),
                      title: Text(
                      product.title,
                       maxLines: 1, 
                      overflow: TextOverflow.ellipsis,
                       style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 17, fontWeight: FontWeight.w400),),
                      subtitle: Text("\$${product.price}"),
                      onTap: (){
                        Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetailsScreen(product: product),
                              ),
                            );
            
                      },
                    );
                  }
                  );
              }),
          ],
        ),
      ),
    );
  }
}