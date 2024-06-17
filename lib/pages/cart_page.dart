import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = context.watch<Cart>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Cart'),
      ),
      body: ListView.builder(
        itemCount: cart.items.length,
        itemBuilder: (context, index) {
          final cartItem = cart.items[index];
          return ListTile(
            leading: Image.network(cartItem.product.imageUrl),
            title: Text(cartItem.product.name),
            subtitle: Text('\$${cartItem.product.price.toString()}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    Provider.of<Cart>(context, listen: false)
                        .decreaseQuantity(cartItem);
                  },
                ),
                Text(cartItem.quantity.toString()),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Provider.of<Cart>(context, listen: false)
                        .increaseQuantity(cartItem);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.remove_circle),
                  onPressed: () {
                    Provider.of<Cart>(context, listen: false)
                        .removeFromCart(cartItem);
                  },
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total: \$${cart.totalPrice.toString()}'),
            ElevatedButton(
              onPressed: () {
              },
              child: Text('Checkout'),
            ),
          ],
        ),
      ),
    );
  }
}
