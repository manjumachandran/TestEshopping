import 'package:flutter/material.dart';

class CustomMenuWidget extends StatelessWidget {
  const CustomMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xff00838F),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Color(0xff00838F)),
                ),
                SizedBox(height: 10),
                Text(
                  'Welcome!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home, color: Color(0xff00838F)),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          ListTile(
            leading: const Icon(Icons.people, color: Color(0xff00838F)),
            title: const Text('Customers'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/customers');
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart, color: Color(0xff00838F)),
            title: const Text('Products'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/products');
            },
          ),
          ListTile(
            leading: const Icon(Icons.list, color: Color(0xff00838F)),
            title: const Text('Orders'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/orders');
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}
