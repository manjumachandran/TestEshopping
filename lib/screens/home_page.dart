import 'package:flutter/material.dart';
import 'package:test_eshopping/screens/customer_actions.dart';
import 'package:test_eshopping/screens/order_page.dart';
import 'package:test_eshopping/screens/products_page.dart';
import 'package:test_eshopping/utilsils/utilsils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
   
    Size size = MediaQuery.of(context).size;
    double buttonWidth = ResponsiveUtils.getButtonWidth(context);
    double buttonHeight =ResponsiveUtils.getButtonHeight(context);
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/backgroundcustomer.jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3), 
              BlendMode.darken, 
            ),
          ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: size.height * 0.05), 
                 CircleAvatar(
        radius: size.width * 0.10 > 80? 80 : size.width * 0.10,
        backgroundImage: const NetworkImage('https://cxotoday.com/wp-content/uploads/2019/10/ecommerce45.jpg'), 
      ),
      SizedBox(height: size.height * 0.05), Text(
        "Explore and Manage Your Business",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: size.width * 0.04,
          color: Colors.white70,
        ),
      ),
                // SizedBox(height: size.height * 0.5), 
                GestureDetector(
                  child: Container(
                     margin: const EdgeInsets.all(10),
                     padding: const EdgeInsets.all(20),
                    height: buttonHeight,
                    width: buttonWidth,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                      colors: [Color(0xff00838F), Color(0xff004D40)],
                    ),
                    borderRadius: BorderRadius.circular(buttonHeight * 0.3),
                    ),
                    child:  Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.people, color: Colors.white, size: buttonHeight * 0.4),
                          const SizedBox(width: 10),
                          const Text(
                            "Customers",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CustomerActionPage()),
                    );
                  },
                ),
                GestureDetector(
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(20),
                    height: buttonHeight,
                    width: buttonWidth,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                      colors: [Color(0xff00838F), Color(0xff004D40)],
                    ),
                    borderRadius: BorderRadius.circular(buttonHeight * 0.3),
                    ),
                    child:  Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.shopping_cart, color: Colors.white, size: buttonHeight * 0.4),
                          const SizedBox(width: 10),
                          const Text(
                            "Products",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Products()));
                  },
                ),
                GestureDetector(
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(20),
                    height: buttonHeight,
                    width: buttonWidth,
                    decoration: BoxDecoration(
                       gradient: const LinearGradient(
                      colors: [Color(0xff00838F), Color(0xff004D40)],
                    ),
                    borderRadius: BorderRadius.circular(buttonHeight * 0.3),
                    ),
                    child:  Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.shopping_bag,color: Colors.white,size: buttonHeight*0.4,),
                          const SizedBox(width: 10),
                          const Text(
                            "Orders",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const OrderPage()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
