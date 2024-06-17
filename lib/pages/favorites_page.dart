import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<Favorites>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Favorites'),
      ),
      body: ListView.builder(
        itemCount: favorites.favorites.length,
        itemBuilder: (context, index) {
          final favoriteItem = favorites.favorites[index];
          return ListTile(
            leading: Image.network(favoriteItem.imageUrl),
            title: Text(favoriteItem.name),
            subtitle: Text('\$${favoriteItem.price.toString()}'),
            trailing: IconButton(
              icon: Icon(Icons.remove_circle),
              onPressed: () {
                Provider.of<Favorites>(context, listen: false)
                    .removeFromFavorites(favoriteItem);
              },
            ),
          );
        },
      ),
    );
  }
}
