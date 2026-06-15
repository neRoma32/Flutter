import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import 'settings_screen.dart';

class Product {
  final String nameKey; 
  final double price;
  final DateTime addedDate;

  Product({
    required this.nameKey,
    required this.price,
    required this.addedDate,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Product> _products = [
    Product(
      nameKey: 'productShirt',
      price: 250.00,
      addedDate: DateTime(2026, 2, 13),
    ),
    Product(
      nameKey: 'productShoes',
      price: 1500.00,
      addedDate: DateTime(2026, 2, 12),
    ),
  ];

  final List<Product> _templates = [
    Product(nameKey: 'productShirt', price: 320.00, addedDate: DateTime.now()),
    Product(nameKey: 'productShoes', price: 1800.00, addedDate: DateTime.now()),
    Product(nameKey: 'productJacket', price: 2450.00, addedDate: DateTime.now()),
  ];

  String _formatPrice(BuildContext context, double price) {
    final locale = Localizations.localeOf(context);
    
    String currencySymbol;
    switch (locale.languageCode) {
      case 'uk':
        currencySymbol = '₴';
        break;
      case 'pl':
        currencySymbol = 'zł';
        break;
      case 'en':
      default:
        currencySymbol = '\$';
    }

    final format = NumberFormat.currency(
      locale: locale.toString(),
      symbol: currencySymbol,
      decimalDigits: 2,
    );

    return format.format(price);
  }

  void _addProduct() {
    setState(() {
      final template = (_templates..shuffle()).first;
      _products.add(
        Product(
          nameKey: template.nameKey,
          price: template.price,
          addedDate: DateTime.now(),
        ),
      );
    });
  }

  void _removeProduct(int index) {
    setState(() {
      _products.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final List<Widget> tabs = [
      _buildProductsTab(context, l10n),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.blue,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.shopping_bag),
            label: l10n.productsTab,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: l10n.settingsTab,
          ),
        ],
      ),
    );
  }

  Widget _buildProductsTab(BuildContext context, AppLocalizations l10n) {
    final locale = Localizations.localeOf(context).toString();
    final dateFormat = DateFormat.yMMMMd(locale);

    final totalSum = _products.fold<double>(0.0, (sum, item) => sum + item.price);

    String getProductName(String key) {
      switch (key) {
        case 'productShirt':
          return l10n.productShirt;
        case 'productShoes':
          return l10n.productShoes;
        case 'productJacket':
          return l10n.productJacket;
        default:
          return key;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: l10n.add,
            onPressed: _addProduct,
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.helloUser('Олександр'),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),

          //список товарів
          Expanded(
            child: _products.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.shopping_basket_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.noProducts,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      final product = _products[index];
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.only(bottom: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          leading: const Text(
                            '📦',
                            style: TextStyle(fontSize: 32),
                          ),
                          title: Text(
                            getProductName(product.nameKey),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                _formatPrice(context, product.price),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.addedDate(dateFormat.format(product.addedDate)),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            tooltip: l10n.delete,
                            onPressed: () => _removeProduct(index),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          //панель знизу
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                )
              ],
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text('📊 ', style: TextStyle(fontSize: 18)),
                        Text(
                          l10n.itemsCount(_products.length),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text('💰 ', style: TextStyle(fontSize: 18)),
                        Text(
                          l10n.totalPrice(_formatPrice(context, totalSum)),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
