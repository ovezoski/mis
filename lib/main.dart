import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '211521 Blagoja Ovezoski MIS Project',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 215, 170, 162)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '211521 BO'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Map<String, dynamic>> products = [
    {
      'name': 'White T-shirt',
      'image': 'assets/tshirt.png',
      'description': 'A classic cotton t-shirt',
      'price': 19.99,
    },
    {
      'name': 'Red Shirt',
      'image': 'assets/ts.png',
      'description': 'A classic woolen t-shirt',
      'price': 29.99,
    },
    {
      'name': 'Blue T',
      'image': 'assets/blue.jpeg',
      'description': 'A classic latex t-shirt',
      'price': 9.99,
    },
  ];

  void _navigateToProductDetails(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(product: products[index]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _navigateToProductDetails(index),
            child: Card(
              child: Column(
                children: [
                  Image.asset(products[index]['image']),
                  Text(products[index]['name']),
                  Text('\$${products[index]['price']}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProductDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['name']),
      ),
      body: Center(
        child: Column(
          children: [
            Image.asset(product['image']),
            Text(product['description']),
            Text('\$${product['price']}'),
          ],
        ),
      ),
    );
  }
}
