import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class Product {
  final String name;
  final double price;
  final String imageUrl;

  Product({required this.name, required this.price, required this.imageUrl});
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class Cart with ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get totalPrice {
    return _items.fold(
        0, (total, item) => total + item.product.price * item.quantity);
  }

  void addToCart(Product product) {
    bool isExisting = false;
    for (var item in _items) {
      if (item.product.name == product.name) {
        item.quantity++;
        isExisting = true;
        break;
      }
    }
    if (!isExisting) {
      _items.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void removeFromCart(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void increaseQuantity(CartItem item) {
    item.quantity++;
    notifyListeners();
  }

  void decreaseQuantity(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
      notifyListeners();
    }
  }
}

class Favorites with ChangeNotifier {
  List<Product> _favorites = [];

  List<Product> get favorites => _favorites;

  void addToFavorites(Product product) {
    if (!_favorites.contains(product)) {
      _favorites.add(product);
      notifyListeners();
    }
  }

  void removeFromFavorites(Product product) {
    _favorites.remove(product);
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Cart()),
        ChangeNotifierProvider(create: (context) => Favorites()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Product> products = [
    Product(
        name: 'Product 1', price: 10, imageUrl: 'asset/image/product1.jpg'),
    Product(
        name: 'Product 2', price: 20, imageUrl: 'asset/image/prodct2.jpg'),
    Product(
        name: 'Product 3', price: 30, imageUrl: 'asset/image/product3.jpg'),
    Product(
        name: 'Product 4', price: 30, imageUrl: 'asset/image/product4.jpg'),
    Product(
        name: 'Product 5', price: 30, imageUrl: 'asset/image/product5.jpg'),
    Product(
        name: 'Product 6', price: 30, imageUrl: 'asset/image/product6.jpg'),
    Product(
        name: 'Product 7', price: 30, imageUrl: 'asset/image/product7.jpg'),
  ];

  String query = '';

  @override
  Widget build(BuildContext context) {
    final filteredProducts = products
        .where((product) =>
            product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          'Decorate & Elevate',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.shopping_bag),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  query = value;
                });
              },
            ),
          ),
        ),
      ),
      body: Container(
        height: 250,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: filteredProducts.length,
          itemBuilder: (context, index) {
            return Container(
              width: 200,
              margin: EdgeInsets.all(8),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(15),
                          ),
                          gradient: LinearGradient(
                            colors: [Colors.teal, Colors.blue],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(15),
                          ),
                          child: Image.network(
                            filteredProducts[index].imageUrl,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        filteredProducts[index].name,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('\$${filteredProducts[index].price.toString()}'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AnimatedAddToCartButton(product: filteredProducts[index]),
                        FavoriteButton(product: filteredProducts[index]),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

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
