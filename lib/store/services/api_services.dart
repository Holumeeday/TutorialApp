import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:basicpractices/store/model/product_model.dart';

class ApiServices {
  static const String baseUrl = "https://fakestoreapi.com/products";

  static Future<List<Product>> fetchProduct() async {

    final response = await  http.get(Uri.parse(baseUrl));

    if(response.statusCode == 200){
       List jsonData = json.decode(response.body);
       return jsonData.map((e)=> Product.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load Products");
    }
  }
}