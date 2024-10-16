import 'package:flutter/material.dart';
import 'dart:io';
import '../models/product.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;
  final VoidCallback onDelete;

  const ProductDetailsScreen({
    Key? key,
    required this.product,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.file(
              File(product.imagePath),
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            Text(
              product.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            Text('Цена: ${product.price} ₽',
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 10),
            Text(product.description),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                _showDeleteConfirmation(context);
              },
              child: const Text('Удалить товар'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Удалить товар'),
          content: const Text('Вы уверены, что хотите удалить товар?'),
          actions: [
            TextButton(
              child: const Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Удалить'),
              onPressed: () {
                onDelete();
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
}
