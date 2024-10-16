import 'package:flutter/material.dart';
import '../models/product.dart';
import '../screens/product_details_screen.dart';
import '../screens/add_product_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/favorite_screen.dart';
import '../screens/cart_screen.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<Product> products = [];
  List<Product> favoriteProducts = [];
  List<Product> cartItems = [];

  void _navigateToAddProduct() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddProductScreen()),
    );
    if (result != null) {
      setState(() {
        products.insert(0, result);
      });
    }
  }

  void _navigateToProductDetails(Product product) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(
          product: product,
          onDelete: () => _removeProduct(product),
        ),
      ),
    );
    if (result != null && result == true) {
      setState(() {
        products.remove(product);
      });
    }
  }

  void _toggleFavorite(Product product) {
    setState(() {
      product.isFavorite = !product.isFavorite;
      if (product.isFavorite) {
        favoriteProducts.add(product);
      } else {
        favoriteProducts.remove(product);
      }
    });
  }


  void _addToCart(Product product) {
      setState(() {
        var foundProduct = cartItems.firstWhere(
              (cartProduct) => cartProduct.name == product.name,
          orElse: () => Product(
            name: '',
            description: '',
            price: 0.0,
            imagePath: '',
          ),
        );

        if (foundProduct.name == '') {
          cartItems.add(Product(
            name: product.name,
            description: product.description,
            price: product.price,
            imagePath: product.imagePath,
            isFavorite: product.isFavorite,
            quantity: 1,
          ));
        } else {
          foundProduct.quantity++;
        }
      });
    }

    void _removeProduct(Product product) {
      setState(() {
        products.remove(product);
      });
    }

    List<Widget> _screens() {
      return [
        _buildProductScreen(),
        FavoriteScreen(
          favoriteProducts: favoriteProducts,
          onToggleFavorite: _toggleFavorite,
          onAddToCart: _addToCart,
          onNavigateToDetails: _navigateToProductDetails,
        ),
        CartScreen(
          cartItems: cartItems,
          onProductRemoved: (product) {
            setState(() {
              cartItems.remove(product);
            });
          },
        ),
        const ProfileScreen(),
      ];
    }

    Widget _buildProductScreen() {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Витрина товаров'),
        ),
        body: products.isEmpty
            ? const Center(child: Text('Нет добавленных товаров'))
            : GridView.builder(
          padding: const EdgeInsets.all(10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return GestureDetector(
              onTap: () => _navigateToProductDetails(product),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16)),
                        child: Image.file(
                          File(product.imagePath),
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            product.name,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 5),
                          Text('Цена: ${product.price} ₽',
                              style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(
                            product.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: product.isFavorite ? Colors.red : null,
                          ),
                          onPressed: () => _toggleFavorite(product),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_shopping_cart),
                          onPressed: () => _addToCart(product),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _navigateToAddProduct,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          child: const Icon(Icons.add),
        ),
      );
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: _screens()[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.storefront_outlined),
              label: 'Товары',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              label: 'Избранное',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  const Icon(Icons.shopping_cart_outlined),
                  if (cartItems.isNotEmpty)
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          cartItems
                              .fold<int>(0, (sum, product) => sum + product.quantity)
                              .toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              label: 'Корзина',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Профиль',
            ),
          ],
        ),
      );
    }
  }
