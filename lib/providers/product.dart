import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    @required this.price,
    this.isFavourite = false,
  });

  void _setFavStatus(bool newValue) {
    isFavourite = newValue;
    notifyListeners();
  }

  Future<void> toggleFav(String token, String userId) async {
    final oldValue = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    final url =
        'https://e-commerce-app-5f025-default-rtdb.firebaseio.com/product/userFav/$userId/$id.json?auth=$token';
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavourite,
        ),
      );
      if (response.statusCode >= 400) {
        _setFavStatus(oldValue);
      }
    } catch (error) {
      _setFavStatus(oldValue);
    }
  }
}
