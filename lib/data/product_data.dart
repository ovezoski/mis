import '../models/product.dart';

class ProductData {
  static final List<Product> products = [
    Product(
      name: 'White T-shirt',
      image: 'assets/tshirt.png',
      description: 'A classic cotton t-shirt',
      price: 19.99,
    ),
    Product(
      name: 'Red Shirt',
      image: 'assets/ts.png',
      description: 'A classic woolen t-shirt',
      price: 29.99,
    ),
    Product(
      name: 'Blue T',
      image: 'assets/blue.jpeg',
      description: 'A classic latex t-shirt',
      price: 9.99,
    ),
  ];
}
