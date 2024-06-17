import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/favorites.dart';

class FavoriteButton extends StatefulWidget {
  final Product product;

  FavoriteButton({required this.product});

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    isFavorite = Provider.of<Favorites>(context, listen: false)
        .favorites
        .contains(widget.product);
  }

  void _toggleFavorite() {
    setState(() {
      if (isFavorite) {
        Provider.of<Favorites>(context, listen: false)
            .removeFromFavorites(widget.product);
      } else {
        Provider.of<Favorites>(context, listen: false)
            .addToFavorites(widget.product);
      }
      isFavorite = !isFavorite;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFavorite
              ? '${widget.product.name} added to favorites'
              : '${widget.product.name} removed from favorites',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.red : Colors.grey,
      ),
      onPressed: _toggleFavorite,
    );
  }
}
