import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart.dart';

class AnimatedAddToCartButton extends StatefulWidget {
  final Product product;

  AnimatedAddToCartButton({required this.product});

  @override
  _AnimatedAddToCartButtonState createState() =>
      _AnimatedAddToCartButtonState();
}

class _AnimatedAddToCartButtonState extends State<AnimatedAddToCartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addToCart() {
    Provider.of<Cart>(context, listen: false).addToCart(widget.product);
    _controller.forward().then((_) => _controller.reverse());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${widget.product.name} added to cart')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween(begin: 1.0, end: 1.2).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      ),
      child: ElevatedButton(
        onPressed: _addToCart,
        child: Text('Add to Cart'),
      ),
    );
  }
}
